{-----------------------------------------------------------------------------
 Unit Name: ufraGPSTrendLine
 Author:    黄伟
 Date:      25-四月-2010
 Purpose:   本单元针对Leica数据库结构……喔，还没有决定是否直接从数据集中取值。
            对于用户增加的Series，用名称进行识别
 History:
-----------------------------------------------------------------------------}
{ TODO -o黄伟 -c历时过程线 : 允许用户对每条线进行设置，粗细、颜色、点形状、标签等。 }
{ TODO -o黄伟 -c历时过程线 : 改进图形缩放功能，改进用户拖动坐标轴进行缩放的功能 }
{ TODO -o黄伟 -c历时过程线 : 增加回归线（线型、二次） }
{ TODO -o黄伟 -c历时过程线 : 增加总变形量过程线、日变形量过程线 }
{ TODO -o黄伟 -c历时过程线 : 增加打印功能，用户可选择打印哪些图形、在纸张上如何布局 }
{ TODO -o黄伟 -c历时过程线 : 允许用户修改图的标题、线的名称，修改字体和颜色等。 }
{ TODO -o黄伟 -c历时过程线 : 对dX、dY图，允许设置缺省Y轴绘图上下限 }

unit ufraGPSTrendLine;
                     
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, TeEngine, Series, TeeProcs, Chart, adodb, DateUtils,
  Menus, StdCtrls, ComCtrls;

type
  ///<summary>
  ///过程线绘制单元，用于绘制各个测点的历时过程线。
  ///</summary>
  TfraGPSTrendLine = class(TFrame)
    chtPointX: TChart;
    srsX: TLineSeries;
    Splitter4: TSplitter;
    chtPointY: TChart;
    srsY: TLineSeries;
    Splitter5: TSplitter;
    chtPointH: TChart;
    srsH: TLineSeries;
    popMethod: TPopupMenu;
    miEqualDivisionArea: TMenuItem;
    Panel1: TPanel;
    N1: TMenuItem;
    miCopyBitmap: TMenuItem;
    miCopyMetaFile: TMenuItem;
    dtpTL_BeginDate: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    dtpTL_EndDate: TDateTimePicker;
    chkShowDataPoint: TCheckBox;
    chkShowDataMark: TCheckBox;
    procedure miEqualDivisionAreaClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure miCopyBitmapClick(Sender: TObject);
    procedure miCopyMetaFileClick(Sender: TObject);
    procedure chtPointXContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure chtPointYContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure chtPointHContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure chkShowDataPointClick(Sender: TObject);
    procedure chkShowDataMarkClick(Sender: TObject);
    procedure chtPointXMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure chtPointXMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtPointXMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chtPointYMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtPointYMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chtPointHMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtPointHMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chtPointYMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure chtPointHMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FPopupChart: TChart;
    FX, FY: Integer;
    function GetSeries(AName: String; ACht: TChart): TLineSeries;
    function GetSeriesH(AName: String): TLineSeries;
    function GetSeriesX(AName: String): TLineSeries;
    function GetSeriesY(AName: String): TLineSeries;
    procedure ShowDataPoint(AShow: Boolean);
    procedure ShowDataMark(AShow: Boolean);
  public
    { Public declarations }
    procedure ClearDatas(ClearSeries: Boolean = False);
    procedure AddPoint(AName, ATitle: String);
    procedure AddPointData(AName: String; dx,dy,dz:Double);
    procedure RoundAxis(AChart: TChart);
    { 创建新趋势线，并直接从数据源中取数据，填写到图形中 }
    procedure DrawNewLine(AChartTitle, AName: String; ADS: TADOQuery; AFactor: Single = 1);
    { 绘制断面过程线 }
    procedure DrawProfileLine(AProfileName: String; ADataSet, APointSet: TADOQuery);
    { 返回名为AName的LineSeries对象 }
    property LineH[AName: String]: TLineSeries read GetSeriesH;
    property LineX[AName: String]: TLineSeries read GetSeriesX;
    property LineY[AName: String]: TLineSeries read GetSeriesY;
  end;

const
    MyLineColor : array[0..10] of TColor =
                    (clRed,     clGreen,    clBlue,     clFuchsia,  clAqua,
                     clMaroon,  clGreen,    clOlive,    clNavy,     clPurple,   clTeal);
implementation

{$R *.dfm}

function Between(X,A,B: Double): Boolean;
begin
    if (X>=A) and (X <=B) then
        Result := True
    else
        Result := False;
