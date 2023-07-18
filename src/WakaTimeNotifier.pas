unit WakaTimeNotifier;

interface

uses
  Classes, SysUtils, ToolsAPI;

type
  TSourceEditorNotifier = class(TNotifierObject, IOTANotifier,
    IOTAEditorNotifier)
  private
    FEditor: IOTASourceEditor;
    FIndex: Integer;
    FProjectName: string;

    procedure SendHeartbeat(FileName: string; TotalLines: Integer; IsWrite:
      Boolean);

    { IOTANotifier }
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;

    { IOTAEditorNotifier }
    procedure ViewActivated(const View: IOTAEditView);
    procedure ViewNotification(const View: IOTAEditView; Operation: TOperation);
  public
    constructor Create(AEditor: IOTASourceEditor; const ProjectName: string);
    destructor Destroy; override;
  end;

  TIDENotifier = class(TNotifierObject, IOTANotifier, IOTAIDENotifier)
  private
    { IOTAIDENotifier }
    procedure FileNotification(NotifyCode: TOTAFileNotification; const FileName:
      string; var Cancel: Boolean);
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
      overload;
    procedure AfterCompile(Succeeded: Boolean); overload;
  end;

procedure Register;

implementation

uses
  Windows,
  WakaTimeHeartbeatSender,
  WakaTimeLogger;

var
  SourceEditorNotifiers: TList = nil;
  IDENotifierIndex: Integer = -1;
  WakaTimeHeartbeatSender: TWakaTimeHeartbeatSender;


procedure ClearSourceEditorNotifiers;
var
  I: Integer;
begin
  if Assigned(SourceEditorNotifiers) then
   begin
    for I := SourceEditorNotifiers.Count - 1 downto 0 do
      TObject(SourceEditorNotifiers[I]).Free;
    SourceEditorNotifiers.Clear;
   end;
end;

procedure InstallSourceEditorNotifiers(Module: IOTAModule);
var
  I: Integer;
  SourceEditor: IOTASourceEditor;
  Project: IOTAProject;
  ProjectName: string;
begin
  TWakaTimeLogger.Log('InstallSourceEditorNotifiers called for: ' + Module.FileName);

  Project := GetActiveProject;

  if Project <> nil then
    ProjectName := ExtractFileName(Project.FileName)
  else
    ProjectName := '';

  TWakaTimeLogger.Log('ProjectName: ' + ProjectName);

  for I := 0 to Module.ModuleFileCount - 1 do
  begin
    TWakaTimeLogger.Log('Checking file: ' + Module.ModuleFileEditors[I].FileName);

    if Supports(Module.ModuleFileEditors[I], IOTAEditor, SourceEditor) then
    begin
      TWakaTimeLogger.Log('File supports IOTAEditor: ' + Module.ModuleFileEditors[I].FileName);

      try
        SourceEditorNotifiers.Add(TSourceEditorNotifier.Create(SourceEditor, ProjectName));
        TWakaTimeLogger.Log('Notifier created for: ' + SourceEditor.FileName);
      except
        on E: Exception do
          TWakaTimeLogger.Log('Exception when creating notifier for: ' + SourceEditor.FileName + '. Error: ' + E.Message);
      end;

      SourceEditor := nil;
    end
    else
      TWakaTimeLogger.Log('File does not support IOTAEditor: ' + Module.ModuleFileEditors[I].FileName);
  end;
end;



procedure Register;
var
  Services: IOTAServices;
  ModuleServices: IOTAModuleServices;
  EditorServices: IOTAEditorServices;
  EditorTopView: IOTAEditView;
  I, J: Integer;
begin
  SourceEditorNotifiers := TList.Create;

  // install IDE notifier so that we can install editor notifiers for any newly opened module
  Services := BorlandIDEServices as IOTAServices;
  IDENotifierIndex := Services.AddNotifier(TIDENotifier.Create);

  // install editor notifiers for all currently open modules
  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  if ModuleServices.ModuleCount = 0 then
    Exit;
  for I := 0 to ModuleServices.ModuleCount - 1 do
    InstallSourceEditorNotifiers(ModuleServices.Modules[I]);

  // hook currently active module
  EditorServices := BorlandIDEServices as IOTAEditorServices;
  if not Assigned(EditorServices) then
    Exit;

  EditorTopView := EditorServices.TopView;
  if not Assigned(EditorTopView) then
    Exit;

  for I := 0 to SourceEditorNotifiers.Count - 1 do
    with TSourceEditorNotifier(SourceEditorNotifiers[I]) do
      for J := 0 to FEditor.EditViewCount - 1 do
        if FEditor.EditViews[J] = EditorTopView then
        begin
          ViewActivated(EditorTopView);
          Exit;
        end;
end;

procedure RemoveIDENotifier;
var
  Services: IOTAServices;
begin
  Services := BorlandIDEServices as IOTAServices;
  if Assigned(Services) then
    Services.RemoveNotifier(IDENotifierIndex);
end;

procedure TSourceEditorNotifier.SendHeartbeat(FileName: string; TotalLines:
  Integer; IsWrite: Boolean);
begin
  WakaTimeHeartbeatSender.SendHeartbeat(FileName, FProjectName, TotalLines, IsWrite);
