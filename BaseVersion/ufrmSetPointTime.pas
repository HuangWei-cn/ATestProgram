{-----------------------------------------------------------------------------
 Unit Name: ufrmSetPointTime
 Author:    ��ΰ
 Date:      24-����-2010
 Purpose:   ����Ԫ���ڴ����ݿ��ж�ȡ�����Ϣ������ϲ��ɼ����ݵĽ�������û�
            ˵��������ID�Ĵ��ʱ��Σ���������Щ��Ϣ
 History:
-----------------------------------------------------------------------------}

unit ufrmSetPointTime;
                     
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, ADODB, Grids, uLeicaGPSData;

type
  TfrmSetPointTime = class(TForm)
    Label2: TLabel;
    btnSave: TButton;
    btnCancel: TButton;
    grdPoints: TStringGrid;
    lblDescription: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    procedure IniGrid;
  public
    { Public declarations }
    //�����ݿ��м��ز���
    procedure LoadParamsFromDB;
    procedure SaveParams;
  end;

var
  frmSetPointTime: TfrmSetPointTime;

implementation
uses    Unit1;

var
        qryPDT: TADOQuery;
{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TfrmSetPointTime.FormCreate
  Description:
-----------------------------------------------------------------------------}
procedure TfrmSetPointTime.FormCreate(Sender: TObject);
begin //
        IniGrid;
        qryPDT          := TADOQuery.Create(Self);
        LoadParamsFromDB;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmSetPointTime.FormDestroy
  Description:  
-----------------------------------------------------------------------------}
procedure TfrmSetPointTime.FormDestroy(Sender: TObject);
begin //
        FreeAndNil(qryPDT);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmSetPointTime.IniGrid
  Description:
-----------------------------------------------------------------------------}
procedure TfrmSetPointTime.IniGrid;
begin
        with grdPoints do
        begin
            Cells[0,0] := '�����';
            Cells[1,0] := '���ID';
            Cells[2,0] := '���ʱ��';
            Cells[3,0] := '�ղ��';
        end;    // with
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmSetPointTime.LoadParamsFromDB
  Description:  �����ݿ��м��ص���Ϣ  
-----------------------------------------------------------------------------}
procedure TfrmSetPointTime.LoadParamsFromDB;
var
        qryPointName: TADOQuery;
        str1, str2, str3: String;
begin
        qryPointName := TADOQuery.Create(Self);
        try
            if frmTest.ADOConnection1.Connected then
            begin
                qryPointName.Connection := frmTest.ADOConnection1;
                { ����Ĳ�ѯ����ǲ������ID������������Spider��ӵ����� }
                qryPointName.SQL.Text := 'select Distinct left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName,ID From Points Order by pname';
                qryPointName.Open;
                if qryPointName.RecordCount > 0 then
                begin
                    //--------------------------------------------------
                    //��ȡ��㡢ID������ʱ�̱�
                    qrypdt.Connection := frmTest.ADOConnection1;
                    qrypdt.SQL.Text := 'SELECT t1.point_id, left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName, '
                        + 't1.ptime FROM (select distinct point_id, ROUND(DATEPART(hour,epoch) + '
                        + 'DATEPART(MINUTE,epoch)/100.00,0 ) as PTime from results ) t1 inner join '
                        + 'points t2 on t1.point_ID=t2.id order by t2.[name]';
                    qrypdt.Open;

                    qryPointName.Last; qryPointName.First;
                    repeat
                        str1 := qryPointName.FieldValues['PName'];
                        str2 := qryPointName.FieldByName('ID').AsString;

                        grdPoints.Cells[0,grdPoints.RowCount-1] := str1;
                        grdPoints.Cells[1,grdPoints.RowCount-1] := str2;

                        //��ѡ������ID��ʱ�̼�¼����д��Grid��
                        qrypdt.Filter := 'Point_ID = ' + str2;
                        qrypdt.Filtered := True;
                        qrypdt.Last; qrypdt.First;
                        if qrypdt.RecordCount = 0 then
                        begin
                            grdPoints.Cells[2,grdPoints.RowCount-1] := 'None';
                            grdPoints.Cells[3,grdPoints.RowCount-1] := '0';
                        end
                        else
                        begin
                            str3 := '';
                            repeat
                                str3 := str3 + qrypdt.fieldbyname('PTime').AsString + ',';
                                qrypdt.Next;
                            until qrypdt.Eof;
                            str3 := copy(str3,1,length(str3)-1);
                            grdpoints.Cells[2,grdPoints.RowCount-1] := str3;
                            grdPoints.Cells[3,grdPoints.RowCount-1] := IntToStr(qryPdt.RecordCount);
                        end;

                        grdPoints.RowCount := grdPoints.RowCount + 1;
                        qryPointName.Next;
                    until qryPointName.Eof;

                end;
            end;
        finally
            qryPointName.Free;
        end;
