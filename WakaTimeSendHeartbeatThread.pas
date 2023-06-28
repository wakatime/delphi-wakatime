unit WakaTimeSendHeartbeatThread;

interface

uses
  Classes, SysUtils, ToolsAPI;

type
  TSendHeartbeatThread = class(TThread)
  private
    FCLIPath: string;
    FAPIKey: string;
    FFileName: string;
    FProjectName: string;
    FIsFile: Boolean;
    FTotalLines: Integer;
    FIsWrite: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CLIPath, APIKey, FileName, ProjectName: string; IsFile: Boolean;
      TotalLines: Integer; IsWrite: Boolean);
  end;

implementation

{$I DelphiVersions.inc}

uses
  Windows,
  ShellAPI,
  WakaTimeLogger,
  StrUtils;

const
  PluginVersion = '1.0.0'; // Replace with actual plugin version

  {$IFDEF DELPHI_10_3_RIO}
    DelphiVersion = '10.3';
  {$ENDIF}
  {$IFDEF DELPHI_10_2_TOKYO}
    DelphiVersion = '10.2';
  {$ENDIF}
  {$IFDEF DELPHI_10_1_BERLIN}
    DelphiVersion = '10.1';
  {$ENDIF}
  {$IFDEF DELPHI_10_SEATTLE}
    DelphiVersion = '10.0';
  {$ENDIF}
  {$IFDEF DELPHI_XE8}
    DelphiVersion = 'XE8';
  {$ENDIF}
  {$IFDEF DELPHI_XE7}
    DelphiVersion = 'XE7';
  {$ENDIF}
  {$IFDEF DELPHI_XE6}
    DelphiVersion = 'XE6';
  {$ENDIF}
  {$IFDEF DELPHI_XE5}
    DelphiVersion = 'XE5';
  {$ENDIF}
  {$IFDEF DELPHI_XE4}
    DelphiVersion = 'XE4';
  {$ENDIF}
  {$IFDEF DELPHI_XE3}
    DelphiVersion = 'XE3';
  {$ENDIF}
  {$IFDEF DELPHI_XE2}
    DelphiVersion = 'XE2';
  {$ENDIF}
  {$IFDEF DELPHI_XE}
    DelphiVersion = 'XE';
  {$ENDIF}
  {$IFDEF DELPHI_2010}
    DelphiVersion = '2010';
  {$ENDIF}
  {$IFDEF DELPHI_2009}
    DelphiVersion = '2009';
  {$ENDIF}
  {$IFDEF DELPHI_2007_FOR_NET}
    DelphiVersion = '2007.NET';
  {$ENDIF}
  {$IFDEF DELPHI_2007}
    DelphiVersion = '2007';
  {$ENDIF}
  {$IFDEF DELPHI_2006}
    DelphiVersion = '2006';
  {$ENDIF}
  {$IFDEF DELPHI_2005}
    DelphiVersion = '2005';
  {$ENDIF}
  {$IFDEF DELPHI_8_FOR_NET}
    DelphiVersion = '8.NET';
  {$ENDIF}
  {$IFDEF DELPHI_7}
    DelphiVersion = '7.0';
  {$ENDIF}
  {$IFDEF DELPHI_6}
    DelphiVersion = '6.0';
  {$ENDIF}

  UserAgent = 'delphi/' + DelphiVersion + ' delphi-wakatime/' + PluginVersion;



constructor TSendHeartbeatThread.Create(CLIPath, APIKey, FileName, ProjectName: string; IsFile:
  Boolean; TotalLines: Integer; IsWrite: Boolean);

  function FixProjectName: string;
  begin
    Result := ChangeFileExt(ProjectName, '');
  end;
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FClIPath := CLIPath;
  FAPIKey := APIKey;
  FFileName := FileName;
  FProjectName := FixProjectName;
  FIsFile := IsFile;
  FTotalLines := TotalLines;
  FIsWrite := IsWrite;
end;

procedure TSendHeartbeatThread.Execute;
var
  CommandLine: string;
  Operation: PChar;
  FileName: PChar;
  Parameters: PChar;
  Directory: PChar;
  ShowCommand: Integer;
begin
  if (FAPIKey = '') then
   begin
    TWakaTimeLogger.Log('ApiKey not found =(');
    exit;
   end;

  // Prepare the command line
  CommandLine :=
    Format('""%swakatime-cli.exe" --entity "%s" --lines-in-file %d --alternate-project "%s" --plugin "%s""', [FCLIPath, FFileName, FTotalLines, FProjectName, UserAgent]);

  if FIsWrite then
    CommandLine := CommandLine + ' --write';

  // Set the parameters for ShellExecute
  Operation := 'open';
  FileName := 'cmd.exe';
  Parameters := PChar('/c ' + CommandLine);
  Directory := nil;
  ShowCommand := SW_HIDE; // Use SW_SHOW to show the command prompt window

  TWakaTimeLogger.Log(CommandLine);

  try
    // Execute the command
    ShellExecute(0, Operation, FileName, Parameters, Directory, ShowCommand);

    TWakaTimeLogger.Log('Command executed.');

  except
    on E: Exception do
     TWakaTimeLogger.Log('Error sending command to wakatime-cli => '+E.Message);
  end;
end;


end.
