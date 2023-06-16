unit WakaTimeSettings;

interface


type
  TWakaTimeSettings = class
  private
    FDebug: Boolean;
    FApiKey: string;
    FPluginLogFileName: string;
    FCLIPath: string;
    FUserProfilePath: string;
  public
    constructor Create;

    procedure Load;
    procedure Save;

    property ApiKey: string read FApiKey write FApiKey;
    property Debug: Boolean read FDebug write FDebug;
    property PluginLogFileName: string read FPluginLogFileName;
    property CLIPath: string read FCLIPath;
  end;


function WakaSettings(AutoLoad: Boolean = True): TWakaTimeSettings;

implementation

{$I DelphiVersions.inc}

uses
  SysUtils, IniFiles;

var
  _WakaSettings: TWakaTimeSettings = nil;


function WakaSettings(AutoLoad: Boolean): TWakaTimeSettings;
begin
  if _WakaSettings = nil then
   begin
     _WakaSettings := TWakaTimeSettings.Create;
     if AutoLoad then
      _WakaSettings.Load;
   end;

  Result := _WakaSettings;
end;

{ TWakaTimeSettings }

const
  WakaTimeConfigFile = '\.wakatime.cfg';

  {$IFDEF DELPHI_10_3_RIO}
  WakaPluginLogFileName = 'wakatime-d10_3.log';
  {$ENDIF}
  {$IFDEF DELPHI_10_2_TOKYO}
  WakaPluginLogFileName = 'wakatime-d10_2.log';
  {$ENDIF}
  {$IFDEF DELPHI_10_1_BERLIN}
  WakaPluginLogFileName = 'wakatime-d10_1.log';
  {$ENDIF}
  {$IFDEF DELPHI_10_SEATTLE}
  WakaPluginLogFileName = 'wakatime-d10.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE8}
  WakaPluginLogFileName = 'wakatime-xe8.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE7}
  WakaPluginLogFileName = 'wakatime-xe7.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE6}
  WakaPluginLogFileName = 'wakatime-xe6.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE5}
  WakaPluginLogFileName = 'wakatime-xe5.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE4}
  WakaPluginLogFileName = 'wakatime-xe4.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE3}
  WakaPluginLogFileName = 'wakatime-xe3.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE2}
  WakaPluginLogFileName = 'wakatime-xe2.log';
  {$ENDIF}
  {$IFDEF DELPHI_XE}
  WakaPluginLogFileName = 'wakatime-xe.log';
  {$ENDIF}
  {$IFDEF DELPHI_2010}
  WakaPluginLogFileName = 'wakatime-d2010.log';
  {$ENDIF}
  {$IFDEF DELPHI_2009}
  WakaPluginLogFileName = 'wakatime-d2009.log';
  {$ENDIF}
  {$IFDEF DELPHI_2007_FOR_NET}
  WakaPluginLogFileName = 'wakatime-d2007_net.log';
  {$ENDIF}
  {$IFDEF DELPHI_2007}
  WakaPluginLogFileName = 'wakatime-d2007.log';
  {$ENDIF}
  {$IFDEF DELPHI_2006}
  WakaPluginLogFileName = 'wakatime-d2006.log';
  {$ENDIF}
  {$IFDEF DELPHI_2005}
  WakaPluginLogFileName = 'wakatime-d2005.log';
  {$ENDIF}
  {$IFDEF DELPHI_8_FOR_NET}
  WakaPluginLogFileName = 'wakatime-d8_net.log';
  {$ENDIF}
  {$IFDEF DELPHI_7}
  WakaPluginLogFileName = 'wakatime-d7.log';
  {$ENDIF}
  {$IFDEF DELPHI_6}
  WakaPluginLogFileName = 'wakatime-d6.log';
  {$ENDIF}


constructor TWakaTimeSettings.Create;
begin
  FUserProfilePath := GetEnvironmentVariable('USERPROFILE');
  FCLIPath := FUserProfilePath + '\.wakatime\';
end;

procedure TWakaTimeSettings.Load;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FUserProfilePath + WakaTimeConfigFile);
  try
    FApiKey := IniFile.ReadString('settings', 'api_key', '');
    FDebug  := StrToBool(IniFile.ReadString('settings', 'debug', 'False'));
    FPluginLogFileName := FCLIPath + WakaPluginLogFileName;
  finally
    IniFile.Free;
  end;
end;

procedure TWakaTimeSettings.Save;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FUserProfilePath + WakaTimeConfigFile);
  try
    IniFile.WriteString('settings', 'api_key', FApiKey);
    IniFile.WriteString('settings', 'debug', BoolToStr(FDebug, True));
  finally
    IniFile.Free;
  end;
end;

initialization

finalization
  _WakaSettings.Free;

end.