end;

procedure TfrmSetPointTime.SaveParams;
var
        iRow, i,j,mm,jj: Integer;
        { -------------------------------------------------------- }
        { ��DataPrecisions�����в��ҷ��ϲ�ε�����Ԫ�� }
        function FindDataPrecision(ANum: Integer): Integer;
        begin
            Result := -1;
            if Length(DataPrecisions) = 0 then Exit;
            for Result := 0 to Length(DataPrecisions) -1 do
                if DataPrecisions[Result].DataNum = ANum then Exit;
            Result := -1;
        end;
        { -------------------------------------------------------- }
        { ��GPSPoints�����в��ҷ���ID�Ĳ�㡣GPSPoints�����ڴ����ݿ��ʱ���Ѿ����岢��ֵ }
        function FindPoint(AID: LongInt): Integer;
        begin
            Result := -1;
            if Length(GPSPoints) = 0 then Exit;
            for Result := 0 to Length(GPSPoints) -1 do
                if GPSPoints[Result].ID = AID then Exit;
            Result := -1;
        end;
begin   {  }
        frmTest.cmbDataTime.Clear;
        //����֮ǰ���ͷ�DataPrecisions����
        if Length(DataPrecisions) > 0 then
        begin
            for i := 0 to Length(DataPrecisions) -1 do
            begin
                { ����Ҫ�ͷ�points�����е�ָ�룬ֻ��Ҫ�ͷŵ����� }
                if Length(DataPrecisions[i].Points) > 0 then SetLength(DataPrecisions[i].Points,0);
                dispose(DataPrecisions[i]);
            end;
            SetLength(DataPrecisions, 0);
        end;
        //���¶���DataPrecisions����
        for iRow := 1 to grdPoints.RowCount -1 do
        begin
            if (Trim(grdPoints.Cells[3, iRow]) <> '0') and (Trim(grdPoints.Cells[0, iRow])<>'') then
            begin
                //�����Ƿ���ڷ�������������Ԫ��
                mm := StrToInt(grdPoints.Cells[3, iRow]);
                i := FindDataPrecision(mm);
                if i = -1 then //���û���ҵ������Ӹü�¼
                begin
                    i := Length(DataPrecisions);
                    SetLength(DataPrecisions, i+1);
                    New(DataPrecisions[i]);
                    DataPrecisions[i].DataNum := mm;
                    DataPrecisions[i].Interval := 24/mm;
                    frmTest.cmbDataTime.Items.Add(FloatToStr(DataPrecisions[i].Interval));
                end;

                 j := FindPoint(StrToInt(grdPoints.Cells[1,iRow]));
                 if j <> -1 then
                 begin
                    jj := Length(DataPrecisions[i].Points);
                    SetLength(DataPrecisions[i].Points, jj+1);
                    DataPrecisions[i].Points[jj] := GPSPoints[j];
                 end;
            end;
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmSetPointTime.btnSaveClick
  Description:  ������ʱ�䶨�壬���塢��дDataPrecisions���飬������������  
-----------------------------------------------------------------------------}
procedure TfrmSetPointTime.btnSaveClick(Sender: TObject);
begin
        SaveParams;
end;

end.
