unit WakaSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Menus, ToolsApi, WakaTimeLogger;

type
  TWakaTimeSettingsForm = class(TForm)
    ButtonOk: TBitBtn;
    ButtonCancel: TBitBtn;
    Label1: TLabel;
    EditApiKey: TEdit;
    CheckBoxDebugMode: TCheckBox;
  private
    { Private declarations }
  public

  end;

  TWakaTimeMenu = class(TMenuItem)
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenSettingsMenuClick(Sender: TObject);
  end;

  TWakaTimeTimer = class(TTimer)
  public
    constructor Create(AOwner: TComponent); override;
    procedure OnCreationTimerTriggered(Sender: TObject);
  end;

var
  WakaTimeSettingsForm: TWakaTimeSettingsForm;

procedure Register;

implementation

uses
  IniFiles, WakaTimeSettings;

var
  WakaTimeMenuItem: TMenuItem = nil;
  MenuCreationTimer: TWakaTimeTimer = nil;

{$R *.dfm}


procedure AddWakaTimeMenuItem;
var
  ToolsMenu: TMenuItem;
begin
  // Find the Tools menu.
  ToolsMenu := (BorlandIDEServices as INTAServices).MainMenu.Items.Find('Tools');

  // Create the WakaTime menu item.
  WakaTimeMenuItem := TWakaTimeMenu.Create(ToolsMenu);

  // Add the WakaTime menu item to the Tools menu.
  ToolsMenu.Add(WakaTimeMenuItem);
end;

procedure Register;
begin
  if MenuCreationTimer = nil then
   begin
    MenuCreationTimer := TWakaTimeTimer.Create(nil);
    TWakaTimeLogger.Log('WakaTimeTimer Created');
   end;
end;


//procedure Register;
//var
//  ToolsMenu: TMenuItem;
//begin
//  // Find the Tools menu.
//  ToolsMenu := (BorlandIDEServices as INTAServices).MainMenu.Items.Find('Tools');
//
//  // Create the WakaTime menu item.
//  WakaTimeMenuItem := TWakaTimeMenu.Create(ToolsMenu);
//
//  // Add the WakaTime menu item to the Tools menu.
//  ToolsMenu.Add(WakaTimeMenuItem);
//end;

{ TWakaTimeMenu }

constructor TWakaTimeMenu.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'WakaTime Settings';
  OnClick := OpenSettingsMenuClick;
end;

procedure TWakaTimeMenu.OpenSettingsMenuClick(Sender: TObject);
var
  SettingsForm: TWakaTimeSettingsForm;
begin
  SettingsForm := TWakaTimeSettingsForm.Create(nil);
  try
    SettingsForm.EditApiKey.Text := WakaSettings.ApiKey;
    SettingsForm.CheckBoxDebugMode.Checked := WakaSettings.Debug;

    if SettingsForm.ShowModal = mrOk then
    begin
      WakaSettings.ApiKey := SettingsForm.EditApiKey.Text;
      WakaSettings.Debug := SettingsForm.CheckBoxDebugMode.Checked;
      WakaSettings.Save;
    end;
  finally
    SettingsForm.Free;
  end;
end;

procedure RemoveWakaTimeMenuItem;
var
  ToolsMenu: TMenuItem;
begin
  if Assigned(WakaTimeMenuItem) then
  begin
    ToolsMenu := (BorlandIDEServices as INTAServices).MainMenu.Items.Find('Tools');
    ToolsMenu.Remove(WakaTimeMenuItem);
    WakaTimeMenuItem.Free;
  end;
end;

{ TWakaTimeTimer }

constructor TWakaTimeTimer.Create(AOwner: TComponent);
begin
  inherited;
  Interval := 500;  // 500 ms delay
  OnTimer := OnCreationTimerTriggered;
end;

procedure TWakaTimeTimer.OnCreationTimerTriggered(Sender: TObject);
var
  ToolsMenu: TMenuItem;
begin
  // Disable the timer.
  MenuCreationTimer.Enabled := False;

  // Find the Tools menu.
  ToolsMenu := (BorlandIDEServices as INTAServices).MainMenu.Items.Find('Tools');

  if Assigned(ToolsMenu) then
   AddWakaTimeMenuItem
  else
   MenuCreationTimer.Enabled := True;
end;

initialization

finalization
  RemoveWakaTimeMenuItem;


end.