end;

procedure TSourceEditorNotifier.Destroyed;
begin
  FEditor.RemoveNotifier(FIndex);
end;

procedure TSourceEditorNotifier.Modified;
begin
  try
    SendHeartbeat(FEditor.FileName, FEditor.GetLinesInBuffer, True);
  except
    // eating
  end;
end;

procedure TSourceEditorNotifier.ViewActivated(const View: IOTAEditView);
begin
  SendHeartbeat(FEditor.FileName, FEditor.GetLinesInBuffer, False);
end;

procedure TSourceEditorNotifier.ViewNotification(const View: IOTAEditView;
  Operation: TOperation);
begin
  SendHeartbeat(FEditor.FileName, FEditor.GetLinesInBuffer, False);
end;

procedure TSourceEditorNotifier.AfterSave;
begin
  SendHeartbeat(FEditor.FileName, FEditor.GetLinesInBuffer, True);
end;

procedure TSourceEditorNotifier.BeforeSave;
begin
  SendHeartbeat(FEditor.FileName, FEditor.GetLinesInBuffer, True);
end;

constructor TSourceEditorNotifier.Create(AEditor: IOTASourceEditor; const
  ProjectName: string);
begin
  inherited Create;
  FEditor := AEditor;
  FIndex := FEditor.AddNotifier(Self);
  FProjectName := ProjectName;
end;

destructor TSourceEditorNotifier.Destroy;
begin
  SourceEditorNotifiers.Remove(Self);
  FEditor := nil;

  inherited Destroy;
end;

procedure TIDENotifier.AfterCompile(Succeeded: Boolean);
var
  Project: IOTAProject;
  ProjectName: string;
  EditorServices: IOTAEditorServices;
  EditBuffer: IOTAEditBuffer;
  SourceEditor: IOTASourceEditor;
begin
  Project := GetActiveProject;

  if Project <> nil then
   ProjectName := ExtractFileName(Project.FileName)
  else
   ProjectName := '';

  EditorServices := BorlandIDEServices as IOTAEditorServices;
  if Assigned(EditorServices) then
  begin
    EditBuffer := EditorServices.TopBuffer;
    if Assigned(EditBuffer) and Supports(EditBuffer, IOTASourceEditor,
      SourceEditor) then
    begin
      TSourceEditorNotifier.Create(SourceEditor,
        ProjectName).SendHeartbeat(SourceEditor.FileName,
        SourceEditor.GetLinesInBuffer, False);
      SourceEditor := nil;
    end;
  end;
end;

procedure TIDENotifier.BeforeCompile(const Project: IOTAProject; var Cancel:
  Boolean);
var
  SourceEditor: IOTASourceEditor;
begin
  if Assigned(Project) then
  begin
    SourceEditor := Project.CurrentEditor as IOTASourceEditor;
    TSourceEditorNotifier.Create(SourceEditor,
      Project.FileName).SendHeartbeat(Project.FileName,
      SourceEditor.GetLinesInBuffer, False);
  end;
end;

procedure TIDENotifier.FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
var
  ModuleServices: IOTAModuleServices;
  Module: IOTAModule;
  EditorServices: IOTAEditorServices;
  EditBuffer: IOTAEditBuffer;
  SourceEditor: IOTASourceEditor;
  Project: IOTAProject;
  ProjectName: string;
begin
  TWakaTimeLogger.Log('FileNotification called for: ' + FileName);

  // Ignore .bpg files
  if ExtractFileExt(FileName) = '.bpg' then
  begin
    TWakaTimeLogger.Log('Ignoring .bpg file: ' + FileName);
    Exit;
  end;

  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  Module := ModuleServices.FindModule(FileName);

  if Assigned(Module) then
  begin
    TWakaTimeLogger.Log('Module found for: ' + FileName);

    Project := GetActiveProject;

    if Project <> nil then
      ProjectName := ExtractFileName(Project.FileName)
    else
      ProjectName := '';

    TWakaTimeLogger.Log('ProjectName: ' + ProjectName);

    case NotifyCode of
      ofnFileOpened:
        begin
          TWakaTimeLogger.Log('File opened: ' + FileName);
          InstallSourceEditorNotifiers(Module);
        end;
      ofnFileClosing:
        begin
          TWakaTimeLogger.Log('File closing: ' + FileName);
          EditorServices := BorlandIDEServices as IOTAEditorServices;
          if Assigned(EditorServices) then
          begin
            EditBuffer := EditorServices.TopBuffer;
            if Assigned(EditBuffer) and Supports(EditBuffer, IOTASourceEditor, SourceEditor) then
            begin
              TSourceEditorNotifier.Create(SourceEditor, ProjectName).SendHeartbeat(SourceEditor.FileName, SourceEditor.GetLinesInBuffer, False);
            end;
          end;
        end;
    end;
  end
  else
    TWakaTimeLogger.Log('No module found for: ' + FileName);
end;


initialization
  WakaTimeHeartbeatSender := TWakaTimeHeartbeatSender.Create;

finalization
  RemoveIDENotifier;
  ClearSourceEditorNotifiers;
  FreeAndNil(SourceEditorNotifiers);
  FreeAndNil(WakaTimeHeartbeatSender);

end.
