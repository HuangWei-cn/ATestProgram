{-----------------------------------------------------------------------------
 Unit Name: ufrmSetPointTime
 Author:    黄伟
 Date:      24-四月-2010
 Purpose:   本单元用于从数据库中读取测点信息，并结合测点采集数据的结果，由用户
            说明测点各个ID的打包时间段，并保存这些信息
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
    //从数据库中加载参数
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
            Cells[0,0] := '测点名';
            Cells[1,0] := '测点ID';
            Cells[2,0] := '打包时刻';
            Cells[3,0] := '日测次';
        end;    // with
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmSetPointTime.LoadParamsFromDB
  Description:  从数据库中加载点信息  
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
                { 下面的查询结果是测点名、ID，测点名已清除Spider添加的内容 }
                qryPointName.SQL.Text := 'select Distinct left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName,ID From Points Order by pname';
                qryPointName.Open;
                if qryPointName.RecordCount > 0 then
                begin
                    //--------------------------------------------------
                    //读取测点、ID、数据时刻表
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

                        //挑选出各个ID的时刻记录，填写到Grid中
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
        { 在DataPrecisions数组中查找符合测次的数组元素 }
        function FindDataPrecision(ANum: Integer): Integer;
        begin
            Result := -1;
            if Length(DataPrecisions) = 0 then Exit;
            for Result := 0 to Length(DataPrecisions) -1 do
                if DataPrecisions[Result].DataNum = ANum then Exit;
            Result := -1;
        end;
        { -------------------------------------------------------- }
        { 在GPSPoints数组中查找符合ID的测点。GPSPoints数组在打开数据库的时候已经定义并赋值 }
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
        //定义之前先释放DataPrecisions数组
        if Length(DataPrecisions) > 0 then
        begin
            for i := 0 to Length(DataPrecisions) -1 do
            begin
                { 不需要释放points数组中的指针，只需要释放点数组 }
                if Length(DataPrecisions[i].Points) > 0 then SetLength(DataPrecisions[i].Points,0);
                dispose(DataPrecisions[i]);
            end;
            SetLength(DataPrecisions, 0);
        end;
        //重新定义DataPrecisions数组
        for iRow := 1 to grdPoints.RowCount -1 do
        begin
            if (Trim(grdPoints.Cells[3, iRow]) <> '0') and (Trim(grdPoints.Cells[0, iRow])<>'') then
            begin
                //查找是否存在符合条件的数组元素
                mm := StrToInt(grdPoints.Cells[3, iRow]);
                i := FindDataPrecision(mm);
                if i = -1 then //如果没有找到则增加该记录
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
  Description:  保存测点时间定义，定义、填写DataPrecisions数组，并向数组分配点  
-----------------------------------------------------------------------------}
procedure TfrmSetPointTime.btnSaveClick(Sender: TObject);
begin
        SaveParams;
end;

end.
