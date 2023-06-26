unit WakaTimeLogger;

interface

uses
  SysUtils, Classes, IniFiles;

type
  TWakaTimeLogger = class
  private
    class procedure InternalLog(const Msg, FileName: string);
  public
    class procedure LogInstall(const Msg: string);
    class procedure Log(const Msg: string);
  end;

implementation

uses WakaTimeSettings;

var
  LogFile: TextFile;

class procedure TWakaTimeLogger.InternalLog(const Msg, FileName: string);
begin
  try
    // Assign file variable
    AssignFile(LogFile, FileName);

    // Try to open the log file in append mode
    if FileExists(FileName) then
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

class procedure TWakaTimeLogger.Log(const Msg: string);
var
  LogFileName: string;
begin
  // Check if debug mode is enabled
  if not WakaSettings.CLIInstalled and not WakaSettings.Debug then
    Exit;

  // Define the log file name
  LogFileName := WakaSettings.PluginLogFileName;

  InternalLog(Msg, LogFileName);
end;

class procedure TWakaTimeLogger.LogInstall(const Msg: string);
var
  LogFileName: string;
begin
  // Define the log file name
  LogFileName := WakaSettings.CLIPath + 'install.log';

  InternalLog(Msg, LogFileName);
end;

end.