end;

{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.ClearDatas
  Description:  清除所有数据，及测点  
-----------------------------------------------------------------------------}
procedure TfraGPSTrendLine.ClearDatas(ClearSeries: Boolean = False);
        procedure ClearChartDatas(cht: TChart);
        var i,j: Integer;
            S: TChartSeries;
        begin
            for i := 0 to cht.SeriesCount -1 do cht.Series[i].Clear;
            if ClearSeries and (cht.SeriesCount > 0) then { 保留设计时定义的那个LineSeries对象 }
                for i := cht.SeriesCount -1 downto 0 do
                begin
                    s := cht.Series[i];
                    cht.RemoveSeries(cht.Series[i]);
                    FreeAndNil(s);
                end;
        end;
begin
        ClearChartDatas(chtPointH);
        ClearChartDatas(chtPointX);
        ClearChartDatas(chtPointY);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.AddPoint
  Description:  增加一个测点  
-----------------------------------------------------------------------------}
procedure TfraGPSTrendLine.AddPoint(AName, ATitle: String);
        procedure AddPointToCht(AName: String; Cht: TChart);
        var srs: TLineSeries;
        begin
            srs := TLineSeries.Create(Cht);

            srs.ParentChart := Cht;

            if Cht.SeriesCount < 12 then    //MyLineColor:array [0..10] of TColor
                srs.SeriesColor := MyLineColor[Cht.SeriesCount-1];

            srs.XValues.DateTime := True;
            //srs.Assign(Cht.Series[0]);
            srs.Name := AName;

            srs.Active := True;
            srs.Title := ATitle;
            //srs.SeriesColor := cht.GetFreeSeriesColor(True);
            srs.Pointer.HorizSize := 3;
            srs.Pointer.VertSize := 3;
        end;
begin
        AddPointToCht(AName, chtPointH);
        AddPointToCht(AName, chtPointX);
        AddPointToCht(AName, chtPointY);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.AddPointData
  Description:  向测点AName添加数据  
-----------------------------------------------------------------------------}
procedure TfraGPSTrendLine.AddPointData(AName: String; dx,dy,dz: double);
begin
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.GetSeries
  Description:
-----------------------------------------------------------------------------}
function TfraGPSTrendLine.GetSeries(AName: String; ACht: TChart): TLineSeries;
var     i: Integer;
begin
        Result := nil;
        for i := 0 to ACht.SeriesCount -1 do
        begin
            Result := TLineSeries(ACht.Series[i]);
            if Result.Name = AName then Exit;
        end;
        Result := nil;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.GetSeriesH
  Description:
-----------------------------------------------------------------------------}
function TfraGPSTrendLine.GetSeriesH(AName: String): TLineSeries;
begin
        Result := GetSeries(AName, chtPointH);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.GetSeriesX
  Description:
-----------------------------------------------------------------------------}
function TfraGPSTrendLine.GetSeriesX(AName: String): TLineSeries;
begin
        Result := GetSeries(AName, chtPointX);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.GetSeriesY
  Description:
-----------------------------------------------------------------------------}
function TfraGPSTrendLine.GetSeriesY(AName: String): TLineSeries;
begin
        Result := GetSeries(AName, chtPointY);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.RoundAxis
  Description:  
-----------------------------------------------------------------------------}
procedure TfraGPSTrendLine.RoundAxis(AChart: TChart);
var i: Integer;
    sl: TLineSeries;
    MaxValue,MinValue: Double;
begin
    if AChart.SeriesList.Count = 0 then Exit;
    MaxValue := -9999999999;
    MinValue := 9999999999;
    AChart.LeftAxis.Automatic := True;
    for i := 0 to AChart.SeriesCount -1 do
    begin
        sl := TLineSeries(AChart.SeriesList[i]);
        if sl.MaxYValue > MaxValue then MaxValue := sl.MaxYValue;
        if sl.MinYValue < MinValue then MinValue := sl.MinYValue;
    end;

    if (MaxValue <= 1) and (MaxValue >= 0) then
    begin
        AChart.LeftAxis.AutomaticMaximum := False;
        AChart.LeftAxis.Maximum := 1;
    end
    else
        AChart.LeftAxis.AutomaticMaximum := True;

    if (MinValue <= 0) and (MinValue >= -1) then
    begin
        AChart.LeftAxis.AutomaticMinimum := False;
        AChart.LeftAxis.Minimum := -1;
    end
    else
        AChart.LeftAxis.AutomaticMinimum := True;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.DrawNewLine
  Description:  创建一个趋势线(x,y,x各一个)，并从数据集ADS中提取数据
                ADS中的字段应是：Point_ID, PDate, PTime, dX, dY, dH
