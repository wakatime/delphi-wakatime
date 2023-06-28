unit WakaTimeCLIInstaller;

interface

uses
  Classes, SysUtils, Windows, Forms, WakaTimeLogger;

type
  TWakaTimeCLIInstaller = class
  private
    FCLIPath: string;
    function GetOsArchitecture: string;
    function GetCLIDownloadURL: string;
    procedure DownloadFile(const AUrl, AOutputFile: string);
    procedure UnzipFile(const AZipFile, AOutputDir: string);
    function RunAndWait(const ACmd: string): string;
    function IsCliLatest: Boolean;
    procedure RenameCLIExecutable;
  public
    constructor Create(const CLIPath: string);
    procedure Install;
  end;

implementation

uses
  ShellApi;

{$I DelphiVersions.inc}

constructor TWakaTimeCLIInstaller.Create(const CLIPath: string);
begin
  inherited Create;
  FCLIPath := IncludeTrailingPathDelimiter(CLIPath);

  if not DirectoryExists(FCLIPath) then
    ForceDirectories(FCLIPath);
end;

function TWakaTimeCLIInstaller.GetOsArchitecture: string;
var
  PowerShellCmd: string;
begin
  TWakaTimeLogger.LogInstall('Getting OS Architecture');
  PowerShellCmd := 'powershell.exe -noprofile -command "& { if ((Get-WmiObject win32_operatingsystem | select osarchitecture).osarchitecture -eq ''64-bit'') { Write-Output ''amd64'' } else { Write-Output ''386'' } }"';
  Result := RunAndWait(PowerShellCmd);
  TWakaTimeLogger.LogInstall('Finish getting OS Architecture');
end;

procedure TWakaTimeCLIInstaller.RenameCLIExecutable;
var
  OldName: string;
  NewName: string;
begin
  TWakaTimeLogger.LogInstall('Renaming CLI executable');
  OldName := FCLIPath + 'wakatime-cli-windows-' + GetOsArchitecture + '.exe';
  NewName := FCLIPath + 'wakatime-cli.exe';
  if RenameFile(OldName, NewName) then
    TWakaTimeLogger.LogInstall('Successfully renamed the file')
  else
    TWakaTimeLogger.LogInstall('Failed to rename the file');
  TWakaTimeLogger.LogInstall('Finished renaming CLI executable');
end;


procedure TWakaTimeCLIInstaller.Install;
var
  ZipFile: string;
begin
  TWakaTimeLogger.LogInstall('Install starting');

  ZipFile := FCLIPath + 'wakatime-cli.zip';

  if not IsCliLatest then
  begin
    DownloadFile(GetCLIDownloadURL, ZipFile);
    UnzipFile(ZipFile, FCLIPath);
    RenameCLIExecutable;
  end;

  TWakaTimeLogger.LogInstall('Install ended');
end;


function TWakaTimeCLIInstaller.IsCliLatest: Boolean;
var
  PowerShellCmd, WakaTimeCLI, InstalledVersion, LatestVersion: string;
begin
  TWakaTimeLogger.LogInstall('Checking wakatime version');

  WakaTimeCLI := FCLIPath+'wakatime-cli.exe';

  TWakaTimeLogger.LogInstall('WakaTimeCLI: '+WakaTimeCLI);

  if not FileExists(WakaTimeCLI) then
    begin
      TWakaTimeLogger.LogInstall('Checking wakatime version finished, no cli installed yet');
      Result := False;
      Exit;
    end;

  // Get installed version
  PowerShellCmd := Format('powershell.exe -noprofile -command "& { %swakatime-cli --version }"', [FCLIPath]);
  InstalledVersion := RunAndWait(PowerShellCmd);

  // Get latest version
  PowerShellCmd := 'powershell.exe -noprofile -command "& { ' +
    '(Invoke-WebRequest -Uri https://api.github.com/repos/wakatime/wakatime-cli/releases/latest ' +
    '| ConvertFrom-Json).tag_name }"';
  LatestVersion := RunAndWait(PowerShellCmd);

  Result := InstalledVersion = LatestVersion;

  TWakaTimeLogger.LogInstall('Checking wakatime version finished');
end;


function TWakaTimeCLIInstaller.GetCLIDownloadURL: string;
begin
  Result := Format('https://github.com/wakatime/wakatime-cli/releases/latest/download/wakatime-cli-windows-%s.zip',
    [GetOsArchitecture]);
end;

procedure TWakaTimeCLIInstaller.DownloadFile(const AUrl, AOutputFile: string);
var
  PowerShellCmd: string;
