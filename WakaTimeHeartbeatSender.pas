unit WakaTimeHeartbeatSender;


interface

uses
  SysUtils, DateUtils, WakaTimeSendHeartbeatThread, WakaTimeLogger;

type
  TWakaTimeHeartbeatSender = class
  private
    FLastSentFile: string;
    FLastSentTime: TDateTime;
    function EnoughTimeHasPassed: Boolean;
    function CurrentlyFocusedFileHasChanged(const FileName: string): Boolean;
  public
    procedure SendHeartbeat(const FileName: string; ProjectName: string; TotalLines: Integer; IsFileSavedEvent: Boolean);
  end;

implementation

uses WakaTimeSettings;

function TWakaTimeHeartbeatSender.EnoughTimeHasPassed: Boolean;
begin
  Result := Now - FLastSentTime > EncodeTime(0, 2, 0, 0);  // 2 minutes
  TWakaTimeLogger.Log('EnoughtTimeHasPassed: '+ BoolToStr(Result, True));
end;

function TWakaTimeHeartbeatSender.CurrentlyFocusedFileHasChanged(const FileName: string): Boolean;
begin
  Result := FileName <> FLastSentFile;
  TWakaTimeLogger.Log('CurrentlyFocusedFileHasChanged: '+ BoolToStr(Result, True));
end;

procedure TWakaTimeHeartbeatSender.SendHeartbeat(const FileName: string; ProjectName: string; TotalLines: Integer; IsFileSavedEvent: Boolean);
begin
  if EnoughTimeHasPassed or CurrentlyFocusedFileHasChanged(FileName) or IsFileSavedEvent then
  begin
    TSendHeartbeatThread.Create(WakaSettings.CLIPath, WakaSettings.ApiKey, FileName, ProjectName, FileName <> '',
      TotalLines, IsFileSavedEvent);

    // Update the last sent file and time
    FLastSentFile := FileName;
    FLastSentTime := Now;
  end;
end;

end.
