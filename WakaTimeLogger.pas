unit WakaTimeLogger;

interface

uses
  SysUtils, Classes, IniFiles;

type
  TWakaTimeLogger = class
  public
    class procedure Log(const Msg: string);
  end;

implementation

uses WakaTimeSettings;

var
  LogFile: TextFile;

class procedure TWakaTimeLogger.Log(const Msg: string);
var
  LogFileName: string;
begin
  // Check if debug mode is enabled
  if not WakaSettings.Debug then
    Exit;

  // Define the log file name
  LogFileName := WakaSettings.PluginLogFileName;

  try
    // Assign file variable
    AssignFile(LogFile, LogFileName);

    // Try to open the log file in append mode
    if FileExists(LogFileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    try
      // Write the log message to the file
      WriteLn(LogFile, DateTimeToStr(Now) + ': ' + Msg);
    finally
      // Close the file
      CloseFile(LogFile);
    end;
  except
    //eat any file open or write errors.
  end;
end;

end.
