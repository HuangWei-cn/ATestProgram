unit Unit1;
{ TODO -o��ΰ -c������ : 
�����в�ѯ���е�һ�������ĵ�Ԫ���ɸõ�Ԫ�ṩ����SQL��ѯ��䡣�Բ�ѯ����Ҫ�ɳ����ṩ�ı�����
����Query�����ķ�ʽ�ṩ�������ַ�ʽ������ӦLeica����������ݿ��ѯ }
{ TODO -o��ΰ -c������ : ��ʸ��ͼ���ܷ��õ�һ��Frame��Ԫ�� }
{ TODO -o��ΰ -c������ : �����ݱ��ܷŵ�һ��Frame��Ԫ�� }
{ TODO -o��ΰ -c������ : ��Leica���ݾ������ø�Ϊ�Զ���ȡ�������ó�����档 }
{ TODO -o��ΰ -cʸ��ͼ : ��ʾX-H��Y-Hʸ��ͼ���������û�ѡ�񲼾ַ�ʽ }
{ TODO -o��ΰ -c����������Ϣ : �����û����嵥������������ݵ���ʾ���֣�����ͬһ������ͬʱ��ʾ
���ݱ������ߡ�ʸ��ͼ���켣ͼ }
{ TODO -o��ΰ -c�켣ͼ : �����û������Ƿ���켣ͼ������ʾ }
{ TODO -o��ΰ -c���ݲ�ѯ: ���ڸ��Ӳ�ѯ���ô�����ʱ��ķ�ʽ���� }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB, ADODB, uut4SQL, ExtCtrls,
  TeEngine, Series, TeeProcs, Chart, ComCtrls, ToolWin, uLeicaGPSData, ufrmSetPointTime,
  ArrowCha, ufraGPSTrendLine, DateUtils,Math, pngimage, Menus,janXMLTree,
  GridsEh, DBGridEh, EhLibADO, PrnDbgeh, PrViewEh, DBSumLst,
  uDisplacementLocusMap, udmLeicaGPSDatas;

type
  TfrmTest = class(TForm)
    ADOConnection1: TADOConnection;
    aqryPDatas: TADOQuery;
    aqryPoints: TADOQuery;
    dsPDatas: TDataSource;
    dsPoints: TDataSource;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    tbOpenDB: TToolButton;
    CoolBar1: TCoolBar;
    ToolButton2: TToolButton;
    tbDBSelect: TToolButton;
    Splitter2: TSplitter;
    tvwPoints: TTreeView;
    StaticText1: TStaticText;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    ToolButton1: TToolButton;
    Panel3: TPanel;
    Splitter3: TSplitter;
    GroupBox1: TGroupBox;
    optSP_SameTimeLine: TRadioButton;
    optSP_AllTimeInLine: TRadioButton;
    cmbSP_TimeList: TComboBox;
    tbDataPrecision: TToolButton;
    cmbDataTime: TComboBox;
    Label1: TLabel;
    Chart1: TChart;
    Series7: TArrowSeries;
    chtPlaneVector: TChart;
    srsPlaneVector: TArrowSeries;
    fraTrendLine: TfraGPSTrendLine;
    Panel4: TPanel;
    Label2: TLabel;
    cmbVectorDates: TComboBox;
    btnAniShowVector: TButton;
    Timer1: TTimer;
    popPlaneVector: TPopupMenu;
    miPVM_CopyBitmap: TMenuItem;
    miPVM_CopyMetaFile: TMenuItem;
    chkSP_AllTimeInGraph: TCheckBox;
    GroupBox2: TGroupBox;
    tbProfile: TToolButton;
    dbgDatas: TDBGridEh;
    optNewData: TRadioButton;
    optAllData: TRadioButton;
    optSomeData: TRadioButton;
    dtpGrd_BeginDate: TDateTimePicker;
    dtpGrd_EndDate: TDateTimePicker;
    Button1: TButton;
    dsPDataFilter: TDataSource;
    btnExpertData: TButton;
    prnDBGrid: TPrintDBGridEh;
    btnPrintData: TButton;
    aqryDataFilter: TADOQuery;
    TabSheet8: TTabSheet;
    Panel5: TPanel;
    fraLocusMap1: TfraLocusMap;
    dtpLocusStartDate: TDateTimePicker;
    dtpLocusEndDate: TDateTimePicker;
    btnDrawLocus: TButton;
    btnDynamicLocus: TButton;
    pnlLocus: TPanel;
    cmbLocusPoints: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    chkLocusAutoAxis: TCheckBox;
    chkGradient: TCheckBox;
    grdPoints: TStringGrid;
    optAnyTwoDayData: TRadioButton;
    dtpGrd_FirstDate: TDateTimePicker;
    dtpGrd_SecondDate: TDateTimePicker;
    chkAverageData: TCheckBox;
    aqryCreatViews: TADOQuery;
    aqryDropPDV: TADOQuery;
    aqryCreatePDV: TADOQuery;
    aqryDropPDVDayDiff: TADOQuery;
    aqryCreatePDVDayDiff: TADOQuery;
    aqryDropPDAV: TADOQuery;
    aqryCreatePDAV: TADOQuery;
    aqryDropPDAVDayDiff: TADOQuery;
    aqryCreatePDAVDayDiff: TADOQuery;
    aCmdTmpTblNameDateTime: TADOCommand;
    procedure tbOpenDBClick(Sender: TObject);
    procedure tbDBSelectClick(Sender: TObject);
    procedure optSP_SameTimeLineClick(Sender: TObject);
    procedure optSP_AllTimeInLineClick(Sender: TObject);
    procedure tbDataPrecisionClick(Sender: TObject);
    procedure tvwPointsDblClick(Sender: TObject);
    procedure chtPlaneVectorDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnAniShowVectorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miPVM_CopyBitmapClick(Sender: TObject);
    procedure miPVM_CopyMetaFileClick(Sender: TObject);
    procedure tbProfileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnExpertDataClick(Sender: TObject);
    procedure btnPrintDataClick(Sender: TObject);
    procedure btnDrawLocusClick(Sender: TObject);
    procedure btnDynamicLocusClick(Sender: TObject);
    procedure fraLocusMap1chtLocusClick(Sender: TObject);
    procedure fraTrendLinechtPointXClick(Sender: TObject);
    procedure fraTrendLinechtPointYClick(Sender: TObject);
    procedure fraTrendLinechtPointHClick(Sender: TObject);
    procedure ADOConnection1BeforeDisconnect(Sender: TObject);
  private
    { Private declarations }
    FAniVector: Boolean;
    FPointsRoot, FProfilesRoot: TTreeNode;
    procedure LoadParamsFromDB;
    procedure SaveParams;
    procedure ListPointsHasData;
    procedure OpenDatabase;
    procedure GetDBConnStr;
    procedure GetDataTime;
    procedure ListProfileInTreeview;
    { ��һ���������ʱ������ }
    procedure DrawPointLine(AName: String; AID: Longint; ATime: Integer=8; AllTime: Boolean=false; ATitle: String = ''; AClearOldLine: Boolean = True);
    { �����е�ˮƽ��ʸ��ͼ }
    procedure DrawPlaneVector(ADate: TDate; ATime: Integer = 8; LastDate: Boolean = True);
    { ������������ }
    procedure DrawProfileLine(AName: String);
    { ��ʾ���� }
    procedure ShowOneTheDatas(ADate: TDate);
    procedure ShowNewDatas;
    procedure ShowAllDatas;
    procedure ShowSomeDatas(ADate1, ADate2: TDate);
    procedure ShowAnyTwoDayData(ADate1, ADate2: TDate);
    procedure SetDBGridToShow;
    procedure DrawLocus;
  public
    { Public declarations }
  end;

var
  frmTest: TfrmTest;

implementation

uses
    ufrmSetupProfile, ufrmExpertDataFromDBGrid;
{$R *.dfm}
{$R WindowsXP.res }


//procedure TfrmTest.btnListInstalledInstancesClick(Sender: TObject);
//var
//        strInstances: String[255];
//begin //                                                              -
//
//        RetriveMSSQLInstalledInstances(strInstances);
//        if strinstances <> '' then ShowMessage('�����Ѱ�װ����SQL Server ʵ��'#13#10 + strinstances);          
//end;

{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.GetDBConnStr
  Description:  ��ò�����ADO������  
-----------------------------------------------------------------------------}
procedure TfrmTest.GetDBConnStr;
var
        cnStr: String;
begin
        cnstr := '';
        cnstr := PromptDataSource(0, ADOConnection1.ConnectionString);
        //ShowMessage(cnStr);
        if trim(cnStr) <> '' then
        begin
            if ADOConnection1.Connected then ADOConnection1.Close;
            ADOConnection1.ConnectionString := cnStr;
            { ��������д�������ļ� }
            WriteCNStrToSetting(cnStr);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.OpenDatabase
  Description:  �����ݿ�  
-----------------------------------------------------------------------------}
procedure TfrmTest.OpenDatabase;
var
        strID, strName: String;
        qry: TADOQuery;
        i : Integer;
