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
    { ƽ���ͼ��X��Y��Χ����ͼʱ�̶��������Χ�� }
    FXMin,FXMax,FYMin,FYMax: Double;
    { ��ͼ�����ơ�·�� }
    FBackGraphic: String;
    function GetDateList: TStrings;
  public
    { Public declarations }
    property DateList: TStrings read GetDateList;
    { �����������ڣ���ǰ���ݽ��ٵ�ʱ�����comboBox���պ����Ҫ������������� }
    procedure SetDates(ADates: TStrings);
    { ���û�ͼ����Χ��ע���˴���X��YΪֱ������ϵ�е�X��Y��������X������Y���Ͳ�������ϵ��ͬ }
    procedure SetDrawSize(XMin, XMax, YMin, YMax: Double);
    { ����ƽ��ʸ��ͼ��ͼ }
    procedure SetBackGraphic(AFile: String);
    { ��ͼ }
    procedure DrawVector(ATitle: String;aqry: TADOQuery);
  end;

implementation

{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.SetDrawSize
  Description:  ���û�ͼ����Χ
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
  Description:  ����ƽ��ʸ��ͼ��ͼ  
-----------------------------------------------------------------------------}
procedure TfraPlaneVector.SetBackGraphic(AFile: String);
begin
        chtPlaneVector.BackImage.LoadFromFile(AFile);
        chtPlaneVector.BackImageInside := True;
        chtPlaneVector.BackImageMode := pbmStretch;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.DrawVector
  Description:  ����һ���µı���ƽ��ʸ��ͼ  
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
            ddx := aQry.FieldValues['dx'] * 10;  //��ͼ��ʽ�Ѿ�����������1000��
            ddy := aQry.FieldValues['dY'] * 10;
            ddH := aQry.FieldValues['dH'];
            //PName := qry.FieldValues['PName'];
//                    PName := Copy(PName, 1, Pos('_', PName)-1) + '    L:' + FloatToStr(RoundTo(sqrt(sqr(ddx/10000)+sqr(ddy/10000)+sqr(ddh))*1000,-2)) + 'mm'
//                            + #13#10'dX:'+FloatToStr(RoundTo(ddx/10,-2)) + ', dY:' + FloatToStr(RoundTo(ddy/10,-2)) + ', dH:' + FloatToStr(RoundTo(ddH*1000, -2)) + '      ';
            PName := aQry.FieldValues['PName'] + '    L:' + FloatToStr(RoundTo(aQry.FieldValues['Len'], -2)) + 'mm'
                    + #13#10'dX:'+FloatToStr(RoundTo(ddx/10,-2)) + ', dY:' + FloatToStr(RoundTo(ddy/10,-2)) + ', dH:' + FloatToStr(RoundTo(ddH, -2)) + '      ';

            { ע���ڲ���ϵͳ�У�������X���򣬺�����Y���򣬵����ڼ���ֱ������ϵ�У�X�Ǻ��ᣬY�����ᡣ
              ����ڻ�ͼ��ʱ��ע��Ӧ��X��Y���� }
            NewArrowSeries.AddArrow(Y,X,Y+ddY,X+ddX, PName);

            aQry.Next;
        until aQry.Eof;

end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.SetDates
  Description:  ԭ���ڴ˷����������������ڣ�����GetDateList�����ṩ���ɵ���
                ������д��
-----------------------------------------------------------------------------}
procedure TfraPlaneVector.SetDates(ADates: TStrings);
begin
            //Do nothing
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraPlaneVector.GetDateList
  Description:  ����cmbVectorDates.Items�������ó�����������д���ݵ�����  
-----------------------------------------------------------------------------}
function TfraPlaneVector.GetDateList:TStrings;
begin
        Result := cmbVectorDates.Items;
end;

end.
