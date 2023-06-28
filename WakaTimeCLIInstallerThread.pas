unit WakaTimeCLIInstallerThread;

interface

uses
  Classes, WakaTimeCLIInstaller;

type
  TWakaTimeCLIInstallerThread = class(TThread)
  private
    FInstaller: TWakaTimeCLIInstaller;
  protected
    procedure Execute; override;
  public
    constructor Create(const CLIPath: string);
    destructor Destroy; override;
  end;

implementation

constructor TWakaTimeCLIInstallerThread.Create(const CLIPath: string);
begin
  inherited Create(False); // Create the thread in suspended state
  FreeOnTerminate := True; // Automatically deallocate memory on finish
  FInstaller := TWakaTimeCLIInstaller.Create(CLIPath);
end;

destructor TWakaTimeCLIInstallerThread.Destroy;
begin
  FInstaller.Free;
  inherited;
end;

procedure TWakaTimeCLIInstallerThread.Execute;
begin
  FInstaller.Install;
end;

end.