begin //
        if ADOConnection1.Connected then
        begin
            ShowMessage('���ݿ��Ѿ����ӣ�');
            Exit;
        end;

        if not SQLServerStart then
        begin
            ShowMessage('SQL Server���ݿ�û�����������������ݿ�����ԡ�');
            Exit;
        end;


        try
            ADOConnection1.Open;

            { ---------------------------------- }
            //��������������ڣ�ʱ����ʱ��������#hwtemp_NameAndDateTime
            aCmdTmpTblNameDateTime.Execute;
            //ɾ����ͼ
            aqryDropPDV.ExecSQL;
            aqryDropPDAV.ExecSQL;
            aqryDropPDVDayDiff.ExecSQL;
            aqryDropPDAVDayDiff.ExecSQL;
            //������ͼ
            aqryCreatePDV.ExecSQL;
            aqryCreatePDVDayDiff.ExecSQL;
            aqryCreatePDAV.ExecSQL;
            aqryCreatePDAVDayDiff.ExecSQL;

            { ---------------------------------- }
            { ��ʾ����Ϣ������Spider����ͬ���ʱ�εĵ��Զ������˺�׺�������Ҫȥ����Щ��׺����
              ��������ĵ����ơ�Spider������õ�ԭ�����ڲ�ͬ���ʱ�Σ���24h��6h��3h�ȣ������ݾ���
              ��ͬ����Ӧ��Ϊһ̸��������ҲӦ��˿��ǣ�����Ҫ�ֹ����벻ͬʱ�ε�ID���֡� }
            aqryPoints.SQL.Text := 'select Distinct left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName From Points ORDER BY PName';
            aqryPoints.Open;

            GetDataTime;

            //����tvwPoints
            tvwPoints.Items.Clear;
            FPointsRoot := tvwPoints.Items.Add(nil, '����');
            FProfilesRoot := tvwPoints.Items.Add(nil, '������');
            ListProfileInTreeview;

            //��cmbPoints����д�㣬��tvwPoints��д��
            if aqryPoints.RecordCount > 0 then
            begin
                aqryPoints.Last; aqryPoints.First;
                //ListPointsHasData;
                while not aqryPoints.Eof do
                begin
                    //strID := aqryPoints.FieldByName('ID').AsString;
                    strName := aqryPoints.Fieldbyname('PName').AsString;
                    tvwPoints.Items.AddChild(tvwPoints.Items[0], strName{ + #9 + strID});
                    aqryPoints.Next;
                end;    // while
            end;

            //btnOpenDB.Enabled := False;
            { ---------------------------------------------------------------------- }
            { ��дGPSPointsָ������ }
            aqryPoints.Close;
            aqryPoints.SQL.Text := 'select Distinct ID,left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName From Points ORDER BY PName, ID';
            aqryPoints.Open;
            aqryPoints.Last;aqryPoints.First;
            SetLength(GPSPoints, aqryPoints.RecordCount);
            i := 0;
            repeat
                New(GPSPoints[i]);
                GPSPoints[i].Name   := aqryPoints.FieldValues['PName'];
                GPSPoints[i].ID     := aqryPoints.FieldValues['ID'];
                aqryPoints.Next;
                inc(i);
            until aqryPoints.Eof;

            { ��ȡ�������ڣ�ÿһ�죬����ʱ�� }
            qry := TADOQuery.Create(Self);
            qry.Connection := Self.ADOConnection1;
            try
                //ע����DateName(mm, Epoch)ʱ������Ӣ��SQL Serverϵͳ���������·ݵ�Ӣ��������������
                //�ֶβ���ȷ������2010-April-20���Ͳ�����Ч�����ڸ�ʽ
                //qry.SQL.Text := 'SELECT DISTINCT datename(yyyy,epoch)+''-''+datename(mm,epoch)+''-''+DATENAME(dd,epoch) as PDate FROM RESULTS ORDER BY PDate';
                qry.SQL.Text := 'SELECT DISTINCT datePart(yyyy,epoch) AS DataYear,datePart(mm,epoch) AS DataMonth,DATEPart(dd,epoch) AS DataDay FROM RESULTS ORDER BY DataYear, DataMonth, DataDay';
                qry.Open;

                qry.Last;
                qry.First;

                cmbvectordates.Clear;
                repeat
                    //cmbVectorDates.Items.Add(DateToStr(qry.FieldByName('PDate').AsDateTime));
                    cmbVectorDates.Items.Add(FormatDateTime('yyyy-mm-dd',
                        + EncodeDate(qry.FieldValues['DataYear'], qry.FieldValues['DataMonth'], qry.FieldValues['DataDay'])));
                    qry.Next;
                until qry.Eof;

                qry.Close;

                qry.SQL.Text := 'SELECT MIN(EPOCH) AS MINDATE, MAX(EPOCH) AS MAXDATE FROM RESULTS';
                qry.Open;
                DataBeginDate := qry.FieldByName('MINDate').AsDateTime;
                fraTrendLine.dtpTL_BeginDate.DateTime := DataBeginDate;
                DataLastDate := qry.FieldByName('MAXDate').AsDateTime;
                fraTrendLine.dtpTL_EndDate.DateTime := DataLastDate;
                dtpGrd_EndDate.Date := DataLastDate;
                dtpGrd_BeginDate.Date := DataBeginDate;
                dtpGrd_FirstDate.Date := DataBeginDate;
                dtpGrd_SecondDate.Date := DataLastDate;
                dtpLocusStartDate.Date := DataBeginDate;
                dtpLocusEndDate.Date := DataLastDate;

            finally
                FreeAndNil(qry);
            end;

            LoadParamsFromDB;
            SaveParams;
            if cmbDataTime.Items.Count > 0 then cmbDataTime.ItemIndex := 0;

        except
            on e: Exception do
              ShowMessage(e.Message);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ListPorfileInTreeview
  Description:  ��������ӵ�tvwPoints����PrjSetting�ж�ȡ  
-----------------------------------------------------------------------------}
procedure TfrmTest.ListProfileInTreeview;
var     i: Integer;
        pfNode: TjanXMLNode;
begin
        pfNode := PrjSetting.findNamedNode('Profiles');
        if pfNode = nil then exit;
        for i := 0 to pfnode.Nodes.Count -1 do
            tvwPoints.Items.AddChild(FProfilesRoot, TjanXMLNode(pfNode.Nodes[i]).Name);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.btnShowPDataClick
  Description:  ��ʾ�û�ѡ��ĵ�����ݼ���ֵ������  
-----------------------------------------------------------------------------}
//procedure TfrmTest.btnShowPDataClick(Sender: TObject);
//begin
//        //ȡ�����ID��NAME
//        str := cmbPoints.Items[cmbPoints.itemIndex];
//        postab := pos(#9,str);
//        strID := copy(str,1,postab -1);
//        strName := copy(str,postab+1,length(str)-postab);
//        //showmessage(strID + #13#10 + strname);
//        aid := strtoint(strID);
//
//        //��ʾ������ݺ͹�����
//        aqryPDatas.SQL.Text := 'SELECT ID, Point_ID, Epoch, Easting, Northing, Height, EastingDiff, NorthingDiff, HeightDiff '
//            + 'FROM Results '
//            + 'WHERE Point_ID = ' + strID
//            + 'ORDER BY Point_ID, Epoch';
//        aqryPDatas.Open;
//        //grdPDatas.Columns[4].Field.;
//        chtTrendLine.Title.Text.Text := '���� ' + strName + ' ��������ʱ������';
//
//        ShowTrendLine;
//end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ShowTrendLine
  Description:  ��ʾ����ֵ������
-----------------------------------------------------------------------------}
//procedure TfrmTest.ShowTrendLine;
//var
//        dx,dy,dz: double;
//        dt: TDateTime;
//        qry: TADOQuery;
//begin
//        chtTrendLine.Series[0].Clear;
//        chtTrendLine.Series[1].clear;
//        chtTrendLine.Series[2].clear;
//
//        if not aqrypdatas.Active then Exit;
//        qry := TADOQuery.Create(Self);
//        qry.Connection := aqryPDatas.Connection;
//        qry.SQL.Text := aqryPDatas.SQL.Text;
//        try
//            qry.Open;
//            if qry.recordcount > 0 then
//            begin
//                qry.First;
//                repeat
//                    try
//                        dx := qry.FieldValues['EastingDiff'];
//                        dy := qry.FieldValues['NorthingDiff'];
//                        dz := qry.FieldValues['HeightDiff'];
//                        dt := qry.FieldValues['Epoch'];
//
//                        chtTrendLine.Series[0].AddXY(dt, dx);
//                        chtTrendLine.Series[1].AddXY(dt, dy);
//                        chtTrendLine.Series[2].AddXY(dt, dz);
//                    except
//                        //do nothing
//                    end;
//                    qry.Next;
//                until qry.Eof;
//            end;
//        finally
//            FreeAndNil(qry);
//        end;
//
//end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ListPointsHasData
  Description:  �г�ӵ�����ݵļ���
  �������ѷ�
-----------------------------------------------------------------------------}
procedure TfrmTest.ListPointsHasData;
var
        qry: TADOQuery;
        strID, strName: String;
begin
        qry := TADOQuery.Create(Self);
        try
            qry.Connection := Self.ADOConnection1;
            qry.SQL.Text := 'SELECT DISTINCT Point_ID FROM Results ORDER BY Point_ID';
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                qry.First;
                repeat
                    strid := qry.FieldByName('Point_ID').AsString;
                    //strName := qry.fieldbyname('Name').AsString;
                    //cmbPoints.Items.Add(strid + #9 + strname);
                    qry.Next;
                until qry.Eof;
            end;
        finally
            FreeAndNil(qry);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.tbOpenDBClick
  Description:  �����ݿ�  
-----------------------------------------------------------------------------}
procedure TfrmTest.tbOpenDBClick(Sender: TObject);
begin
        OpenDatabase;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.tbDBSelectClick
  Description:  �������ݿ�����  
-----------------------------------------------------------------------------}
procedure TfrmTest.tbDBSelectClick(Sender: TObject);
begin
        GetDBConnStr;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.GetDataTime
  Description:  ȡ������ʱ�̼���ʱ����������  
-----------------------------------------------------------------------------}
procedure TfrmTest.GetDataTime;
var
        qry: TADOQuery;
        i: Integer;
begin
        qry := TADOQuery.Create(Self);
        qry.Connection := ADOConnection1;
        qry.SQL.Text := 'SELECT PTime, count(PTime) as PTNum FROM (select distinct point_id, ROUND(DATEPART(hour,epoch) + DATEPART(MINUTE,epoch)/100.00,0 ) as PTime from results ) t1 Group By ptime';
        try
            qry.Open;
            if qry.RecordCount > 0 then
            begin
                cmbSP_TimeList.Clear;
                qry.Last; qry.First;
                SetLength(GDT, qry.RecordCount);
                i := 0;
                repeat
                    GDT[I].TheHour  := qry.FieldValues['PTime'];
                    GDT[i].Number   := qry.FieldValues['PTNum'];
                    cmbSP_TimeList.Items.Add(IntToStr(GDT[i].TheHour));
                    qry.Next;
                    inc(i);
                until qry.Eof;
                cmbSP_TimeList.ItemIndex := 0;
            end;
        finally
            FreeAndNil(qry);
        end;
