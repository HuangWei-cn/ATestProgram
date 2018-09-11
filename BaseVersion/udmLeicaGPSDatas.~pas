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
    { 打开数据库后，将监测点名（去掉后缀）、ID写入GPSPoints数组 }
    procedure SetPointsArray;
  public
    { Public declarations }
    { 取得ADO数据库连接字符串 }
    function GetDBConnStr: String;
    { 打开数据库，完成相关的任务 }
    function OpenDatabase: Boolean;
    { 返回数据库中监测点列表，去除Spider自动添加的后缀 }
    procedure GetPointNameList(APointList: TStrings);
    { 返回监测数据的起止日期，返回值Boolean标志是否成功 }
    function GetDataDateRange(var StartDate, EndDate: TDatetime): Boolean;
    { 返回监测数据的日期列表 }
    function GetDataDateList(ADateList: TStrings): Boolean;
  end;

    { 返回单点数据查询SQL代码。DataPrecision是精度，StartDate, EndDate是数据起止日期 }
    function QueryCode_OnePointData(AName: String; DataPrecision: Integer; StartDate, EndDate: TDateTime): String;
    { 返回单点日平均数据的查询SQL代码。单点日平均数据查询主要用于绘图，数据表通常查询全部监测点，其中
      WithDayDiff选项指查询中是否带有日差值查询 }
    function QueryCode_OnePointAvgData(AName: String; DataPrecision: Integer;
        StartDate, EndDate: TDateTime; WithDayDiff: Boolean=False): String; overload;
    function QueryCode_OnePointAVGData(AName: String; DataPrecision: Integer;
        y1,m1,d1,y2,m2,d2: Integer; WithDayDiff: Boolean=False): String; overload;

    { 返回全部监测点的日平均数据查询代码 }
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
  Description:  获取数据库ADO连接字  
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
  Description:  打开数据库，并取得应该取得的信息  
-----------------------------------------------------------------------------}
function TdmLeicaDatas.OpenDatabase: Boolean;
begin
        if acnGPS.Connected then
        begin
            MessageDlg('数据库已经连接。', mtInformation, [mbOK], 0);
            Exit;
        end;

        if not SQLServerStart then
        begin
            MessageDlg('SQL Server数据库没有启动，请启动数据库后再试。', mtWarning, [mbOK], 0);
            Exit;
        end;

        try
            acnGPS.Open;
            { 设置GPSPoints数组 }
            SetPointsArray;
        except
            on e: Exception do
                MessageDlg(e.Message, mtWarning, [mbOK], 0);
        end;    // try/except
end;
{-----------------------------------------------------------------------------
  Procedure:    OnePointDataQueryCode
  Description:  返回指定精度、指定日期范围、指定时刻的单点变形量数据查询代码。
                注：指定时刻可能无法在查询代码中体现，应在完成查询之后对结果
                进行过滤。原因是PTime是合成的字段，不存在于数据库中。
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
  Description:  返回单点日平均变形量，可以查询日差值  
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
  Description:  实际上，对于这种复杂查询，还可以采用TADOQuery组件＋Parameters
                的方式，即先在Query组件中写好SQL代码，条件部分用参数替代，执行
                的时候直接向参数中赋值即可。
                问题在于，我老人家不喜欢弄那么多组件，喜欢临时创建，所以……
                此外，还有其他方法，比如程序一旦链接到数据库，先为这些常用查询
                创建临时表，然后对临时表进行查询，这样也会很快。关键在于哪个更
                简单、更强壮。
-----------------------------------------------------------------------------}
function QueryCode_OnePointAVGData(AName: String; DataPrecision: Integer; y1,m1,d1,y2,m2,d2: Integer;
    WithDayDiff: Boolean=False): String;
var
    strSelect, strSubSelect,strSubSelect1, strSubSelect2: String;
    { ---------------------------------------------------------- }
    { 产生平均值查询代码 }
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

        Result :='SELECT A.Point_ID,''' + AName + ''' AS PName,' { AName AS PName：嵌入测点名 }
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
        { 查询用户指定时间段的平均值 }
        strSubSelect1 := GetSubSelectStr(y1,m1,d1,y2,m2,d2);
        { 时间段推前1天的平均值，用于计算差值 }
        strSubSelect2 := GetSubSelectStr(y1,m1,d1-1,y2,m2,d2-1);
        { 带日差值的日平均值 }
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
  Description:  返回全部监测点的日平均数据，可以选择是否查询到日变化量  
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
  Description:  同上，与查询单点相比，唯一的区别在于一个是指定了ID，另一个则
                指定的是ID范围  
-----------------------------------------------------------------------------}
function QueryCode_AVGData(DataPrecision: Integer; Y1,M1,D1,Y2,M2,D2: Integer;
    WithDayDiff: Boolean=False): String;
var
    strSelect, strSubSelect, strSubSelect1, strSubSelect2: String;
    { ---------------------------------------------------------- }
    { 产生平均值查询代码 }
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
        { 查询用户指定时间段的平均值 }
        strSubSelect1 := GetSubSelectStr(y1,m1,d1,y2,m2,d2);
        { 时间段推前1天的平均值，用于计算差值 }
        strSubSelect2 := GetSubSelectStr(y1,m1,d1-1,y2,m2,d2-1);
        { 带日差值的日平均值 }
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
  Description:  取回不带后缀的监测点名称（自动去除Spider添加的监测点后缀）
-----------------------------------------------------------------------------}
{ TODO -oCharmer -c数据访问及处理 : 对后缀的判断应该使用正则表示法，以增加用户命名的灵活性。采用正则
表达式进行处理可能无法在SQL语句中完成，只能返回全部监测点后再进行分析判断。 }
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
  Description:  填写GPSPoints数组，将无后缀的监测点名、ID写入  
-----------------------------------------------------------------------------}
procedure TdmLeicaDatas.SetPointsArray;
var     qry: TADOQuery;
        i: Integer;
begin
        { 清空GPSPoints }
        if Length(GPSPoints) > 0 then
        begin
            for i := 0 to Length(GPSPoints)-1 do
                dispose(GPSPoints[i]);

            SetLength(GPSPoints, 0);
        end;

        { 开始…… }
        qry := TADOQuery.Create(Self);
        qry.Connection := acnGPS;
        try
            qry.SQL.Text := SQL_REALNAMEIDQUERY;
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                qry.Last; qry.First;
                { 设置GPSPoints数组维数 }
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
  Description:  返回数据的起止日期  
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
  Description:  返回数据的日期列表，日期用字符串形式表示  
-----------------------------------------------------------------------------}
function TdmLeicaDatas.GetDataDateList(ADateList: TStrings): Boolean;
var     qry: TADOQuery;
        ADate: TDatetime;
begin
        Result := False;
        ADateList.Clear;
        qry := TADOQuery.Create(Self);
        qry.Connection := acnGPS;
        { 注：SQL查询使用DatePart而不是用DateName函数，为了避免不同预言的SQL Server返回的日期名称不
          统一。如英语的月份名称使用的是英语月份名，而中文则使用数字 }
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
