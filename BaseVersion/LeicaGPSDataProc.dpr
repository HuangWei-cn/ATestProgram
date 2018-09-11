program LeicaGPSDataProc;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmTest},
  uut4SQL in 'uut4SQL.pas',
  uLeicaGPSData in 'uLeicaGPSData.pas',
  ufrmSetPointTime in 'ufrmSetPointTime.pas' {frmSetPointTime},
  ufraGPSTrendLine in 'ufraGPSTrendLine.pas' {fraGPSTrendLine: TFrame},
  ufrmSetupProfile in 'ufrmSetupProfile.pas' {frmProfile},
  ufrmExpertDataFromDBGrid in 'ufrmExpertDataFromDBGrid.pas' {frmExpertDataFromGrid},
  ufraReportRave in 'ufraReportRave.pas' {fraReportRave: TFrame},
  uDisplacementLocusMap in 'uDisplacementLocusMap.pas' {fraLocusMap: TFrame},
  udmLeicaGPSDatas in 'udmLeicaGPSDatas.pas' {dmLeicaDatas: TDataModule},
  ufraPlaneVector in 'ufraPlaneVector.pas' {fraPlaneVector: TFrame},
  ufraDataGrid in 'ufraDataGrid.pas' {fraDataGrid: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Leica GPS监测数据后处理';
  Application.CreateForm(TdmLeicaDatas, dmLeicaDatas);
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
