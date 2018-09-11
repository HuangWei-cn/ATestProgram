program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmTest},
  uut4SQL in 'uut4SQL.pas',
  uLeicaGPSData in 'uLeicaGPSData.pas',
  ufrmSetPointTime in 'ufrmSetPointTime.pas' {frmSetPointTime},
  ufraGPSTrendLine in 'ufraGPSTrendLine.pas' {fraGPSTrendLine: TFrame},
  ufrmSetupProfile in 'ufrmSetupProfile.pas' {frmProfile},
  ufrmExpertDataFromDBGrid in 'ufrmExpertDataFromDBGrid.pas' {frmExpertDataFromGrid};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Leica GPS监测数据处理';
  Application.CreateForm(TfrmTest, frmTest);
  Application.CreateForm(TfrmExpertDataFromGrid, frmExpertDataFromGrid);
  Application.Run;
end.
