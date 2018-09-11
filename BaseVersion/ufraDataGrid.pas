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
  Description:  ��Ӧ��Ӧ��DataSet���¼�����DataSet��֮��Grid����ʾ���ݣ�
                ֮����Ҫ����Grid��ͷ���п�ȵȣ���������������Щ���顣
-----------------------------------------------------------------------------}
procedure TfraDataGrid.AfterDataSetOpen(ADataSet: TDataSet);
begin
        SetGridToShow;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraDataGrid.SetGridToShow
  Description:  ���ñ�����ʾ�������GPS���ݼ���ʾ��  
-----------------------------------------------------------------------------}
procedure TfraDataGrid.SetGridToShow;
var     i: Integer;
begin
        with dbgDatas do
        begin
            Columns[1].Title.Caption := '�����';
            Columns[2].Title.Caption := '�������';
            Columns[3].Title.Caption := '����ʱ��';
            if FUseAverageData then
            begin
                Columns[4].Title.Caption := '��ƽ��λ��(m)|X';
                Columns[5].Title.Caption := '��ƽ��λ��(m)|Y';
                Columns[6].Title.Caption := '��ƽ��λ��(m)|H';
                Columns[7].Title.Caption := '��ƽ��������(mm)|dX';
                Columns[8].Title.Caption := '��ƽ��������(mm)|dY';
                Columns[9].Title.Caption := '��ƽ��������(mm)|dH';
                Columns[10].Title.Caption := '��ƽ��������(mm)|��λ��';
                Columns[11].Title.Caption := '��ƽ��������(mm)|ddX';
                Columns[12].Title.Caption := '��ƽ��������(mm)|ddY';
                Columns[13].Title.Caption := '��ƽ��������(mm)|ddH';
                Columns[14].Title.Caption := '��ƽ��������(mm)|��λ��';
            end
            else
            begin
                Columns[4].Title.Caption := 'λ��(m)|X';
                Columns[5].Title.Caption := 'λ��(m)|Y';
                Columns[6].Title.Caption := 'λ��(m)|H';
                Columns[7].Title.Caption := '�ܱ�����(mm)|dX';
                Columns[8].Title.Caption := '�ܱ�����(mm)|dY';
                Columns[9].Title.Caption := '�ܱ�����(mm)|dH';
                Columns[10].Title.Caption := '�ܱ�����(mm)|��λ��';
                Columns[11].Title.Caption := '�ձ�����(mm)|ddX';
                Columns[12].Title.Caption := '�ձ�����(mm)|ddY';
                Columns[13].Title.Caption := '�ձ�����(mm)|ddH';
                Columns[14].Title.Caption := '�ձ�����(mm)|��λ��';
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