-----------------------------------------------------------------------------}
procedure TfraGPSTrendLine.DrawNewLine(AChartTitle, AName: String; ADS: TADOQuery; AFactor: Single = 1);
var     lh, lx, ly: TLineSeries;
        ddt: TDateTime;
        dx,dy,dh: Double;
        str: String;
begin
        chtPointH.Title.Text.Text := AChartTitle + '：高程变形过程线';
        chtPointX.Title.Text.Text := AChartTitle + '：X(北)方向变形过程线';
        chtPointY.Title.Text.Text := AChartTitle + '：Y(东)方向变形过程线';

        ads.First;
        if ads.RecordCount > 0 then
        begin
            str := ads.FieldByName('PTime').AsString;
            AddPoint(AName+'_'+Str, AName + '在' + str + ':00数据');
            AName := AName + '_' + Str;
            lh := LineH[AName];
            lx := LineX[AName];
            ly := LineY[AName];

            repeat
                { 数据集中的日期字段中的时间项不是整点，需要进行转换 }
                ddt := RecodeTime(ads.FieldValues['DTScale'], ads.FieldValues['PTime'],0,0,0);
                dx := ads.FieldValues['dx'] * AFactor;
                dy:= ads.FieldValues['dy'] * AFactor;
                dh := ads.FieldValues['dh'] * AFactor;
                lx.AddXY(ddt, dx);
                ly.AddXY(ddt, dy);
                lh.AddXY(ddt, dh);
                ads.Next;
            until ads.Eof;
        end;
        ShowDataPoint(chkShowDataPoint.Checked);
        ShowDataMark(chkShowDataMark.Checked);
        RoundAxis(chtPointH);
        RoundAxis(chtPointX);
        RoundAxis(chtPointY);
end;

procedure TfraGPSTrendLine.miEqualDivisionAreaClick(Sender: TObject);
var     hh: integer;
begin
        hh := (Self.ClientHeight - Splitter4.Height - Splitter5.Height) div 3;
        chtPointX.Height := hh;
        chtPointY.Height := hh;
        chtPointH.Height := hh;
end;

procedure TfraGPSTrendLine.FrameResize(Sender: TObject);
begin
        miEqualDivisionAreaClick(Self);
end;

procedure TfraGPSTrendLine.miCopyBitmapClick(Sender: TObject);
begin
        FPopupChart.CopyToClipboardBitmap;
end;

procedure TfraGPSTrendLine.miCopyMetaFileClick(Sender: TObject);
begin
        FPopupChart.CopyToClipboardMetafile(False);
end;

procedure TfraGPSTrendLine.chtPointXContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
        FPopupChart := chtPointX;
end;

procedure TfraGPSTrendLine.chtPointYContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
        FPopupChart := chtPointY;
end;

procedure TfraGPSTrendLine.chtPointHContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
        FPopupChart := chtPointH;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraGPSTrendLine.DrawProfileLine
  Description:  绘制一个断面历时过程线。ADataSet包含了断面所有监测点的数据，并
                已经按照数据打包时刻过滤；APointSet包含了断面的点列表
-----------------------------------------------------------------------------}
procedure TfraGPSTrendLine.DrawProfileLine(AProfileName: String; ADataSet, APointSet: TADOQuery);
var     iPoint: Integer;
        oriFilter, Pname: String;
        ddt: TDate;
        dx, dy, dh: Double;
        lx,ly,lh: TLineSeries;
