unit udmLeicaGPSDatas;

interface

uses
  SysUtils, Classes, DB, ADODB, uLeicaGPSData, DateUtils, uut4SQL;

type
  TdmLeicaDatas = class(TDataModule)
    acnGPS: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
  private
    { Private declarations }
    { �����ݿ�󣬽���������ȥ����׺����IDд��GPSPoints���� }
    procedure SetPointsArray;
  public
    { Public declarations }
    { ȡ��ADO���ݿ������ַ��� }
    function GetDBConnStr: String;
    { �����ݿ⣬�����ص����� }
    function OpenDatabase: Boolean;
    { �������ݿ��м����б�ȥ��Spider�Զ���ӵĺ�׺ }
    procedure GetPointNameList(APointList: TStrings);
    { ���ؼ�����ݵ���ֹ���ڣ�����ֵBoolean��־�Ƿ�ɹ� }
    function GetDataDateRange(var StartDate, EndDate: TDatetime): Boolean;
    { ���ؼ�����ݵ������б� }
    function GetDataDateList(ADateList: TStrings): Boolean;
  end;

    { ���ص������ݲ�ѯSQL���롣DataPrecision�Ǿ��ȣ�StartDate, EndDate��������ֹ���� }
    function QueryCode_OnePointData(AName: String; DataPrecision: Integer; StartDate, EndDate: TDateTime): String;
    { ���ص�����ƽ�����ݵĲ�ѯSQL���롣������ƽ�����ݲ�ѯ��Ҫ���ڻ�ͼ�����ݱ�ͨ����ѯȫ�����㣬����
      WithDayDiffѡ��ָ��ѯ���Ƿ�����ղ�ֵ��ѯ }
    function QueryCode_OnePointAvgData(AName: String; DataPrecision: Integer;
        StartDate, EndDate: TDateTime; WithDayDiff: Boolean=False): String; overload;
    function QueryCode_OnePointAVGData(AName: String; DataPrecision: Integer;
        y1,m1,d1,y2,m2,d2: Integer; WithDayDiff: Boolean=False): String; overload;

    { ����ȫ���������ƽ�����ݲ�ѯ���� }
    function QueryCode_AVGData(DataPrecision: Integer; StartDate, EndDate: TDateTime;
        WithDayDiff: Boolean=False): String; overload;
    function QueryCode_AVGData(DataPrecision: Integer; y1,m1,d1,y2,m2,d2: Integer;
        WithDayDiff: Boolean=False): String; overload;

var
  dmLeicaDatas: TdmLeicaDatas;

implementation

uses
  Dialogs;

{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TdmLeicaDatas.GetDBConnStr
  Description:  ��ȡ���ݿ�ADO������  
-----------------------------------------------------------------------------}
function TdmLeicaDatas.GetDBConnStr: String;
var     cnStr: String;
begin
        cnSTr := '';
        Result := '';
        cnstr := PromptDataSource(0, acnGPS.ConnectionString);
        if trim(cnStr) <> '' then
        begin
            if acnGPS.Connected then acnGPS.Close;
            acnGPS.ConnectionString := cnStr;
            Result := cnStr;
            WriteCNStrToSetting(cnStr);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TdmLeicaDatas.OpenDatabase
  Description:  �����ݿ⣬��ȡ��Ӧ��ȡ�õ���Ϣ  
-----------------------------------------------------------------------------}
function TdmLeicaDatas.OpenDatabase: Boolean;
begin
        if acnGPS.Connected then
        begin
            MessageDlg('���ݿ��Ѿ����ӡ�', mtInformation, [mbOK], 0);
            Exit;
        end;

        if not SQLServerStart then
        begin
            MessageDlg('SQL Server���ݿ�û�����������������ݿ�����ԡ�', mtWarning, [mbOK], 0);
            Exit;
        end;

        try
            acnGPS.Open;
            { ����GPSPoints���� }
            SetPointsArray;
        except
            on e: Exception do
                MessageDlg(e.Message, mtWarning, [mbOK], 0);
        end;    // try/except