end; 

procedure TfrmTest.optSP_SameTimeLineClick(Sender: TObject);
begin
        cmbSP_TimeList.Enabled := True;
end;

procedure TfrmTest.optSP_AllTimeInLineClick(Sender: TObject);
begin
        cmbSP_TimeList.Enabled := False;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ToolButton3Click
  Description:  ��ʾ��������ý���  
-----------------------------------------------------------------------------}
procedure TfrmTest.tbDataPrecisionClick(Sender: TObject);
var     frm: TfrmSetPointTime;
begin
        frm := TfrmSetPointTime.Create(Self);
        frm.ShowModal;
        FreeAndNil(frm);
        if cmbDataTime.Items.Count > 0 then cmbDataTime.ItemIndex := 0;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.tvwPointsDblClick
  Description:  ˫��Tree�ڵ㣬�Զ��ж�Ҫ����
-----------------------------------------------------------------------------}
procedure TfrmTest.tvwPointsDblClick(Sender: TObject);
var
        node    : TTreeNode;
        PID     : LongInt;
        PTime   : Integer;
        bAllTime: Boolean;
        LineTile: String;
        i       : Integer;
        bClear  : Boolean;
        { ---------------------------------------------------------------- }
        function GetPointID(AName: String; DataInterval: Integer): LongInt;
        var i,j: Integer;
        begin
            Result := -1;
            for i := 0 to Length(DataPrecisions) -1 do
                if DataPrecisions[i].Interval = DataInterval then
                    for J := 0 to Length(DataPrecisions[i].Points) -1 do
                        if DataPrecisions[i].Points[j]^.Name = AName then
                        begin
                            Result := DataPrecisions[i].Points[j]^.ID;
                            Exit;
                        end;
        end;
        { ---------------------------------------------------------------- }
begin  {  }
        if tvwPoints.Selected = nil then Exit;
        node := tvwPoints.Selected;
        if node.Level = 0 then Exit;

        //��ʾȫ����ֵ�����ߣ��ϲ���ͬһ��ͼ��
        if (Node.Level = 0) and (Node.Text = '����') then
        begin
        end;

        //��ʾ�����ֵ������---------------------------------------------------
        if node.Level = 1 then
        begin
            if node.Parent.Text = '����' then
            begin
                //ShowMessage('���Ǽ��㣬���ֽУ�' + Node.Text);
                { ˫������ʾ�����ֵ������------------------------------- }
                //ȡ�ò��ID
                PID := GetPointID(Node.Text, StrToInt(cmbDataTime.Text));
                if PID = -1 then Exit;
                if optSP_SameTimeLine.Checked then
                begin
                    bAllTime := False;
                    PTime := StrToInt(cmbSP_TimeList.Text);
                    if cmbDataTime.Text = '24' then
                        DrawPointLine(Node.Text, PID, PTime, True)  //24Сʱ����ÿ�ս�һ���ݣ�����Ҫ��ʱ�̹����ˡ�
                    else
                    begin
                        if Not chkSP_AllTimeInGraph.Checked then //ֻ����һ��ʱ������
                            DrawPointLine(Node.Text, PID, PTime, bAllTime)
                        else //ͬһ��ͼ�л��ƶ��ʱ��ͬ�ȹ�����
                            for i := 0 to cmbSP_TimeList.Items.Count -1 do
                            begin
                                if i = 0 then bClear := True else bClear := False;

                                PTime := StrToInt(cmbSP_TimeList.Items[i]);
                                DrawPointLine(Node.Text, PID, PTime, bAllTime, '', bClear);
                            end;
                    end;
                end
                else
                begin { ��ͬʱ������ }
                    bAllTime := True;
                    DrawPointLine(Node.Text, PID, PTime, bAllTime);
                end;
            end
            else if node.Parent.Text = '������' then
            begin
                DrawProfileLine(Node.Text);
            end;
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.DrawPointLine
  Description:  �����AName�������ߣ�ʹ��AID�����ݣ�ȱʡ����ʱ��Ϊ8�㣬ȱʡ
                ����Ϊ�ա�������Ϊ�յ�ʱ��ʹ��AName��Ϊ������Legent���ݡ�
                AllTimeѡ�����ھ����Ƿ���ʱ�䣬������ȡ�ռ�ͬʱ�����߷�ʽ��
-----------------------------------------------------------------------------}
procedure TfrmTest.DrawPointLine(AName: String; AID: Longint; ATime: Integer=8; AllTime: Boolean=false;
    ATitle: String = ''; AClearOldLine: Boolean=True);
var
        qry: TADOQuery;
        strWhere, strDate1, strDate2: String;
begin
        qry := TADOQuery.Create(Self);
        qry.Connection := Self.ADOConnection1;
        try
            { ---------------δʹ����ͼ�Ĳ�ѯ�������������������ܴ���ƽ��ֵ----------------------- }
//            qry.SQL.Text := 'select Point_ID , Epoch as DTScale, EastingDiff as dx, NorthingDiff as dy, HeightDiff as dh, ROUND(DATEPART(hour,epoch) + DATEPART(MINUTE,epoch)/100.00,0 ) as PTime From Results ';
//            strWhere := ' WHERE (Point_ID=' + IntToStr(AID) + ') AND (Epoch BETWEEN '''
//                    + DateToStr(fraTrendLine.dtpTL_BeginDate.Date)
//                    + ''' AND ''' + DateToStr(fraTrendLine.dtpTL_EndDate.Date) + ''')';
//            qry.SQL.Text := qry.SQL.Text + strWhere + ' ORDER BY Epoch';
//            qry.Open;
//            if qry.RecordCount > 0 then
//            begin
//                if Not AllTime then
//                begin
//                    qry.Filter := 'PTime = '+ IntToStr(ATime);
//                    qry.Filtered := True;
//                end;
//                if AClearOldLine then fraTrendLine.ClearDatas(True);
//                fraTrendLine.DrawNewLine(AName, AName, qry, 1000);
//            end
//            else ShowMessage('û������');

            { ---------------ʹ����ͼ�Ĳ�ѯ------------------------------------------------------- }
            strDate1 := FormatDateTime('yyyy-mm-dd', fraTrendLine.dtpTL_BeginDate.Date);
            strDate2 := FormatDateTime('yyyy-mm-dd', fraTrendLine.dtpTL_EndDate.Date);

            if chkAverageData.Checked then
            begin
                qry.SQL.Text := 'SELECT Point_ID, DTScale, PTime, avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH FROM hwview_PointAVGDatas ';
                strWhere := 'WHERE (Point_ID=' + IntToStr(AID) + ') '
                    + 'AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') ';
                qry.SQL.Text := qry.SQL.Text + strWhere + ' ORDER BY DTScale';
            end
            else
            begin
                qry.SQL.Text := 'SELECT Point_ID, DTScale, PTime, dNorthing AS dX, dEasting AS dY, dHeight AS dH FROM hwview_PointDatas ';
                strWhere := 'WHERE (Point_ID=' + IntToStr(AID) + ') '
                    + 'AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') ';
                if Not AllTime then strWhere := strWhere + 'AND (PTime=' + IntToStr(ATime) + ') ';
                qry.SQL.Text := qry.SQL.Text + strWhere + ' ORDER BY DTScale';
            end;

            qry.Open;
            if qry.RecordCount > 0 then
            begin
                if AClearOldLine then fraTrendLine.ClearDatas(True);
                fraTrendLine.DrawNewLine(AName, AName, qry, 1);
            end
            else
                MessageDlg('û���ҵ�������ݣ�������ѡ��������������ʱ��Ρ�', mtWarning, [mbOK], 0);
            { ------------------------------------------------------------------------------------ }
        finally
            FreeAndNil(qry);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.DrawPlaneVector
  Description:  �������е��ˮƽ��ʸ��ͼ��ADate�ǻ��Ƶ��������ڣ�ATime��
                ����ʱ�̡�  
-----------------------------------------------------------------------------}
procedure TfrmTest.DrawPlaneVector(ADate: TDate; ATime: Integer = 8; LastDate: Boolean = True);
var
        qry: TADOQuery;
        strWhere, strIn: String;
        TheLastDate: TDate;
        TheDay, TheYear, TheMonth: Integer;
        X,Y,ddx,ddy,ddH: Double;
        iseries: Integer;
        NewArrowSeries: TArrowSeries;
        PName: String;
        { ------------------------------------------------------------------ }
        function GetSQLInStr: String;
        var i,j: Integer;
        begin
            result := '';
            for i := 0 to Length(DataPrecisions) -1 do
                if DataPrecisions[i].Interval = StrToInt(cmbDataTime.Text) then
                    for j := 0 to Length(DataPrecisions[i].Points) -1 do
                        Result := Result + IntToStr(DataPrecisions[i].Points[j]^.ID) + ',';
            if Length(Result) > 1 then
                Result := Copy(Result, 1, Length(Result)-1);
        end;
        { ------------------------------------------------------------------ }
begin
        qry := TADOQuery.Create(Self);
        qry.Connection := Self.ADOConnection1;
        try
            if LastDate then
            begin
                qry.SQL.Text := 'SELECT MAX(EPOCH) AS LASTDATE FROM RESULTS';
                qry.Open;
                qry.First;
                TheLastDate := qry.FieldValues['LASTDATE'];
                qry.Close;
                TheDay      := dayof(thelastdate);
                themonth    := monthof(TheLastDate);
                theyear     := yearof(TheLastDate);
            end
            else
            begin
                TheLastDate := ADate;
                theday      := dayof(adate);
                themonth    := monthof(adate);
                theyear     := yearof(adate);
            end;

            { ===================δʹ����ͼ��ʽ=================================================== }