begin
        ClearDatas(True);
        chtPointH.Title.Text.Text := AProfileName + '：各监测点高程变形过程线';
        chtPointX.Title.Text.Text := AProfileName + '：各监测点X方向变形过程线';
        chtPointY.Title.Text.Text := AProfileName + '：各监测点Y方向变形过程线';
        { ------------------------------------------- }
        oriFilter := ADataSet.Filter;   //取出原过滤字符串，以待后用
        APointSet.First;
        repeat
            { 逐点进行过滤，并绘图 }
            pname := APointSet.FieldValues['PName'];
            ADataSet.Filtered := False;
            ADataSet.Filter := 'PName=''' + PName + ''''; //oriFilter + ' AND (PName=''' + pname + ''')';
            ADataSet.Filtered := True;
            if ADataSet.RecordCount > 0 then
            begin
                { -------------------------------------------------------- }
                //向Chart中增加点
                AddPoint(pName,PName);
                lh := LineH[pName]; lx := LineX[PName]; ly := LineY[PName];
                //填写数据
                ADataSet.First;
                repeat
                    ddt := ReCodeTime(ADataSet.FieldValues['DTScale'], ADataSet.FieldValues['PTime'],0,0,0);
                    dx := ADataSet.FieldValues['dx'];
                    dy := ADataSet.FieldValues['dy'];
                    dh := ADataSet.FieldValues['dh'];
                    lx.AddXY(ddt,dx);
                    ly.AddXY(ddt,dy);
                    lh.AddXY(ddt,dh);
                    ADataSet.Next;
                until ADataSet.Eof;
            end;
            { -------------------------------------------------------- }
            APointSet.Next;
        until APointSet.Eof;
        ShowDataPoint(chkShowDataPoint.Checked);
        ShowDataMark(chkShowDataMark.Checked);
        RoundAxis(chtPointH);
        RoundAxis(chtPointX);
        RoundAxis(chtPointY);
end;

procedure TfraGPSTrendLine.ShowDataPoint(AShow: Boolean);
        procedure SeriesDataPoint(Cht: TChart);
        var i: Integer;
        begin
            for i := 0 to Cht.SeriesCount -1 do
            begin
                TLineSeries(Cht.Series[i]).Pointer.Visible := AShow;
            end;
        end;
begin
        SeriesDataPoint(chtPointH);
        SeriesDataPoint(chtPointX);
        SeriesDataPoint(chtPointY);
end;

procedure TfraGPSTrendLine.ShowDataMark(AShow: Boolean);
        procedure SeriesDataMark(Cht: TChart);
        var i: Integer;
        begin
            for i := 0 to Cht.SeriesCount -1 do
            begin
                TLineSeries(Cht.Series[i]).Marks.Visible := AShow;
            end;
        end;
begin
        SeriesDataMark(chtPointH);
        SeriesDataMark(chtPointX);
        SeriesDataMark(chtPointY);
end;

procedure TfraGPSTrendLine.chkShowDataPointClick(Sender: TObject);
begin
        ShowDataPoint(chkShowDataPoint.Checked);
end;

procedure TfraGPSTrendLine.chkShowDataMarkClick(Sender: TObject);
begin
        ShowDataMark(chkShowDataMark.Checked);
end;

procedure TfraGPSTrendLine.chtPointXMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
        chtMousePos: TPoint;
        Delta: Integer;
        gRect: TRect;
begin
        Handled := True;
        grect := chtPointX.ChartRect;
        chtMousePos := chtPointX.GetCursorPos;
        { Y轴区域 }
        if (chtMousePos.X < gRect.Left) and (Between(chtMousePos.Y, gRect.Top,gRect.Bottom) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtPointX.ZoomRect(Rect(grect.Left,grect.Top +Delta,grect.Right,grect.Bottom-Delta));
        end;
        { X轴区域 }
        if (chtMousePos.Y > gRect.Bottom) and (Between(chtMousePos.X, gRect.Left,gRect.Right) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtPointX.ZoomRect(Rect(grect.Left+Delta,grect.Top,grect.Right-Delta,grect.Bottom));
        end;

        if Between(chtMousePos.X, grect.Left, grect.Right)
            and Between(chtMousePos.Y, grect.Top,grect.Bottom) then
            if WheelDelta >0 then
                chtPointX.ZoomPercent(105)
            else
                chtPointX.ZoomPercent(95);
end;

procedure TfraGPSTrendLine.chtPointXMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
        FX := X; FY := Y;
end;

procedure TfraGPSTrendLine.chtPointXMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var     clickPart: TChartClickedPart;
        zRect,cRect: TRect;
begin
        if not (ssLeft in Shift) then Exit;
        chtPointX.CalcClickedPart(Point(X,Y), clickPart);
        if clickPart.Part <> cpAxis then Exit;
        cRect := chtPointX.ChartRect;
        if clickPart.AAxis = chtPointX.LeftAxis then
        begin
            zRect := Rect(crect.Left,crect.Top - (Y - fy) div 2, cRect.Right, cRect.Bottom +(Y-FY) div 2);
        end
        else if clickPart.AAxis = chtPointX.BottomAxis then
        begin
            zRect := Rect(cRect.Left+(X-FX) div 2, cRect.Top, cRect.Right - (X-FX) div 2, cRect.Bottom);
        end;
        chtPointX.ZoomRect(zRect);
end;

procedure TfraGPSTrendLine.chtPointYMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
        FX := X; FY := Y;
end;

procedure TfraGPSTrendLine.chtPointYMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var     clickPart: TChartClickedPart;
        zRect,cRect: TRect;
begin
        if not (ssLeft in Shift) then Exit;
        chtPointY.CalcClickedPart(Point(X,Y), clickPart);
        if clickPart.Part <> cpAxis then Exit;
        cRect := chtPointY.ChartRect;
        if clickPart.AAxis = chtPointY.LeftAxis then
        begin
            zRect := Rect(crect.Left,crect.Top - (Y - fy) div 2, cRect.Right, cRect.Bottom +(Y-FY) div 2);
        end
        else if clickPart.AAxis = chtPointY.BottomAxis then
        begin
            zRect := Rect(cRect.Left+(X-FX) div 2, cRect.Top, cRect.Right - (X-FX) div 2, cRect.Bottom);
        end;
        chtPointY.ZoomRect(zRect);
end;

procedure TfraGPSTrendLine.chtPointHMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
        FX := X; FY := Y;
end;

procedure TfraGPSTrendLine.chtPointHMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var     clickPart: TChartClickedPart;
        zRect,cRect: TRect;
begin
        if not (ssLeft in Shift) then Exit;
        chtPointH.CalcClickedPart(Point(X,Y), clickPart);
        if clickPart.Part <> cpAxis then Exit;
        cRect := chtPointH.ChartRect;
        if clickPart.AAxis = chtPointH.LeftAxis then
        begin
            zRect := Rect(crect.Left,crect.Top - (Y - fy) div 2, cRect.Right, cRect.Bottom +(Y-FY) div 2);
        end
        else if clickPart.AAxis = chtPointH.BottomAxis then
        begin
            zRect := Rect(cRect.Left+(X-FX) div 2, cRect.Top, cRect.Right - (X-FX) div 2, cRect.Bottom);
        end;
        chtPointH.ZoomRect(zRect);
end;

procedure TfraGPSTrendLine.chtPointYMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
        chtMousePos: TPoint;
        Delta: Integer;
        gRect: TRect;
begin
        Handled := True;
        grect := chtPointY.ChartRect;
        chtMousePos := chtPointY.GetCursorPos;
        { Y轴区域 }
        if (chtMousePos.X < gRect.Left) and (Between(chtMousePos.Y, gRect.Top,gRect.Bottom) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtPointY.ZoomRect(Rect(grect.Left,grect.Top +Delta,grect.Right,grect.Bottom-Delta));
        end;
        { X轴区域 }
        if (chtMousePos.Y > gRect.Bottom) and (Between(chtMousePos.X, gRect.Left,gRect.Right) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtPointY.ZoomRect(Rect(grect.Left+Delta,grect.Top,grect.Right-Delta,grect.Bottom));
        end;

        if Between(chtMousePos.X, grect.Left, grect.Right)
            and Between(chtMousePos.Y, grect.Top,grect.Bottom) then
            if WheelDelta >0 then
                chtPointY.ZoomPercent(105)
            else
                chtPointY.ZoomPercent(95);
end;

procedure TfraGPSTrendLine.chtPointHMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
        chtMousePos: TPoint;
        Delta: Integer;
        gRect: TRect;
begin
        Handled := True;
        grect := chtPointH.ChartRect;
        chtMousePos := chtPointH.GetCursorPos;
        { Y轴区域 }
        if (chtMousePos.X < gRect.Left) and (Between(chtMousePos.Y, gRect.Top,gRect.Bottom) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtPointH.ZoomRect(Rect(grect.Left,grect.Top +Delta,grect.Right,grect.Bottom-Delta));
        end;
        { X轴区域 }
        if (chtMousePos.Y > gRect.Bottom) and (Between(chtMousePos.X, gRect.Left,gRect.Right) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtPointH.ZoomRect(Rect(grect.Left+Delta,grect.Top,grect.Right-Delta,grect.Bottom));
        end;

        if Between(chtMousePos.X, grect.Left, grect.Right)
            and Between(chtMousePos.Y, grect.Top,grect.Bottom) then
            if WheelDelta >0 then
                chtPointH.ZoomPercent(105)
            else
                chtPointH.ZoomPercent(95);

end;

end.