end;
{-----------------------------------------------------------------------------
  Procedure:    OnePointDataQueryCode
  Description:  ����ָ�����ȡ�ָ�����ڷ�Χ��ָ��ʱ�̵ĵ�����������ݲ�ѯ���롣
                ע��ָ��ʱ�̿����޷��ڲ�ѯ���������֣�Ӧ����ɲ�ѯ֮��Խ��
                ���й��ˡ�ԭ����PTime�Ǻϳɵ��ֶΣ������������ݿ��С�
-----------------------------------------------------------------------------}
function QueryCode_OnePointData(AName: String; DataPrecision: Integer; StartDate, EndDate: TDateTime): String;
var
        strWhere, strSQL: String;

begin
        strSQL := '';
        strWhere := ' WHERE (Point_ID ='
                  + IntToStr(GetPointIDByPrecision(AName, DataPrecision)) + ') '
                  + 'AND (T1.Epoch BETWEEN ''' + DateToStr(StartDate) + ''' AND ''' + DateToStr(IncDay(EndDate,1)) + ''') ';

        strSQL := 'SELECT Point_ID, [Name] AS PName, T1.Epoch AS DTScale,'
                + 'ROUND(DATEPART(hour,T1.epoch) + DATEPART(MINUTE,T1.epoch)/100.00,0 ) as PTime,'
                + 'Easting AS X, Northing AS Y, Height AS H,'
                + 'EastingDiff AS dX, NorthingDiff AS dY, HeightDiff AS dH '
                + 'FROM Results T1 INNER JOIN Points T2 ON T1.Point_ID=T2.ID '
                + strWhere
                + 'ORDER BY DTScale, PTime';

        Result := strSQL;
end;
{-----------------------------------------------------------------------------
  Procedure:    QueryCode_OnePointAVGData
  Description:  ���ص�����ƽ�������������Բ�ѯ�ղ�ֵ  
-----------------------------------------------------------------------------}
function QueryCode_OnePointAVGData(AName: String; DataPrecision: Integer; StartDate, EndDate: TDateTime;
    WithDayDiff: Boolean=False): String;
var y1,m1,d1,y2,m2,d2: word;
begin
    DecodeDate(StartDate, y1,m1,d1);
    DecodeDate(EndDate, y2,m2,d2);
    Result := QueryCode_OnePointAVGData(AName, DataPrecision, y1,m1,d1,y2,m2,d2, WithDayDiff);
end;
{-----------------------------------------------------------------------------
  Procedure:    QueryCode_OnePointAVGData
  Description:  ʵ���ϣ��������ָ��Ӳ�ѯ�������Բ���TADOQuery�����Parameters
                �ķ�ʽ��������Query�����д��SQL���룬���������ò��������ִ��
                ��ʱ��ֱ��������и�ֵ���ɡ�
                �������ڣ������˼Ҳ�ϲ��Ū��ô�������ϲ����ʱ���������ԡ���
                ���⣬���������������������һ�����ӵ����ݿ⣬��Ϊ��Щ���ò�ѯ
                ������ʱ��Ȼ�����ʱ����в�ѯ������Ҳ��ܿ졣�ؼ������ĸ���
                �򵥡���ǿ׳��
-----------------------------------------------------------------------------}
function QueryCode_OnePointAVGData(AName: String; DataPrecision: Integer; y1,m1,d1,y2,m2,d2: Integer;
    WithDayDiff: Boolean=False): String;
var
    strSelect, strSubSelect,strSubSelect1, strSubSelect2: String;
    { ---------------------------------------------------------- }
    { ����ƽ��ֵ��ѯ���� }
    function GetSubSelectStr(yy1,mm1,dd1,yy2,mm2,dd2: Integer): String;
    var SY1,SM1,SD1,SY2,SM2,SD2: String;
        strSubWhere: String;
    begin
        Result := '';
        sy1 := inttostr(YY1); sm1 := IntToStr(MM1); SD1 := IntToStr(DD1);
        SY2 := IntToStr(YY2); SM2 := IntToStr(MM2); SD2 := IntToStr(DD2);
        strSubWhere := ' WHERE (Point_ID ='
                      + IntToStr(GetPointIDByPrecision(AName, DataPrecision)) + ') '
                      + 'AND (DYear BETWEEN ' + SY1 + ' AND ' + SY2 + ')'
                      + 'AND (DMonth BETWEEN ' + SM1 + ' AND ' + SM2 + ')'
                      + 'AND (DDay BETWEEN ' + SD1 + ' AND ' + SD2 + ')';

        Result :='SELECT A.Point_ID,''' + AName + ''' AS PName,' { AName AS PName��Ƕ������ }
                +'    A.DYear, A.DMonth, A.DDay,'
                +'    CAST((CAST(A.DYear AS VARCHAR) +''-''+ CAST(A.DMonth AS VARCHAR) +''-''+ CAST(A.DDay AS VARCHAR)) AS SMALLDATETIME) AS DTScale,'
                +'    AVG(Easting) AS avgEasting,'
                +'    AVG(Northing) AS avgNorthing,'
                +'    AVG(Height) AS avgHeight,'
                +'    AVG(EastingDiff) * 1000 AS avgEastingDiff,'
                +'    AVG(NorthingDiff) * 1000 AS avgNorthingDiff,'
                +'    AVG(HeightDiff) * 1000 AS avgHeightDiff '
                +'FROM '
                +'(	SELECT 	Point_ID,'
                +'        DATEPART(Year, Epoch) AS DYear,'
                +'        DatePart(Month, Epoch) AS DMonth,'
                +'        DatePart(Day, Epoch) AS DDay,'
                +'        Easting,'
                +'        Northing,'
                +'        Height,'
                +'        EastingDiff,'
                +'        NorthingDiff,'
                +'        HeightDiff'
                +'    FROM Results'
                + strSubWhere
                +') A '
                +'GROUP BY A.Point_ID, A.DYear, A.DMonth, A.DDay';
    end;
begin
    Result := '';

    if not WithDayDiff then
    begin
        strSubSelect := GetSubSelectStr(y1,m1,d1,y2,m2,d2);
        strSelect := 'SELECT Point_ID,PName,DTScale AS PDate,0 AS PTime,'
                    +'       avgEasting AS X,avgNorthing AS Y, avgHeight AS H,'
                    +'       avgEastingDiff AS dX, avgNorthingDiff AS dY, avgHeightDiff AS dH,'
                    +'       SQRT(SQUARE(avgEastingDiff)+SQUARE(avgNorthingDiff)+SQUARE(avgHeightDiff)) AS Len '
                    +'FROM (' + strSubSelect + ') '
                    +'ORDER BY DTScale';
        Result := strSelect;
    end
    else
    begin
        { ��ѯ�û�ָ��ʱ��ε�ƽ��ֵ }
        strSubSelect1 := GetSubSelectStr(y1,m1,d1,y2,m2,d2);
        { ʱ�����ǰ1���ƽ��ֵ�����ڼ����ֵ }
        strSubSelect2 := GetSubSelectStr(y1,m1,d1-1,y2,m2,d2-1);
        { ���ղ�ֵ����ƽ��ֵ }
        strSelect := 'SELECT T1.Point_ID, T1.PName, T1.DTScale AS PDate, 0 AS PTime,'
                    +'       T1.avgEasting AS X,'
                    +'       T1.avgNorthing AS Y,'
                    +'       T1.avgHeight AS H,'
                    +'		 T1.avgEastingDiff AS dX,'
                    +'       T1.avgNorthingDiff AS dY,'
                    +'       T1.avgHeightDiff AS dH,'
                    +'       SQRT(SQUARE(T1.avgEastingDiff)+SQUARE(T1.avgNorthingDiff)+SQUARE(T1.avgHeightDiff)) AS Len,'
                    +'	    (T1.avgEastingDiff-T2.avgEastingDiff) AS ddx,'
                    +'      (T1.avgNorthingDiff-T2.avgNorthingDiff) AS ddy,'
                    +'      (T1.avgHeightDiff-T2.avgHeightDiff) AS ddH,'
                    +'       SQRT(SQUARE(TT1.avgEastingDiff-T2.avgEastingDiff)+SQUARE(T1.avgNorthingDiff-T2.avgNorthingDiff)+SQUARE(T1.avgHeightDiff-T2.avgHeightDiff)) AS dL '
                    +'FROM '
                    +'(' + strSubSelect1 +') T1,'
                    +'(' + strSubSelect2 +') T2 '
                    +'WHERE (T1.Point_ID=T2.Point_ID)'
                    +'	AND (T1.DYear=T2.DYear) AND (T1.DMonth=T2.DMonth) AND (T1.DDay-T2.DDay=1) '
                    +'ORDER BY T1.DTScale';

        Result := strSelect;
    end;
end;
{-----------------------------------------------------------------------------
  Procedure:    QueryCode_AVGData
  Description:  ����ȫ���������ƽ�����ݣ�����ѡ���Ƿ��ѯ���ձ仯��  
-----------------------------------------------------------------------------}
function QueryCode_AVGData(DataPrecision: Integer; StartDate, EndDate: TDateTime;
    WithDayDiff: Boolean=False): String;
var Y1,M1,D1,Y2,M2,D2: Word;
begin
    DecodeDate(StartDate, Y1,M1,D1);
    DecodeDate(EndDate, Y2,M2,D2);
    Result := QueryCode_AVGData(DataPrecision, Y1,M1,D1,Y2,M2,D2, WithDayDiff);
end;
{-----------------------------------------------------------------------------
  Procedure:    QueryCode_AVGData
  Description:  ͬ�ϣ����ѯ������ȣ�Ψһ����������һ����ָ����ID����һ����
                ָ������ID��Χ  
-----------------------------------------------------------------------------}
function QueryCode_AVGData(DataPrecision: Integer; Y1,M1,D1,Y2,M2,D2: Integer;
    WithDayDiff: Boolean=False): String;
var
    strSelect, strSubSelect, strSubSelect1, strSubSelect2: String;
    { ---------------------------------------------------------- }
    { ����ƽ��ֵ��ѯ���� }
    function GetSubSelectStr(yy1,mm1,dd1,yy2,mm2,dd2: Integer): String;
    var SY1,SM1,SD1,SY2,SM2,SD2: String;
        strSubWhere: String;
    begin
        Result := '';
        sy1 := inttostr(YY1); sm1 := IntToStr(MM1); SD1 := IntToStr(DD1);
        SY2 := IntToStr(YY2); SM2 := IntToStr(MM2); SD2 := IntToStr(DD2);
        strSubWhere := ' WHERE (Point_ID IN ('
                      + GetInStrWithPrecision(DataPrecision) + ')) '
                      + 'AND (DYear BETWEEN ' + SY1 + ' AND ' + SY2 + ')'
                      + 'AND (DMonth BETWEEN ' + SM1 + ' AND ' + SM2 + ')'
                      + 'AND (DDay BETWEEN ' + SD1 + ' AND ' + SD2 + ')';

        Result :='SELECT A.Point_ID,'
                +'    A.DYear, A.DMonth, A.DDay,'
                +'    CAST((CAST(A.DYear AS VARCHAR) +''-''+ CAST(A.DMonth AS VARCHAR) +''-''+ CAST(A.DDay AS VARCHAR)) AS SMALLDATETIME) AS DTScale,'
                +'    AVG(Easting) AS avgEasting,'
                +'    AVG(Northing) AS avgNorthing,'
                +'    AVG(Height) AS avgHeight,'
                +'    AVG(EastingDiff) * 1000 AS avgEastingDiff,'
                +'    AVG(NorthingDiff) * 1000 AS avgNorthingDiff,'
                +'    AVG(HeightDiff) * 1000 AS avgHeightDiff '
                +'FROM '
                +'(	SELECT 	Point_ID,'
                +'        DATEPART(Year, Epoch) AS DYear,'
                +'        DatePart(Month, Epoch) AS DMonth,'
                +'        DatePart(Day, Epoch) AS DDay,'
                +'        Easting,'
                +'        Northing,'
                +'        Height,'
                +'        EastingDiff,'
                +'        NorthingDiff,'
                +'        HeightDiff'
                +'    FROM Results'
                + strSubWhere
                +') A '
                +'GROUP BY A.Point_ID, A.DYear, A.DMonth, A.DDay';
    end;
begin
    Result := '';

    if not WithDayDiff then
    begin
        strSubSelect := GetSubSelectStr(Y1,M1,D1,Y2,M2,D2);
        strSelect := 'SELECT T1.Point_ID, left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName, T1.DTScale AS PDate, 0 AS PTime, '
                    +'       avgEasting AS X,avgNorthing AS Y, avgHeight AS H,'
                    +'       avgEastingDiff AS dX, avgNorthingDiff AS dY, avgHeightDiff AS dH,'
                    +'       SQRT(SQUARE(avgEastingDiff)+SQUARE(avgNorthingDiff)+SQUARE(avgHeightDiff)) AS Len '
                   + 'FROM ('+strSubSelect+') T1, Points T2 '
                   + 'WHERE T1.Point_ID=T2.ID '
                   + 'ORDER BY T1.DTScale';
        Result := strSelect;
    end
    else
    begin
        { ��ѯ�û�ָ��ʱ��ε�ƽ��ֵ }
        strSubSelect1 := GetSubSelectStr(y1,m1,d1,y2,m2,d2);
        { ʱ�����ǰ1���ƽ��ֵ�����ڼ����ֵ }
        strSubSelect2 := GetSubSelectStr(y1,m1,d1-1,y2,m2,d2-1);
        { ���ղ�ֵ����ƽ��ֵ }
        strSubSelect := 'SELECT T1.Point_ID, T1.DTScale, 0 AS PTime,'
                    +'       T1.avgEasting AS X,'
                    +'       T1.avgNorthing AS Y,'
                    +'       T1.avgHeight AS H,'
                    +'		 T1.avgEastingDiff AS dX,'
                    +'       T1.avgNorthingDiff AS dY,'
                    +'       T1.avgHeightDiff AS dH,'
                    +'	    (T1.avgEastingDiff-T2.avgEastingDiff) AS ddx,'
                    +'      (T1.avgNorthingDiff-T2.avgNorthingDiff) AS ddy,'
                    +'      (T1.avgHeightDiff-T2.avgHeightDiff) AS ddH '
                    +'FROM '
                    +'(' + strSubSelect1 +') T1,'
                    +'(' + strSubSelect2 +') T2 '
                    +'WHERE (T1.Point_ID=T2.Point_ID)'
                    +'	AND (T1.DYear=T2.DYear) AND (T1.DMonth=T2.DMonth) AND (T1.DDay-T2.DDay=1) ';

        strSelect := 'SELECT TA.Point_ID, left([Name], PATINDEX (''''%[_]%'''' , [Name])-1) as PName, TA.DTScale AS PDate, 0 AS PTime '
                    +'      X,Y,H,dX,dY,dH,'
                    +'      SQRT(SQUARE(dx)+SQUARE(dy)+SQUARE(dh)) AS Len,'
                    +'      ddx,ddy,ddH,'
                    +'      SQRT(SQUARE(ddx)+SQUARE(ddy)+SQUARE(ddh)) AS dL '
                    +'FROM (' + strSubSelect + ') TA, Points TB '
                    +'WHERE TA.Point_ID=TB.ID '
                    +'ORDER BY TA.DTScale';

        Result := strSelect;
    end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TdmLeicaDatas.GetPointList
  Description:  ȡ�ز�����׺�ļ������ƣ��Զ�ȥ��Spider��ӵļ����׺��
-----------------------------------------------------------------------------}
{ TODO -oCharmer -c���ݷ��ʼ����� : �Ժ�׺���ж�Ӧ��ʹ�������ʾ�����������û�����������ԡ���������
���ʽ���д�������޷���SQL�������ɣ�ֻ�ܷ���ȫ��������ٽ��з����жϡ� }
procedure TdmLeicaDatas.GetPointNameList(APointList: TStrings);
var
        qry: TADOQuery;
begin
        APointList.Clear;
        qry := TADOQuery.Create(Self);
        qry.Connection := acnGPS;
        qry.SQL.Text := SQL_REALNAMEQUERY;
        try
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                qry.First;
                repeat
                    APointList.Add(qry.FieldValues['PName']);
                    qry.Next;
                until qry.Eof;
            end;  
        finally
            FreeAndNil(qry);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TdmLeicaDatas.SetPointsArray
  Description:  ��дGPSPoints���飬���޺�׺�ļ�������IDд��  
-----------------------------------------------------------------------------}
procedure TdmLeicaDatas.SetPointsArray;
var     qry: TADOQuery;
        i: Integer;
begin
        { ���GPSPoints }
        if Length(GPSPoints) > 0 then
        begin
            for i := 0 to Length(GPSPoints)-1 do
                dispose(GPSPoints[i]);

            SetLength(GPSPoints, 0);
        end;

        { ��ʼ���� }
        qry := TADOQuery.Create(Self);
        qry.Connection := acnGPS;
        try
            qry.SQL.Text := SQL_REALNAMEIDQUERY;
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                qry.Last; qry.First;
                { ����GPSPoints����ά�� }
                SetLength(GPSPoints, qry.RecordCount);
                i := 0;
                repeat
                    New(GPSPoints[i]);
                    GPSPoints[i].Name   := qry.FieldValues['PName'];
                    GPSPoints[i].ID     := qry.FieldValues['ID'];
                    qry.Next;
                    inc(i);
                until qry.Eof;
            end;
        finally
            FreeAndNil(qry);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TdmLeicaDatas.GetDataDateRange
  Description:  �������ݵ���ֹ����  
-----------------------------------------------------------------------------}
function TdmLeicaDatas.GetDataDateRange(var StartDate, EndDate: TDateTime): Boolean;
var     qry: TADOQuery;
begin
        Result := False;
        qry := TADOQuery.Create(Self);
        qry.Connection := acnGPS;
        qry.SQL.Text := 'SELECT MIN(EPOCH) AS MINDATE, MAX(EPOCH) AS MAXDATE FROM RESULTS';
        try
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                qry.First;
                StartDate   := qry.FieldValues['MINDATE'];
                EndDate     := qry.FieldValues['MAXDATE'];
                Result      := True;
            end;
        finally
            FreeAndNil(Qry);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TdmLeicaDatas.GetDataDateList
  Description:  �������ݵ������б��������ַ�����ʽ��ʾ  
-----------------------------------------------------------------------------}
function TdmLeicaDatas.GetDataDateList(ADateList: TStrings): Boolean;
var     qry: TADOQuery;
        ADate: TDatetime;
begin
        Result := False;
        ADateList.Clear;
        qry := TADOQuery.Create(Self);
        qry.Connection := acnGPS;
        { ע��SQL��ѯʹ��DatePart��������DateName������Ϊ�˱��ⲻͬԤ�Ե�SQL Server���ص��������Ʋ�
          ͳһ����Ӣ����·�����ʹ�õ���Ӣ���·�������������ʹ������ }
        qry.SQL.Text := 'SELECT DISTINCT datePart(yyyy,epoch) AS DataYear,'
                      + 'datePart(mm,epoch) AS DataMonth,'
                      + 'DATEPart(dd,epoch) AS DataDay '
                      + 'FROM RESULTS ORDER BY DataYear, DataMonth, DataDay';
        try
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                qry.First;
                repeat
                    ADate := RecodeDate(ADate, qry.FieldValues['DataYear'],
                        qry.FieldValues['DataMonth'], qry.FieldValues['DataDay']);
                    ADateList.Add(FormatDateTime('yyyy-mm-dd', ADate));
                    qry.Next;
                until qry.Eof;
                Result := True;
            end;
        finally
            FreeAndNil(qry);
        end;
end;

end.