begin
  TWakaTimeLogger.LogInstall('Downloading wakatime');
  PowerShellCmd := 'powershell.exe -noprofile -command "& { Invoke-WebRequest -Uri ''' +
    AUrl + ''' -OutFile ''' + AOutputFile + ''' }"';
  RunAndWait(PowerShellCmd);
  TWakaTimeLogger.LogInstall('Downloading wakatime finished');
end;

procedure TWakaTimeCLIInstaller.UnzipFile(const AZipFile, AOutputDir: string);
var
  PowerShellCmd: string;
begin
  TWakaTimeLogger.LogInstall('Unziping wakatime');
  PowerShellCmd := 'powershell.exe -noprofile -command "& { Add-Type -A ''System.IO.Compression.FileSystem''; ' +
    '[IO.Compression.ZipFile]::ExtractToDirectory(''' + AZipFile + ''', ''' + AOutputDir + ''') }"';
  RunAndWait(PowerShellCmd);
  TWakaTimeLogger.LogInstall('Unziping wakatime finished');
end;

{$IFDEF DELPHI_7}
function TWakaTimeCLIInstaller.RunAndWait(const ACmd: String): AnsiString;
var
  Security: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  Start: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: DWORD;
  Apprunning: DWORD;
  CmdLine: String;
  StrBuffer: String;
begin
  TWakaTimeLogger.LogInstall('Creating process: '+ ACmd);

  Security.nLength := SizeOf(TSecurityAttributes);
  Security.bInheritHandle := True;
  Security.lpSecurityDescriptor := nil;

  if CreatePipe(ReadPipe, WritePipe, @Security, 0) then
  begin
    FillChar(Start, SizeOf(Start), #0);
    Start.cb := SizeOf(Start);
    Start.hStdOutput := WritePipe;
    Start.hStdError := WritePipe;
    Start.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    Start.wShowWindow := SW_HIDE;

    CmdLine := ACmd; // Copy command into non-const string

    if CreateProcess(nil, PAnsiChar(CmdLine), @Security, @Security, True,
      NORMAL_PRIORITY_CLASS, nil, nil, Start, ProcessInfo) then
    begin
      repeat
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess, 100);
        TWakaTimeLogger.LogInstall('Waiting process...');
        Application.ProcessMessages;
      until (Apprunning <> WAIT_TIMEOUT);

      repeat
        TWakaTimeLogger.LogInstall('Reading result');
        BytesRead := 0;
        if PeekNamedPipe(ReadPipe, nil, 0, nil, @BytesRead, nil) then
        begin
          if BytesRead > 0 then
          begin
            ReadFile(ReadPipe, Buffer, SizeOf(Buffer), BytesRead, nil);
            Buffer[BytesRead] := #0;
            StrBuffer := AnsiString(Buffer);
            Result := Result + StrBuffer;
          end;
        end;
      until (BytesRead < SizeOf(Buffer)) or (BytesRead = 0);
    end;
  end;

  TWakaTimeLogger.LogInstall('Cleaning up process...');

  CloseHandle(ProcessInfo.hProcess);
  CloseHandle(ProcessInfo.hThread);
  CloseHandle(ReadPipe);
  CloseHandle(WritePipe);

  Result := Trim(Result);

  TWakaTimeLogger.LogInstall('Create process finished with result: '+ Result);
end;
{$ELSE}

function TWakaTimeCLIInstaller.RunAndWait(const ACmd: string): string;
var
  Security: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  Start: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: DWORD;
  Apprunning: DWORD;
  CmdLine: string;
  StrBuffer: AnsiString;
begin
  TWakaTimeLogger.LogInstall('Creating process: '+ ACmd);

  Security.nLength := SizeOf(TSecurityAttributes);
  Security.bInheritHandle := True;
  Security.lpSecurityDescriptor := nil;

  if CreatePipe(ReadPipe, WritePipe, @Security, 0) then
  begin
    FillChar(Start, SizeOf(Start), #0);
    Start.cb := SizeOf(Start);
    Start.hStdOutput := WritePipe;
    Start.hStdError := WritePipe;
    Start.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    Start.wShowWindow := SW_HIDE;

    CmdLine := ACmd; // Copy command into non-const string

    if CreateProcess(nil, PChar(WideString(CmdLine)), @Security, @Security, True,
      NORMAL_PRIORITY_CLASS, nil, nil, Start, ProcessInfo) then
    begin
      repeat
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
        TWakaTimeLogger.LogInstall('Waiting process...');
        Application.ProcessMessages;
      until (Apprunning <> WAIT_TIMEOUT);

      repeat
        TWakaTimeLogger.LogInstall('Reading result');
        BytesRead := 0;
        if PeekNamedPipe(ReadPipe, nil, 0, nil, @BytesRead, nil) then
        begin
          if BytesRead > 0 then
          begin
            ReadFile(ReadPipe, Buffer, SizeOf(Buffer), BytesRead, nil);
            Buffer[BytesRead] := #0;
            StrBuffer := AnsiString(Buffer);
            Result := Result + String(StrBuffer);
          end;
        end;
      until (BytesRead < SizeOf(Buffer)) or (BytesRead = 0);
    end;
  end;

  TWakaTimeLogger.LogInstall('Cleaning up process...');

  CloseHandle(ProcessInfo.hProcess);
  CloseHandle(ProcessInfo.hThread);
  CloseHandle(ReadPipe);
  CloseHandle(WritePipe);

  Result := Trim(Result);

  TWakaTimeLogger.LogInstall('Create process finished with result: '+ Result);
end;
{$ENDIF}

end.
