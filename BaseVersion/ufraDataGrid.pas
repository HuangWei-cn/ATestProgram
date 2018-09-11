unit ufraDataGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GridsEh, DBGridEh, DB, ADODB;

type
  TfraDataGrid = class(TFrame)
    dbgDatas: TDBGridEh;
    Panel2: TPanel;
    btnShowDatas: TButton;
    btnExpertData: TButton;
    btnPrintData: TButton;
  private
    { Private declarations }
    FDataSource, FFilterSource: TDataSource;
    FUseAverageData: Boolean;
  public
    { Public declarations }
    property DataSource: TDataSource read FDataSource write FDataSource;
    property FilterSource: TDataSource read FFilterSource write FFilterSource;
    property UseAverageData: Boolean read FUseAverageData write FUseAverageData;

    procedure SetGridToShow;
    procedure AfterDataSetOpen(ADataSet: TDataSet);
  end;

implementation

{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TfraDataGrid.AfterDataSetOpen
  Description:  响应对应的DataSet打开事件。当DataSet打开之后，Grid将显示数据，
                之后需要调整Grid表头、列宽等等，用这个方法完成这些事情。
-----------------------------------------------------------------------------}
procedure TfraDataGrid.AfterDataSetOpen(ADataSet: TDataSet);
begin
        SetGridToShow;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraDataGrid.SetGridToShow
  Description:  设置表格的显示，仅针对GPS数据集显示。  
-----------------------------------------------------------------------------}
procedure TfraDataGrid.SetGridToShow;
var     i: Integer;
begin
        with dbgDatas do
        begin
            Columns[1].Title.Caption := '测点名';
            Columns[2].Title.Caption := '监测日期';
            Columns[3].Title.Caption := '数据时间';
            if FUseAverageData then
            begin
                Columns[4].Title.Caption := '日平均位置(m)|X';
                Columns[5].Title.Caption := '日平均位置(m)|Y';
                Columns[6].Title.Caption := '日平均位置(m)|H';
                Columns[7].Title.Caption := '总平均变形量(mm)|dX';
                Columns[8].Title.Caption := '总平均变形量(mm)|dY';
                Columns[9].Title.Caption := '总平均变形量(mm)|dH';
                Columns[10].Title.Caption := '总平均变形量(mm)|总位移';
                Columns[11].Title.Caption := '日平均变形量(mm)|ddX';
                Columns[12].Title.Caption := '日平均变形量(mm)|ddY';
                Columns[13].Title.Caption := '日平均变形量(mm)|ddH';
                Columns[14].Title.Caption := '日平均变形量(mm)|日位移';
            end
            else
            begin
                Columns[4].Title.Caption := '位置(m)|X';
                Columns[5].Title.Caption := '位置(m)|Y';
                Columns[6].Title.Caption := '位置(m)|H';
                Columns[7].Title.Caption := '总变形量(mm)|dX';
                Columns[8].Title.Caption := '总变形量(mm)|dY';
                Columns[9].Title.Caption := '总变形量(mm)|dH';
                Columns[10].Title.Caption := '总变形量(mm)|总位移';
                Columns[11].Title.Caption := '日变形量(mm)|ddX';
                Columns[12].Title.Caption := '日变形量(mm)|ddY';
                Columns[13].Title.Caption := '日变形量(mm)|ddH';
                Columns[14].Title.Caption := '日变形量(mm)|日位移';
            end;
        end;    // with

        //dbgDatas.Columns[2].DisplayFormat := 'yyyy-mm-dd';

        for i := 4 to 6 do
        begin
            dbgDatas.Columns[i].DisplayFormat := '0.0000';
            //dbgDatas.Columns[i].AutoFitColWidth := True;
        end;

        for i := 7 to 14 do
        begin
            dbgDatas.Columns[i].DisplayFormat := '0.00';
            //dbgDatas.Columns[i].AutoFitColWidth := True;
        end;

        for i := 0 to 3 do
            dbgDatas.Columns[i].Alignment := taCenter;

        with dbgDatas.Columns[1].STFilter do
        begin
            ListSource := FFilterSource;
            ListField := 'PointName';
            KeyField := 'PointName';
            //DataField := 'PName';
        end;
        with dbgDatas.Columns[2].STFilter do
        begin
            ListSource := FFilterSource;
            ListField := 'PDate';
            KeyField := 'PDate';
        end;    // with
        with dbgDatas.Columns[3].STFilter do
        begin
            ListSource := FFilterSource;
            ListField := 'PTime';
            KeyField := 'PTime';
        end;    // with
        for i := 0 to dbgDatas.Columns.Count -1 do
        begin
            dbgDatas.Columns[i].Title.TitleButton := True;
            dbgDatas.Columns[i].OptimizeWidth;
        end;
end;

end.