//                strWhere := ' WHERE (Point_ID ';
//                strIn       := 'IN (' + GetSQLInStr + ')';
//                strWhere    := strWhere + strIn + ') AND (YEAR(T1.Epoch)= ' + IntToStr(theyear)
//                            + ') AND (MONTH(T1.Epoch)= ' + IntToStr(TheMonth)
//                            + ') AND (DAY(T1.Epoch)= '+ IntToStr(TheDay)
//                            + ')';
//                qry.SQL.Text := 'SELECT Point_ID , [Name] as PName, T1.Epoch as DTScale, Easting as X, '
//                            + 'Northing as Y, EastingDiff as dx, NorthingDiff as dy, HeightDiff as dh, '
//                            + 'ROUND(DATEPART(hour,T1.epoch) + DATEPART(MINUTE,T1.epoch)/100.00,0 ) as PTime '
//                            + 'From Results T1 INNER JOIN Points T2 ON T1.Point_ID=T2.ID '
//                            + strWhere;

            { ==================ʹ����ͼ��ѯ====================================================== }
            if not chkAverageData.Checked then
            begin
                strWhere := 'WHERE (Point_ID IN (' + GetSQLInStr + ')) AND (DTScale='''
                            + FormatDateTime('yyyy-mm-dd', TheLastDate) + ''') AND (PTime='
                            + IntToStr(ATime) + ') ';
                qry.SQL.Text := 'SELECT Point_ID, PointName AS PName, DTSCale, PTime,'
                               +'       Northing AS X, Easting AS Y, Height AS H,'
                               +'       dNorthing AS dX, dEasting AS dY, dHeight AS dH, Len '
                               +'FROM hwview_PointDatas '
                               + strWhere
                               +'ORDER BY PointName, DTScale';
            end
            else
            begin
                strWhere := 'WHERE (Point_ID IN (' + GetSQLInStr + ')) AND (DTScale='''
                            + FormatDateTime('yyyy-mm-dd', TheLastDate) + ''') ';
                qry.SQL.Text := 'SELECT Point_ID, PointName AS PName, DTScale, PTime,'
                               +'       avgNorthing AS X, avgEasting AS Y,'
                               +'       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH, avgLen AS Len '
                               +'FROM hwview_PointAVGDatas '
                               + strWhere
                               +'ORDER BY PointName, DTScale';
            end;
            { =================================================================================== }
            qry.Open;

//            if not chkAverageData.Checked then  //ƽ��ֵ��û��ʱ�̵Ρ���
//            begin
//                qry.Filter  := 'PTime = ' + IntToStr(ATime);
//                qry.Filtered := True;
//            end;
            qry.Last;qry.First;

            chtPlaneVector.Title.Text.Clear;
            chtPlaneVector.Title.Text.Add('����GPS����ˮƽ��ʸ��ͼ��' + DateToStr(TheLastDate) + '��   ����������1:10000');
            if chtPlaneVector.SeriesCount > 0 then
                for iseries := 0 to chtPlaneVector.SeriesCount -1 do
                    chtPlaneVector.SeriesList[iSeries].Free;
            chtPlaneVector.SeriesList.Clear;

            NewArrowSeries := TArrowSeries.Create(Self);
            NewArrowSeries.ParentChart := chtPlaneVector;
            //NewArrowSeries.Assign(srsPlaneVector);
            NewArrowSeries.XValues.DateTime := False;
            NewArrowSeries.ArrowWidth := 9;
            NewArrowSeries.ArrowHeight := 10;
            NewArrowSeries.Pointer.Pen.Width := 3;
            NewArrowSeries.Marks.Visible := True;
            NewArrowSeries.Marks.Transparent := False;
            NewArrowSeries.Marks.BackColor := clWhite;
            NewArrowSeries.Marks.Clip := True;
            NewArrowSeries.Marks.Frame.Visible := True;
            NewArrowSeries.Marks.ArrowLength := 10;
            NewArrowSeries.Marks.Font.Color := clBlue;
            NewArrowSeries.Marks.Frame.Color := clBlue;
            if qry.RecordCount > 0 then
                repeat
                    X := qry.FieldValues['X'];
                    Y := qry.FieldValues['Y'];
                    //ddx := qry.FieldValues['dx'] * 10000;
                    //ddy := qry.FieldValues['dy'] * 10000;
                    ddx := qry.FieldValues['dx'] * 10;  //��ͼ��ʽ�Ѿ�����������1000��
                    ddy := qry.FieldValues['dY'] * 10;
                    ddH := qry.FieldValues['dH'];
                    //PName := qry.FieldValues['PName'];
//                    PName := Copy(PName, 1, Pos('_', PName)-1) + '    L:' + FloatToStr(RoundTo(sqrt(sqr(ddx/10000)+sqr(ddy/10000)+sqr(ddh))*1000,-2)) + 'mm'
//                            + #13#10'dX:'+FloatToStr(RoundTo(ddx/10,-2)) + ', dY:' + FloatToStr(RoundTo(ddy/10,-2)) + ', dH:' + FloatToStr(RoundTo(ddH*1000, -2)) + '      ';
                    PName := qry.FieldValues['PName'] + '    L:' + FloatToStr(RoundTo(qry.FieldValues['Len'], -2)) + 'mm'
                            + #13#10'dX:'+FloatToStr(RoundTo(ddx/10,-2)) + ', dY:' + FloatToStr(RoundTo(ddy/10,-2)) + ', dH:' + FloatToStr(RoundTo(ddH, -2)) + '      ';

                    { ע���ڲ���ϵͳ�У�������X���򣬺�����Y���򣬵����ڼ���ֱ������ϵ�У�X�Ǻ��ᣬY�����ᡣ
                      ����ڻ�ͼ��ʱ��ע��Ӧ��X��Y���� }
                    NewArrowSeries.AddArrow(Y,X,Y+ddY,X+ddX, PName);

                    qry.Next;
                until qry.Eof;
            chtPlaneVector.BottomAxis.LabelStyle := talValue;
            chtPlaneVector.BottomAxis.Automatic := False;
            chtPlaneVector.BottomAxis.Maximum := 426700  ;
            chtPlaneVector.BottomAxis.Minimum := 426100  ;
            chtPlaneVector.LeftAxis.Automatic := False;
            chtPlaneVector.LeftAxis.Maximum := 3993550;
            chtPlaneVector.LeftAxis.Minimum := 3992950;
        finally
            FreeAndNil(qry);
        end;
end;

procedure TfrmTest.chtPlaneVectorDblClick(Sender: TObject);
var     iTime: Integer;
begin
        if cmbSP_TimeList.ItemIndex = -1 then iTime := 8
        else
            iTime := StrToInt(cmbSP_TimeList.Text);
          
        if cmbVectorDates.ItemIndex <> -1 then
            DrawPlaneVector(StrToDate(cmbVectorDates.Text),iTime,false)
        else
            DrawPlaneVector(Now,iTime,True);
end;

procedure TfrmTest.Timer1Timer(Sender: TObject);
begin
        {  }
        if FAniVector then
        begin
            if cmbVectorDates.Items.Count = 0 then Exit;
              
            if cmbVectorDates.ItemIndex = -1 then
                cmbVectorDates.ItemIndex := 0;

            DrawPlaneVector(StrToDate(cmbVectorDates.Text),8,false);

            if cmbVectorDates.ItemIndex = cmbVectorDates.Items.Count -1 then
                cmbVectorDates.ItemIndex := 0
            else
                cmbVectorDates.ItemIndex := cmbVectorDates.ItemIndex + 1;
        end;
end;

procedure TfrmTest.btnAniShowVectorClick(Sender: TObject);
begin
        if Timer1.Enabled then
        begin
            Timer1.Enabled := False;
            FAniVector := False;
            btnAniShowVector.Caption := '��̬��ʾ';
        end
        else
        begin
            FAniVector := True;
            Timer1.Enabled := True;
            btnAniShowVector.Caption := 'ֹͣ��̬';
        end;
end;

procedure TfrmTest.FormCreate(Sender: TObject);
var     cnStr: String;
begin
        cnStr := ReadCNStrFromSetting;
        if ADOConnection1.Connected then ADOConnection1.Close;
          
        if cnStr <> '' then Self.ADOConnection1.ConnectionString := cnStr;
        { ��ʼ���켣ͼ�������� }
        fraLocusMap1.InitParams;

        with grdPoints do
        begin
            Cells[0,0] := '�����';
            Cells[1,0] := '���ID';
            Cells[2,0] := '���ʱ��';
            Cells[3,0] := '�ղ��';
        end;    // with

end;

procedure TfrmTest.miPVM_CopyBitmapClick(Sender: TObject);
begin
        chtPlaneVector.CopyToClipboardBitmap;
end;

procedure TfrmTest.miPVM_CopyMetaFileClick(Sender: TObject);
begin
        chtPlaneVector.CopyToClipboardMetafile(False);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.tbProfileClick
  Description:  ���塢�޸ġ�ɾ����������  
-----------------------------------------------------------------------------}
procedure TfrmTest.tbProfileClick(Sender: TObject);
var     frm: TfrmProfile;
begin
        frm := TfrmProfile.Create(Self);
        frm.ShowModal;
        FreeAndNil(frm);
        { ˢ�¶����б� }
        if FProfilesRoot = nil then Exit;
        { ɾ������������� }
        FProfilesRoot.DeleteChildren;
        ListProfileInTreeview;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.DrawProfileLine
  Description:  �������ʱ������
                �������������ѡ��ʽ�͵��������ͬ����û�С���ʱ�����ߡ���ʽ  
-----------------------------------------------------------------------------}
procedure TfrmTest.DrawProfileLine(AName: String);
var
        qryData, qryPoints: TADOQuery;
        xNode: TjanXMLNode;
        strSQL, strWhere, StrIn, sName, strDate1, strDate2: string;
        pid: Longint;
        { -------------------------------------------------- }
        //���ݶ�����������ݣ���ѡ�����ȵ�ID��ѡ���ÿ��ID������д��'23423,345345,123123'����ʽ��
        //����SQL��In������ѡ���ľ���Ҳ�����ݴ���������cmbDataTime��ȡֵ
        function getSQLInStr: String;
        var i, iPrecision, iPoint: Integer;
            intID: Longint;
        begin
            result := '';
            iPrecision := -1;
            for i := 0 to Length(DataPrecisions) -1 do
                if DataPrecisions[i].Interval = StrToFloat(cmbDataTime.Text) then iPrecision := i;
            if iPrecision = -1 then Exit;
            if Length(DataPrecisions[iPrecision].Points) = 0 then Exit;
              
            for iPoint := 0 to Length(DataPrecisions[iPrecision].Points) -1 do
            begin
                if xNode.findNamedNode(DataPrecisions[iPrecision].Points[iPoint]^.Name) <> nil then
                    Result := Result + IntToStr(DataPrecisions[iPrecision].Points[iPoint]^.ID) + ',';
            end;
            Result := Copy(Result, 1, Length(Result)-1); //ȥ�����һ������
        end;
        { -------------------------------------------------- }
begin
        if Trim(AName) = '' then Exit;
        xNode := PrjSetting.findNamedNode('Profiles').findNamedNode(AName);
        if xNode = nil then Exit;
        if not xNode.hasChildNodes then Exit;

        qryData := TADOQuery.Create(self);
        qryData.Connection := ADOConnection1;

        qryPoints := TADOQuery.Create(Self);
        qryPoints.Connection := self.ADOConnection1;

        strIn := getSQLInStr;
        if strIn = '' then Exit;

        { ---------------------δʹ����ͼ��ʽ��������������--------------------------------------- }
//        strSQL := 'SELECT Point_ID, PName, T1.Epoch as DTScale, '
//            + 'ROUND(DATEPART(hour,T1.epoch) + DATEPART(MINUTE,T1.epoch)/100.00,0 ) as PTime, '
//            + 'EastingDiff as dx, NorthingDiff as dy, HeightDiff as dh '
//            + 'FROM Results T1 INNER JOIN (SELECT ID, left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName FROM Points) T2 ON T1.Point_ID=T2.ID ';
//        strWhere := ' WHERE (Point_ID IN (' + strIn + ')) AND (EPoch BETWEEN '''
//                  + DateToStr(fraTrendLine.dtpTL_BeginDate.Date)
//                  + ''' AND ''' + DateToStr(IncDay(fraTrendLine.dtpTL_EndDate.Date,1)) + ''') ';
//        strSQL := strSQL + strWhere + ' ORDER BY Point_ID, DTScale';

        { --------------------ʹ����ͼ��ʽ-------------------------------------------------------- }
        strDate1 := FormatDateTime('yyyy-mm-dd', fraTrendLine.dtpTL_BeginDate.Date);
        strDate2 := FormatDateTime('yyyy-mm-dd', fraTrendLine.dtpTL_EndDate.Date);

        if chkAverageData.Checked then
        begin
            strSQL := 'SELECT Point_ID, PointName AS PName, DTScale, PTime,'
                    + '     avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH '
                    + 'FROM hwview_PointAVGDatas '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') '
                    + 'ORDER BY Point_ID, DTScale';

            qryData.SQL.Text := strSQL;
        end
        else
        begin
            strSQL := 'SELECT Point_ID, PointName as PName, DTScale, PTime,'
                    + '     dNorthing AS dX, dEasting AS dY, dHeight AS dH '
                    + 'FROM hwview_PointDatas '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale BETWEEN ''' + strDate1 + ''' '
                    + '     AND ''' + strDate2 + ''') AND (PTime=' + cmbSP_TimeList.Text + ') '
                    + 'ORDER BY Point_ID, DTScale';
            qryData.SQL.Text := strSQL;
        end;
        { ---------------------------------------------------------------------------------------- }

        { ���������ṩ��ʽ��һ���Խ����е�����ȡ�������ݸ�fraTrendLine������
          �Լ���ɸ��������ݵ���ӹ��� }
        //������ѯ
        qryPoints.SQL.Text := 'SELECT ID, left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName FROM Points '
                            + 'WHERE ID IN (' + StrIn + ') ORDER BY PNAME';
        try
            qryData.Open;
            { ��ͼ��ʽ����Ҫ���ˣ�ֱ���ڲ�ѯ�о��Ѿ�����ʱ�������� }
//            qryData.Filter := '(PTime = '+ cmbSP_TimeList.Text + ') ';
//            qryData.Filtered := True;
            qryPoints.Open;
            if qryData.RecordCount = 0 then
            begin
                MessageDlg('û���ҵ����ݣ���������ݴ��ʱ�����ú����ԡ�', mtError, [mbOK], 0);
            end
            else
                fraTrendLine.DrawProfileLine(AName, qryData, qryPoints);
        finally
            freeandnil(qryData);
            FreeAndNil(qryPoints);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.SetDBGridToShow
  Description:  ��ʽ�����ݱ��
-----------------------------------------------------------------------------}
procedure TfrmTest.SetDBGridToShow;
var     i: Integer;
begin
        with dbgDatas do
        begin
            Columns[1].Title.Caption := '�����';
            Columns[2].Title.Caption := '�������';
            Columns[3].Title.Caption := '����ʱ��';
            if chkAverageData.Checked then
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
            ListSource := dsPDataFilter;
            ListField := 'PointName';
            KeyField := 'PointName';
            //DataField := 'PName';
        end;
        with dbgDatas.Columns[2].STFilter do
        begin
            ListSource := dsPDataFilter;
            ListField := 'PDate';
            KeyField := 'PDate';
        end;    // with
        with dbgDatas.Columns[3].STFilter do
        begin
            ListSource := dsPDataFilter;
            ListField := 'PTime';
            KeyField := 'PTime';
        end;    // with
        for i := 0 to dbgDatas.Columns.Count -1 do
        begin
            dbgDatas.Columns[i].Title.TitleButton := True;
            dbgDatas.Columns[i].OptimizeWidth; //�Զ���Ӧ�п�
            dbgDatas.Columns[i].Width := dbgDatas.Columns[i].Width + 15;    //��΢��չһ��
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ShowOneTheDatas
  Description:  ��ʾĳ�յ����ݣ��е㸴�ӵĲ�ѯ����
                ע��ʹ��DateName������ʱ�򣬷����·����ƿ�����Ӣ�Ķ�������
-----------------------------------------------------------------------------}
procedure TfrmTest.ShowOneTheDatas(ADate: TDate);
var     qry: TADOQuery;
        strSQL, strWhere,strWhere2, strFrom1, strOrder, strIN, strFilterSQL: String;
        theYear, theMonth, theDay: Integer;
        i :Integer;
begin
        dbgDatas.ClearFilter;

        if aqryPDatas.Active then aqryPDatas.Close;
        if aqryDataFilter.Active then aqryDataFilter.Close;

        { ======================= δʹ����ͼ�Ĵ��� =============================================== }
        { δʹ����ͼ�Ĵ��������ȷִ�У������ܲ�ѯƽ��ֵ }
//        theYear := Yearof(ADate); theMonth := monthof(adate); theday := dayof(adate);
//
//        strFrom1 := 'SELECT Point_ID, B.[Name], A.Epoch, Easting, Northing, Height, '
//                  + 'EastingDiff, NorthingDiff, HeightDiff '
//                  + 'FROM Results A INNER JOIN Points B ON Point_ID=B.ID '
//                  + 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + '))'
//                  + 'AND (YEAR(A.Epoch)= ' + IntToStr(theyear)
//                  + ') AND (MONTH(A.Epoch)= ' + IntToStr(TheMonth)
//                  + ') AND (DAY(A.Epoch)= '+ IntToStr(TheDay)
//                  + ')';
//
//        strWhere := ' WHERE (T2.Point_ID=T1.Point_ID) AND (DATEDIFF(d,T2.Epoch,T1.Epoch)=1) AND (DATEPART(hh,T2.Epoch)=DATEPART(HH,T1.EPoch))';
//        strOrder := ' ORDER BY PDate,PName,PTime';
//        strSQL   := 'SELECT T1.Point_ID,'
//                  + 'LEFT(T1.[name],PATINDEX (''%[_]%'' , T1.[Name])-1) as PName,'
//                  + 'CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE,'
//                  + SQL_PTIME + ','
//                  + 'T1.Easting AS X,'
//                  + 'T1.Northing AS Y,'
//                  + 'T1.Height AS H,'
//                  + 'T1.EastingDiff *1000 as dX,'
//                  + 'T1.NorthingDiff *1000 AS dY,'
//                  + 'T1.HeightDiff*1000 AS dH,'
//                  + 'SQRT(SQUARE(T1.EastingDiff)+SQUARE(T1.NorthingDiff)+SQUARE(T1.HeightDiff))*1000 AS Len,'
//                  + '(t1.eastingdiff-t2.eastingdiff)*1000 as ddx,'
//                  + '(t1.northingdiff-t2.northingdiff)*1000 as ddy,'
//                  + '(t1.heightdiff-t2.heightdiff)*1000 as ddh, '
//                  + 'SQRT(SQUARE(t1.eastingdiff-t2.eastingdiff)+SQUARE(t1.northingdiff-t2.northingdiff)+SQUARE(t1.heightdiff-t2.heightdiff))*1000 AS dL '
//                  + 'FROM (' + strFrom1 + ') T1, Results T2 '
//                  + strWhere + strOrder;
//
//        strWhere2 := 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')) '
//                + 'AND (YEAR(T1.Epoch)= ' + IntToStr(theyear)
//                + ') AND (MONTH(T1.Epoch)= ' + IntToStr(TheMonth)
//                + ') AND (DAY(T1.Epoch)= '+ IntToStr(TheDay)
//                + ')';
//        aqryPDatas.SQL.Text := strSQL ;
//
//        aqryDataFilter.SQL.Text := 'SELECT Point_ID, PName, CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE, '
//                + SQL_PTIME + 'FROM Results T1 INNER JOIN (' + SQL_REALNAMEQUERY + ') T2 ON T1.Point_ID=T2.ID '
//                +strWhere2 + ' ORDER BY T1.Epoch, PName, PTime';

        { ====================ʹ����ͼ�Ĵ���====================================================== }
        strIN := GetInStrWithPrecision(StrToFloat(cmbDataTime.Text));
        if chkAverageData.Checked then  //�����ƽ��������
        begin
            strSQL := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, avgNorthing AS X, avgEasting AS Y, avgHeight AS H,'
                    + '       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH, avgLen AS Len,'
                    + '       avgDDNorthing AS ddX, avgDDEasting AS ddY, avgDDHeight AS ddH, avgDLen AS dL '
                    + 'FROM hwview_PointAVGDataWithDayDiff '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND DTScale=''' + FormatDateTime('yyyy-mm-dd', ADate) + ''' '
                    + 'ORDER BY PointName, DTScale';

            strFilterSQL := 'SELECT DISTINCT PointName FROM hwview_PointDatas '
                          + 'ORDER BY PointName';
        end
        else //����
        begin
            strSQL := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, Northing AS X, Easting AS Y, Height AS H,'
                    + '       dNorthing AS dX, dEasting AS dY, dHeight AS dH, Len,'
                    + '       ddNorthing AS ddX, ddEasting AS ddY, ddHeight AS ddH, dLen AS dL '
                    + 'FROM hwview_PointDataWithDayDiff '
                    + 'Where (Point_ID IN (' + strIN + ')) AND DTScale=''' + FormatDateTime('yyyy-mm-dd', ADate) + ''' '
                    + 'ORDER BY PointName, DTScale, PTime';

            strFilterSQL := 'SELECT DISTINCT PointName, PTime FROM hwview_PointDatas '
                          + 'ORDER BY PointName, PTime';
        end;


        aqryPDatas.SQL.Text := strSQL;
        aqryDataFilter.SQL.Text := strFilterSQL;
        { ======================================================================================== }

        try
            aqryPDatas.Open;
            aqryDataFilter.Open;
            SetDBGridToShow;
        except
          on e: Exception do
            ShowMessage(e.Message);
        end;    // try/except
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ShowNewDatas
  Description:  ��ʾ��������
-----------------------------------------------------------------------------}
procedure TfrmTest.ShowNewDatas;
begin
        ShowOneTheDatas(dtpGrd_EndDate.Date);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ShowAllDatas
  Description:  ���ݱ���ʾȫ������
-----------------------------------------------------------------------------}
procedure TfrmTest.ShowAllDatas;
var     qry: TADOQuery;
        strSQL, strWhere,strWhere2, strFrom1, strOrder, strFilterSQL, strIN: String;
        i :Integer;
begin
        dbgDatas.ClearFilter;
        if aqryPDatas.Active then aqryPDatas.Close;
        if aqryDataFilter.Active then aqryDataFilter.Close;

        { ======================= δʹ����ͼ�Ĵ��� =========================== }
        { δʹ����ͼ�Ĵ��������ȷִ�У������ܲ�ѯƽ��ֵ }
//        strFrom1 := 'SELECT Point_ID, B.[Name], A.Epoch, Easting, Northing, Height, '
//                  + 'EastingDiff, NorthingDiff, HeightDiff '
//                  + 'FROM Results A INNER JOIN Points B ON Point_ID=B.ID '
//                  + 'WHERE Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')';
//
//        strWhere := ' WHERE (T2.Point_ID=T1.Point_ID) AND (DATEDIFF(d,T2.Epoch,T1.Epoch)=1) AND (DATEPART(hh,T2.Epoch)=DATEPART(HH,T1.EPoch))';
//        strOrder := ' ORDER BY PDate,PName,PTime';
//        strSQL   := 'SELECT T1.Point_ID,'
//                  + 'LEFT(T1.[name],PATINDEX (''%[_]%'' , T1.[Name])-1) as PName,'
//                  + 'CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE,'
//                  + SQL_PTIME + ','
//                  + 'T1.Easting AS X,'
//                  + 'T1.Northing AS Y,'
//                  + 'T1.Height AS H,'
//                  + 'T1.EastingDiff *1000 as dX,'
//                  + 'T1.NorthingDiff *1000 AS dY,'
//                  + 'T1.HeightDiff *1000 AS dH,'
//                  + 'SQRT(SQUARE(T1.EastingDiff)+SQUARE(T1.NorthingDiff)+SQUARE(T1.HeightDiff))*1000 AS Len,'
//                  + '(t1.eastingdiff-t2.eastingdiff)*1000 as ddx,'
//                  + '(t1.northingdiff-t2.northingdiff)*1000 as ddy,'
//                  + '(t1.heightdiff-t2.heightdiff)*1000 as ddh,'
//                  + 'SQRT(SQUARE(t1.eastingdiff-t2.eastingdiff)+SQUARE(t1.northingdiff-t2.northingdiff)+SQUARE(t1.heightdiff-t2.heightdiff))*1000 AS dL '
//                  + 'FROM (' + strFrom1 + ') T1, Results T2 '
//                  + strWhere + strOrder;
//
//        strWhere2 := 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')) ';
//
//        //aqryPDatas.SQL.Text := strSQL + strWhere + ' ORDER BY T1.Epoch, PName, PTime';
//        aqryPDatas.SQL.Text := strSQL;
//        aqryDataFilter.SQL.Text := 'SELECT Point_ID, PName, CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE, '
//                + SQL_PTIME + 'FROM Results T1 INNER JOIN (' + SQL_REALNAMEQUERY + ') T2 ON T1.Point_ID=T2.ID '
//                + strWhere2 + ' ORDER BY T1.Epoch, PName, PTime';

        { ======================= ʹ����ͼ�Ĵ��� ======================== }
        strIN := GetInStrWithPrecision(StrToFloat(cmbDataTime.Text));
        if chkAverageData.Checked then  //�����ƽ��������
        begin
            strSQL := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, avgNorthing AS X, avgEasting AS Y, avgHeight AS H,'
                    + '       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH, avgLen AS Len,'
                    + '       avgDDNorthing AS ddX, avgDDEasting AS ddY, avgDDHeight AS ddH, avgDLen AS dL '
                    + 'FROM hwview_PointAVGDataWithDayDiff '
                    + 'WHERE Point_ID IN (' + strIN + ') '
                    + 'ORDER BY PointName, DTScale';

            strFilterSQL := 'SELECT PointName, DTScale AS PDate FROM hwview_PointDatas '
                          + 'WHERE Point_ID IN (' + strIN + ') ORDER BY PointName, DTScale';
        end
        else //����
        begin
            strSQL := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, Northing AS X, Easting AS Y, Height AS H,'
                    + '       dNorthing AS dX, dEasting AS dY, dHeight AS dH, Len,'
                    + '       ddNorthing AS ddX, ddEasting AS ddY, ddHeight AS ddH, dLen AS dL '
                    + 'FROM hwview_PointDataWithDayDiff '
                    + 'Where Point_ID IN (' + strIN + ') '
                    + 'ORDER BY PointName, DTScale';

            strFilterSQL := 'SELECT PointName, DTScale AS PDate, PTime FROM hwview_PointDatas '
                          + 'WHERE Point_ID IN (' + strIN + ') ORDER BY PointName, DTScale, PTime';
        end;


        aqryPDatas.SQL.Text := strSQL;
        aqryDataFilter.SQL.Text := strFilterSQL;
        { =============================================================== }

        try
            aqryPDatas.Open;
            aqryDatafilter.Open;
            aqryPDatas.Filtered := True;
            SetDBGridToShow;
        except
          on e: Exception do
            ShowMessage(e.Message);
        end;    // try/exceptend;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ShowSomeDatas
  Description:  ��ʾָ����������֮�������
-----------------------------------------------------------------------------}
procedure TfrmTest.ShowSomeDatas(ADate1,ADate2: TDate);
var     
        strSQL, strWhere,strWhere2, strFrom1, strOrder: String;
        strIN, strDate1, strDate2, strFilterSQL: String;
        theYear, theMonth, theDay: Integer;
        i :Integer;
begin
        dbgDatas.ClearFilter;

        if aqryPDatas.Active then aqryPDatas.Close;
        if aqryDataFilter.Active then aqryDataFilter.Close;

        { ======================= δʹ����ͼ�Ĵ��� =============================================== }
        { δʹ����ͼ�Ĵ��������ȷִ�У������ܲ�ѯƽ��ֵ }
//        theYear := Yearof(ADate2); theMonth := monthof(adate2); theday := dayof(adate2);
//        { �ڵ�һ���Ӳ�ѯ��Ȧ�����ݷ�Χ }
//        strFrom1 := 'SELECT Point_ID, B.[Name], A.Epoch, Easting, Northing, Height, '
//                  + 'EastingDiff, NorthingDiff, HeightDiff '
//                  + 'FROM Results A INNER JOIN Points B ON Point_ID=B.ID '
//                  + 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + '))'
//                  + 'AND (A.Epoch >=''' + FormatDateTime('yyyy-mm-dd', ADate1) + ''') '
//                  + 'AND (A.Epoch <=''' + FormatDateTime('yyyy-mm-dd', IncDay(ADate2,1)) +''')';
//
//        strWhere := ' WHERE (T2.Point_ID=T1.Point_ID) '
//                  + 'AND (DATEDIFF(d,T2.Epoch,T1.Epoch)=1) '
//                  + 'AND (DATEPART(hh,T2.Epoch)=DATEPART(HH,T1.EPoch))';
//
//        strOrder := ' ORDER BY PDate,PName,PTime';
//        strSQL   := 'SELECT T1.Point_ID,'
//                  + 'LEFT(T1.[name],PATINDEX (''%[_]%'' , T1.[Name])-1) as PName,'
//                  + 'CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE,'
//                  + SQL_PTIME + ','
//                  + 'T1.Easting AS X,'
//                  + 'T1.Northing AS Y,'
//                  + 'T1.Height AS H,'
//                  + 'T1.EastingDiff *1000 as dX,'
//                  + 'T1.NorthingDiff *1000 AS dY,'
//                  + 'T1.HeightDiff*1000 AS dH,'
//                  + 'SQRT(SQUARE(T1.EastingDiff)+SQUARE(T1.NorthingDiff)+SQUARE(T1.HeightDiff))*1000 AS Len,'
//                  + '(t1.eastingdiff-t2.eastingdiff)*1000 as ddx,'
//                  + '(t1.northingdiff-t2.northingdiff)*1000 as ddy,'
//                  + '(t1.heightdiff-t2.heightdiff)*1000 as ddh, '
//                  + 'SQRT(SQUARE(t1.eastingdiff-t2.eastingdiff)+SQUARE(t1.northingdiff-t2.northingdiff)+SQUARE(t1.heightdiff-t2.heightdiff))*1000 AS dL '
//                  + 'FROM (' + strFrom1 + ') T1, Results T2 '
//                  + strWhere + strOrder;
//
////        strSQL := 'SELECT Point_ID, PName, DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH) AS PDATE, '
////                + SQL_PTIME
////                + ',Easting AS X, Northing as Y, Height AS H,'
////                + 'EastingDiff AS dX, NorthingDiff AS dY, HeightDiff AS dH '
////                + 'FROM Results T1 INNER JOIN (' + SQL_REALNAMEQUERY + ') T2 ON T1.Point_ID=T2.ID ';
//        strWhere2 := 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')) '
//                + 'AND (YEAR(T1.Epoch)= ' + IntToStr(theyear)
//                + ') AND (MONTH(T1.Epoch)= ' + IntToStr(TheMonth)
//                + ') AND (DAY(T1.Epoch)= '+ IntToStr(TheDay)
//                + ')';
//        aqryPDatas.SQL.Text := strSQL ;
//
//        aqryDataFilter.SQL.Text := 'SELECT Point_ID, PName,CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE, '
//                + SQL_PTIME + 'FROM Results T1 INNER JOIN (' + SQL_REALNAMEQUERY + ') T2 ON T1.Point_ID=T2.ID '
//                +strWhere2 + ' ORDER BY T1.Epoch, PName, PTime';

        { ==================== ʹ����ͼ�Ĵ��� ==================================================== }
        strIN := GetInStrWithPrecision(StrToFloat(cmbDataTime.Text));
        strDate1 := FormatDateTime('yyyy-mm-dd', ADate1);
        strDate2 := FormatDateTime('yyyy-mm-dd', ADate2);
        if chkAverageData.Checked then  //�����ƽ��������
        begin
            strSQL := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, avgNorthing AS X, avgEasting AS Y, avgHeight AS H,'
                    + '       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH, avgLen AS Len,'
                    + '       avgDDNorthing AS ddX, avgDDEasting AS ddY, avgDDHeight AS ddH, avgDLen AS dL '
                    + 'FROM hwview_PointAVGDataWithDayDiff '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') '
                    + 'ORDER BY PointName, DTScale';

            strFilterSQL := 'SELECT DISTINCT PointName, DTScale AS PDate FROM hwview_PointDatas '
                          + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') '
                          + 'ORDER BY PointName, DTScale';
        end
        else //����
        begin
            strSQL := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, Northing AS X, Easting AS Y, Height AS H,'
                    + '       dNorthing AS dX, dEasting AS dY, dHeight AS dH, Len,'
                    + '       ddNorthing AS ddX, ddEasting AS ddY, ddHeight AS ddH, dLen AS dL '
                    + 'FROM hwview_PointDataWithDayDiff '
                    + 'Where (Point_ID IN (' + strIN + ')) AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') '
                    + 'ORDER BY PointName, DTScale';

            strFilterSQL := 'SELECT PointName, DTScale AS PDate, PTime FROM hwview_PointDatas '
                          + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale BETWEEN ''' + strDate1 + ''' AND ''' + strDate2 + ''') '
                          + 'ORDER BY PointName, DTScale, PTime';
        end;


        aqryPDatas.SQL.Text := strSQL;
        aqryDataFilter.SQL.Text := strFilterSQL;
        { ======================================================================================== }

        try
            aqryPDatas.Open;
            aqryDataFilter.Open;
            SetDBGridToShow;
        except
          on e: Exception do
            ShowMessage(e.Message);
        end;    // try/except
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.ShowAnyTwoDayData
  Description:  ��ʾ�����������ݣ��Լ���仯��ֵ  
-----------------------------------------------------------------------------}
procedure TfrmTest.ShowAnyTwoDayData(ADate1, ADate2: TDate);
var     qry: TADOQuery;
        strSQL, strWhere,strWhere2, strFrom1, strFrom2, strOrder: String;
        strIN, strFilterSQL, strDate1, strDate2: String;
        theYear1, theMonth1, theDay1,
        theYear2, theMonth2, theDay2: Integer;
        i :Integer;
begin
        dbgDatas.ClearFilter;

        if aqryPDatas.Active then aqryPDatas.Close;
        if aqryDataFilter.Active then aqryDataFilter.Close;

        { ======================= δʹ����ͼ�Ĵ��� =============================================== }
        { δʹ����ͼ�Ĵ��������ȷִ�У������ܲ�ѯƽ��ֵ }
//        theYear1 := Yearof(ADate1); theMonth1 := MonthOf(ADate1); theDay1 := DayOf(ADate1);
//        theYear2 := Yearof(ADate2); theMonth2 := monthof(adate2); theday2 := dayof(adate2);
//        { �ڵ�һ���Ӳ�ѯ��ȷ�����ݵ��������ڵļ�¼ }
//        strFrom1 := 'SELECT Point_ID, B.[Name], A.Epoch, Easting, Northing, Height, '
//                  + 'EastingDiff, NorthingDiff, HeightDiff '
//                  + 'FROM Results A INNER JOIN Points B ON Point_ID=B.ID '
//                  + 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')) '
//                  + 'AND ('
//                  + '((YEAR(A.Epoch)= ' + IntToStr(theyear1) + ') AND (MONTH(A.Epoch)= ' + IntToStr(TheMonth1) + ') AND (DAY(A.Epoch)= '+ IntToStr(TheDay1) + ')) '
//                  + 'OR ((YEAR(A.Epoch)= ' + IntToStr(theyear2) + ') AND (MONTH(A.Epoch)= ' + IntToStr(TheMonth2) + ') AND (DAY(A.Epoch)= '+ IntToStr(TheDay2) + ')) '
//                  + ')';
//
//        strFrom2 := 'SELECT Point_ID, Epoch, Easting, Northing, Height, '
//                  + 'EastingDiff, NorthingDiff, HeightDiff '
//                  + 'FROM Results '
//                  + 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')) '
//                  + 'AND ('
//                  + '(YEAR(Epoch)= ' + IntToStr(theyear1) + ') AND (MONTH(Epoch)= ' + IntToStr(TheMonth1) + ') AND (DAY(Epoch)= '+ IntToStr(TheDay1) + ')'
//                  + ')';
//
//        strWhere := ' WHERE (T2.Point_ID=T1.Point_ID) '
//                  {+ 'AND (DATEDIFF(d,T2.Epoch,T1.Epoch)=1) '}
//                  + 'AND (DATEPART(hh,T2.Epoch)=DATEPART(HH,T1.EPoch))';
//
//        strOrder := ' ORDER BY PDate,PName,PTime';
//        strSQL   := 'SELECT T1.Point_ID,'
//                  + 'LEFT(T1.[name],PATINDEX (''%[_]%'' , T1.[Name])-1) as PName,'
//                  + 'CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE,'
//                  + SQL_PTIME + ','
//                  + 'T1.Easting AS X,'
//                  + 'T1.Northing AS Y,'
//                  + 'T1.Height AS H,'
//                  + 'T1.EastingDiff *1000 as dX,'
//                  + 'T1.NorthingDiff *1000 AS dY,'
//                  + 'T1.HeightDiff*1000 AS dH,'
//                  + 'SQRT(SQUARE(T1.EastingDiff)+SQUARE(T1.NorthingDiff)+SQUARE(T1.HeightDiff))*1000 AS Len,'
//                  + '(t1.eastingdiff-t2.eastingdiff)*1000 as ddx,'
//                  + '(t1.northingdiff-t2.northingdiff)*1000 as ddy,'
//                  + '(t1.heightdiff-t2.heightdiff)*1000 as ddh, '
//                  + 'SQRT(SQUARE(t1.eastingdiff-t2.eastingdiff)+SQUARE(t1.northingdiff-t2.northingdiff)+SQUARE(t1.heightdiff-t2.heightdiff))*1000 AS dL '
//                  + 'FROM (' + strFrom1 + ') T1, ('+ strFrom2 + ') T2 '
//                  + strWhere + strOrder;
//
////        strSQL := 'SELECT Point_ID, PName, DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH) AS PDATE, '
////                + SQL_PTIME
////                + ',Easting AS X, Northing as Y, Height AS H,'
////                + 'EastingDiff AS dX, NorthingDiff AS dY, HeightDiff AS dH '
////                + 'FROM Results T1 INNER JOIN (' + SQL_REALNAMEQUERY + ') T2 ON T1.Point_ID=T2.ID ';
//        strWhere2 := 'WHERE (Point_ID IN (' + GetInStrWithPrecision(StrToFloat(cmbDataTime.Text)) + ')) '
//                  + 'AND ('
//                  + '((YEAR(T1.Epoch)= ' + IntToStr(theyear1) + ') AND (MONTH(T1.Epoch)= ' + IntToStr(TheMonth1) + ') AND (DAY(T1.Epoch)= '+ IntToStr(TheDay1) + ')) '
//                  + 'OR ((YEAR(T1.Epoch)= ' + IntToStr(theyear2) + ') AND (MONTH(T1.Epoch)= ' + IntToStr(TheMonth2) + ') AND (DAY(T1.Epoch)= '+ IntToStr(TheDay2) + ')) '
//                  + ')';
//        aqryPDatas.SQL.Text := strSQL ;
//
//        aqryDataFilter.SQL.Text := 'SELECT Point_ID, PName, CAST((DATENAME(YYYY,T1.EPOCH)+''-''+DATENAME(MM,T1.EPOCH)+''-''+DATENAME(DD,T1.EPOCH)) AS SMALLDATETIME) AS PDATE, '
//                + SQL_PTIME + 'FROM Results T1 INNER JOIN (' + SQL_REALNAMEQUERY + ') T2 ON T1.Point_ID=T2.ID '
//                +strWhere2 + ' ORDER BY T1.Epoch, PName, PTime';

        { ======================== ʹ����ͼ�Ĵ��� ================================================ }
        strIN := GetInStrWithPrecision(StrToFloat(cmbDataTime.Text));
        strDate1 := FormatDateTime('yyyy-mm-dd', ADate1);
        strDate2 := FormatDateTime('yyyy-mm-dd', ADate2);
        if chkAverageData.Checked then  //�����ƽ��������
        begin
            //��һ���Ӳ�ѯ�������죺
            strFrom1 := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, avgNorthing AS X, avgEasting AS Y, avgHeight AS H,'
                    + '       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH, avgLen AS Len '
                    + 'FROM hwview_PointAVGDatas '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale IN (''' + strDate1 + ''' , ''' + strDate2 + ''')) ';

            //�ڶ�����ѯ��������һ�죺
            strFrom2 := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, avgNorthing AS X, avgEasting AS Y, avgHeight AS H,'
                    + '       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH, avgLen AS Len '
                    + 'FROM hwview_PointAVGDatas '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale =''' + strDate1 + ''') ';

            strSQL := 'SELECT A.Point_ID, A.PointName, A.PDate, A.PTime, A.X, A.Y, A.H, A.dX, A.dY, A.dH, A.Len,'
                    + '     (A.dX-B.dX) AS ddx, (A.dY-B.dy) AS ddY, (A.dH-B.dH) AS ddH, (A.Len-B.Len) AS dL '
                    + 'FROM (' + strFrom1 + ') A, (' + strFrom2 + ') B '
                    + 'WHERE (A.Point_ID=B.Point_ID) '
                    + 'ORDER BY A.PointName, A.PDate';

            strFilterSQL := 'SELECT DISTINCT PointName, DTScale AS PDate FROM hwview_PointDatas '
                          + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale IN (''' + strDate1 + ''' , ''' + strDate2 + ''')) '
                          + 'ORDER BY PointName, DTScale';
        end
        else //����
        begin
            //��һ���Ӳ�ѯ�������죺
            strFrom1 := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, Northing AS X, Easting AS Y, Height AS H,'
                    + '       DNorthing AS dX, DEasting AS dY, DHeight AS dH, Len AS Len '
                    + 'FROM hwview_PointDatas '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale IN (''' + strDate1 + ''' , ''' + strDate2 + ''')) ';

            //�ڶ�����ѯ��������һ�죺
            strFrom2 := 'SELECT Point_ID, PointName, DTScale AS PDate, PTime, Northing AS X, Easting AS Y, Height AS H,'
                    + '       DNorthing AS dX, DEasting AS dY, DHeight AS dH, Len AS Len '
                    + 'FROM hwview_PointDatas '
                    + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale =''' + strDate1 + ''') ';

            strSQL := 'SELECT A.Point_ID, A.PointName, A.PDate, A.PTime, A.X, A.Y, A.H, A.dX, A.dY, A.dH, A.Len,'
                    + '     (A.dX-B.dX) AS ddx, (A.dY-B.dy) AS ddY, (A.dH-B.dH) AS ddH, (A.Len-B.Len) AS dL '
                    + 'FROM (' + strFrom1 + ') A, (' + strFrom2 + ') B '
                    + 'WHERE (A.Point_ID=B.Point_ID) AND (A.PTime=B.PTime)'
                    + 'ORDER BY A.PointName, A.PDate, A.PTime';

            strFilterSQL := 'SELECT PointName, DTScale AS PDate, PTime FROM hwview_PointDatas '
                          + 'WHERE (Point_ID IN (' + strIN + ')) AND (DTScale IN (''' + strDate1 + ''' , ''' + strDate2 + ''')) '
                          + 'ORDER BY PointName, DTScale, PTime';
        end;


        aqryPDatas.SQL.Text := strSQL;
        aqryDataFilter.SQL.Text := strFilterSQL;
        { ======================================================================================== }

        try
            aqryPDatas.Open;
            aqryDataFilter.Open;
            SetDBGridToShow;
        except
          on e: Exception do
            ShowMessage(e.Message);
        end;    // try/except

end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.Button1Click
  Description:  
-----------------------------------------------------------------------------}
procedure TfrmTest.Button1Click(Sender: TObject);
begin
        if cmbDataTime.ItemIndex = -1 then Exit;
        if optNewData.Checked then
            ShowNewDatas
        else if optAllData.Checked then
            ShowAllDatas
        else if optSomeData.Checked then
            ShowSomeDatas(dtpGrd_BeginDate.Date, dtpGrd_EndDate.Date)
        else if optAnyTwoDayData.Checked then
            ShowAnyTwoDayData(dtpGrd_FirstDate.Date, dtpGrd_SecondDate.Date);
end;

procedure TfrmTest.btnExpertDataClick(Sender: TObject);
var
        frm: TfrmExpertDataFromGrid;
begin
        frm := TfrmExpertDataFromGrid.Create(Self);
        frm.ShowModal;
        FreeAndNil(frm);
end;

procedure TfrmTest.btnPrintDataClick(Sender: TObject);
begin
        prnDBGrid.PrinterSetupDialog;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.DrawLocus
  Description:  ����X-Yƽ��켣ͼ 
-----------------------------------------------------------------------------}
procedure TfrmTest.DrawLocus;
var
        qry: TADOQuery;
        pntName, pntTitle: String;
begin
        { ���ƹ켣ͼ }
        //��ʱ������ĳ��ȫ������
        if (tvwPoints.Selected = nil) or (tvwPoints.Selected.Parent.Text <> '����') then
        begin
            Exit;
        end;

        pntName := tvwPoints.Selected.Text;
        pntTitle := pntName + 'ƽ��(X-Y)���ι켣ͼ';

        qry := TADOQuery.Create(Self);
        try
            qry.Connection := Self.ADOConnection1;
            //qry.SQL.Text := QueryCode_OnePointData(pntName, strToInt(cmbDataTime.Text),dtpLocusStartDate.Date, dtpLocusEndDate.Date);
            { ---------ʹ����ͼ-------------- }
            if chkAverageData.Checked then
            begin
                qry.SQL.Text := 'SELECT PointName, DTScale, PTime, avgNorthing AS X, avgEasting AS Y, avgHeight AS H,'
                              + '       avgDNorthing AS dX, avgDEasting AS dY, avgDHeight AS dH '
                              + 'FROM hwview_PointAVGDatas '
                              + 'WHERE (Point_ID =' + IntToStr(GetPointIDByPrecision(pntName, strToInt(cmbDataTime.Text))) + ') '
                              + '       AND (DTScale BETWEEN ''' + DateToStr(dtpLocusStartDate.Date) + ''' AND ''' + DateToStr(dtpLocusEndDate.Date) + ''') '
                              + 'ORDER BY DTScale, PTime';
            end
            else
            begin
                qry.SQL.Text := 'SELECT PointName, DTScale, PTime, Northing AS X, Easting AS Y, Height AS H,'
                              + '       DNorthing AS dX, DEasting AS dY, DHeight AS dH '
                              + 'FROM hwview_PointDatas '
                              + 'WHERE (Point_ID =' + IntToStr(GetPointIDByPrecision(pntName, strToInt(cmbDataTime.Text))) + ') '
                              + '       AND (DTScale BETWEEN ''' + DateToStr(dtpLocusStartDate.Date) + ''' AND ''' + DateToStr(dtpLocusEndDate.Date) + ''') '
                              + 'ORDER BY DTScale, PTime';
            end;

            qry.Open;

            if (cmbDataTime.Text <> '24') and (NOT chkSP_AllTimeInGraph.Checked) and (NOT chkAverageData.Checked) then
            begin
                qry.Filter := 'PTIME = ' + cmbSP_TimeList.Text;
                qry.Filtered := True;
            end;

            if chkGradient.Checked then
                fraLocusMap1.UseOneColor := False
            else
                fraLocusMap1.UseOneColor := True;
              
            if chkLocusAutoAxis.Checked then
                fraLocusMap1.AutoAxis := True
            else
                fraLocusMap1.AutoAxis := False;

            if qry.RecordCount = 0 then
                MessageDlg('����'+pntName+'û�����ݣ�', mtError, [mbOK], 0)
            else
                fraLocusMap1.ShowXYLocus(pntName, pntTitle, qry);
        finally
            FreeAndNil(qry);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.btnDrawLocusClick
  Description:  ���ƹ켣ͼ
-----------------------------------------------------------------------------}
procedure TfrmTest.btnDrawLocusClick(Sender: TObject);
begin
        fraLocusMap1.DynamicShow := False;
        DrawLocus;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfrmTest.btnDynamicLocusClick
  Description:  ���ƶ�̬�켣ͼ  
-----------------------------------------------------------------------------}
procedure TfrmTest.btnDynamicLocusClick(Sender: TObject);
begin
        fraLocusMap1.DynamicShow := True;
        DrawLocus;
end;

procedure TfrmTest.fraLocusMap1chtLocusClick(Sender: TObject);
begin
        Self.ActiveControl := fraLocusMap1.chtLocus;
end;

procedure TfrmTest.fraTrendLinechtPointXClick(Sender: TObject);
begin
        Self.ActiveControl := fraTrendLine.chtPointX;
end;

procedure TfrmTest.fraTrendLinechtPointYClick(Sender: TObject);
begin
        Self.ActiveControl := fraTrendLine.chtPointY;
end;

procedure TfrmTest.fraTrendLinechtPointHClick(Sender: TObject);
begin
        Self.ActiveControl := fraTrendLine.chtPointH;
end;

procedure TfrmTest.LoadParamsFromDB;
var
        qrypdt, qryPointName: TADOQuery;
        str1, str2, str3: String;
begin
        qryPointName    := TADOQuery.Create(Self);
        qrypdt          := TADOQuery.Create(Self);

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
            qrypdt.Free;
        end;
end;

procedure TfrmTest.SaveParams;
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
        cmbDataTime.Clear;
        //cmbSP_TimeList.Clear;

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
  Procedure:    TfrmTest.ADOConnection1BeforeDisconnect
  Description:  �ر���������֮ǰ��Ҫ��ɵĹ���
-----------------------------------------------------------------------------}
procedure TfrmTest.ADOConnection1BeforeDisconnect(Sender: TObject);
begin
        //�ر���������֮ǰ��ɾ����Щ��ʱ��������ͼ
//        aqryDropPDV.ExecSQL;
//        aqryDropPDAV.ExecSQL;
//        aqryDropPDVDayDiff.ExecSQL;
//        aqryDropPDAVDayDiff.ExecSQL;
end;

end.
