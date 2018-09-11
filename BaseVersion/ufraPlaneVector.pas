unit ufraPlaneVector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, TeEngine, Series, ArrowCha, pngimage, TeeProcs, Chart, StdCtrls,
  ExtCtrls, ADODB, Math;

type
  TfraPlaneVector = class(TFrame)
    Panel4: TPanel;
    Label2: TLabel;
    cmbVectorDates: TComboBox;
    btnAniShowVector: TButton;
    chtPlaneVector: TChart;
    srsPlaneVector: TArrowSeries;
  private
    { Private declarations }
    { 平面绘图区X、Y范围，绘图时固定在这个范围内 }
    FXMin,FXMax,FYMin,FYMax: Double;
    { 底图的名称、路径 }
    FBackGraphic: String;
    function GetDateList: TStrings;
  public
    { Public declarations }
    property DateList: TStrings read GetDateList;
    { 设置数据日期，当前数据较少的时候可用comboBox，日后恐怕要用日期组件才行 }
    procedure SetDates(ADates: TStrings);
    { 设置绘图区范围。注：此处的X、Y为直角坐标系中的X、Y，即横轴X，竖轴Y，和测量坐标系不同 }
    procedure SetDrawSize(XMin, XMax, YMin, YMax: Double);
    { 设置平面矢量图底图 }
    procedure SetBackGraphic(AFile: String);
    { 绘图 }
    procedure DrawVector(ATitle: String;aqry: TADOQuery);
  end;

implementation

{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.SetDrawSize
  Description:  设置绘图区范围
-----------------------------------------------------------------------------}
procedure TfraPlaneVector.SetDrawSize(XMin, XMax, YMin, YMax: Double);
begin
        FXMin := XMin; FXMax := XMax; FYMin := YMin; FYmax := YMax;

        chtPlaneVector.BottomAxis.LabelStyle := talValue;

        chtPlaneVector.BottomAxis.Automatic := False;
        chtPlaneVector.BottomAxis.Maximum := XMax;
        chtPlaneVector.BottomAxis.Minimum := XMin;

        chtPlaneVector.LeftAxis.Automatic := False;
        chtPlaneVector.LeftAxis.Maximum := YMax;
        chtPlaneVector.LeftAxis.Minimum := YMin;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.SetBackGraphic
  Description:  设置平面矢量图底图  
-----------------------------------------------------------------------------}
procedure TfraPlaneVector.SetBackGraphic(AFile: String);
begin
        chtPlaneVector.BackImage.LoadFromFile(AFile);
        chtPlaneVector.BackImageInside := True;
        chtPlaneVector.BackImageMode := pbmStretch;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.DrawVector
  Description:  绘制一幅新的变形平面矢量图  
-----------------------------------------------------------------------------}
procedure TfraPlaneVector.DrawVector(ATitle: String; aQry: TADOQuery);
var
        X,Y,ddx,ddy,ddH: Double;
        iseries: Integer;
        NewArrowSeries: TArrowSeries;
        PName: String;
begin
        chtPlaneVector.Title.Text.Clear;
        chtPlaneVector.Title.Text.Add(ATitle);
        if chtPlaneVector.SeriesCount > 0 then
            for iseries := 0 to chtPlaneVector.SeriesCount -1 do
                chtPlaneVector.SeriesList[iSeries].Free;
        chtPlaneVector.SeriesList.Clear;

        if AQry.RecordCount = 0 then Exit;

        NewArrowSeries := TArrowSeries.Create(Self);
        NewArrowSeries.ParentChart := chtPlaneVector;
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

        repeat
            X := aQry.FieldValues['X'];
            Y := aQry.FieldValues['Y'];
            //ddx := qry.FieldValues['dx'] * 10000;
            //ddy := qry.FieldValues['dy'] * 10000;
            ddx := aQry.FieldValues['dx'] * 10;  //视图方式已经将变形量×1000了
            ddy := aQry.FieldValues['dY'] * 10;
            ddH := aQry.FieldValues['dH'];
            //PName := qry.FieldValues['PName'];
//                    PName := Copy(PName, 1, Pos('_', PName)-1) + '    L:' + FloatToStr(RoundTo(sqrt(sqr(ddx/10000)+sqr(ddy/10000)+sqr(ddh))*1000,-2)) + 'mm'
//                            + #13#10'dX:'+FloatToStr(RoundTo(ddx/10,-2)) + ', dY:' + FloatToStr(RoundTo(ddy/10,-2)) + ', dH:' + FloatToStr(RoundTo(ddH*1000, -2)) + '      ';
            PName := aQry.FieldValues['PName'] + '    L:' + FloatToStr(RoundTo(aQry.FieldValues['Len'], -2)) + 'mm'
                    + #13#10'dX:'+FloatToStr(RoundTo(ddx/10,-2)) + ', dY:' + FloatToStr(RoundTo(ddy/10,-2)) + ', dH:' + FloatToStr(RoundTo(ddH, -2)) + '      ';

            { 注：在测量系统中，竖轴是X方向，横轴是Y方向，但是在几何直角坐标系中，X是横轴，Y是竖轴。
              因此在绘图的时候注意应将X、Y对置 }
            NewArrowSeries.AddArrow(Y,X,Y+ddY,X+ddX, PName);

            aQry.Next;
        until aQry.Eof;

end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.SetDates
  Description:  原拟在此方法中设置数据日期，现由GetDateList方法提供，由调用
                程序填写。
-----------------------------------------------------------------------------}
procedure TfraPlaneVector.SetDates(ADates: TStrings);
begin
            //Do nothing
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.GetDateList
  Description:  返回cmbVectorDates.Items，供调用程序向立面填写数据的日期  
-----------------------------------------------------------------------------}
function TfraPlaneVector.GetDateList:TStrings;
begin
        Result := cmbVectorDates.Items;
end;

end.
