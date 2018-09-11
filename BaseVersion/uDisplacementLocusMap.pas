{-----------------------------------------------------------------------------
 Unit Name: uDisplacementLocus
 Author:    ��ΰ
 Date:      06-����-2010
 Purpose:   ���ι켣ͼ
 History:
-----------------------------------------------------------------------------}

unit uDisplacementLocusMap;
                   
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, TeEngine, Series, ArrowCha, ExtCtrls, TeeProcs, Chart,adodb, DateUtils, uLeicaGPSData,
  Menus;

type

  TColorVariation = record
    dR, dG, dB: double;
  end;

  TLocusDataRec  = record
    dT: String;
    dX,dY,dH: Double;
  end;

  TfraLocusMap = class(TFrame)
    chtLocus: TChart;
    srsPoint: TArrowSeries;
    tmrDynamic: TTimer;
    popLocus: TPopupMenu;
    piCopyBitmap: TMenuItem;
    piCopyMetafile: TMenuItem;
    procedure tmrDynamicTimer(Sender: TObject);
    procedure piCopyBitmapClick(Sender: TObject);
    procedure piCopyMetafileClick(Sender: TObject);
    procedure chtLocusMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    { �û�ָ����X��Y����С�����ޣ�Ŀ��Ϊ��ֹͼ�α仯�Եù��ھ޴� }
    FUserYScale, FUserXScale: Double;
    { ����ɫ��������СֵΪ1�����ֵΪ�������� }
    FColorSteps: Integer;
    { ��ʼ��ɫ���м�ɫ����ֹɫ }
    FStartColor, FMiddleColor, FEndColor: TColor;
    { ��ʼɫ���м�ɫ�������м�ɫ����ֹɫ���� }
    FStepSM, FStepME: Integer;
    { RGB�仯������ʼ���м䣬�м䣭��ֹ }
    FRGBVar1, FRGBVar2: TColorVariation;
    { �����Ľ���ɫ���� }
    FLocusColors: array of TColor;
    { ��ʹ��һ����ɫ }
    FOneColor: Boolean;
    { ��̬��ʾ�켣 }
    FDynamicShow: Boolean;
    { �Ƿ��Զ������� }
    FAutoAxis: Boolean;
    { ��̬��ʾʱ��ǰ��¼�� }
    FRecordIndex: Longint;
    { Clone�Ĳ�ѯ����� }
    FCloneQry: TADOQuery;
    { �������� }
    FLocusDatas: array of TLocusDataRec;
    { ��������ɫ���� }
    procedure CreateColorArray(ANum: Integer);
  public
    { Public declarations }

    { ��ʾ����켣ͼ }
    procedure ShowXYLocus(AName, ATitle: String; AQry: TADOQuery);
    procedure InitParams;
    procedure FinallyProc;
  published
    property ColorSteps: Integer read FColorSteps   write FColorSteps;
    property StartColor : TColor read FStartColor   write FStartColor;
    property MiddleColor: TColor read FMiddleColor  write FMiddleColor;
    property EndColor   : TColor read FEndColor     write FEndColor;
    property UseOneColor    : Boolean read FOneColor    write FOneColor;
    Property DynamicShow    : Boolean read FDynamicShow write FDynamicShow;
    property AutoAxis       : Boolean read FAutoAxis    write FAutoAxis;
    property XAxisScale     : Double  read FUserXScale  write FUserXScale;
    property YAxisScale     : Double  read FUserYScale  write FUserYScale;
  end;

implementation

{$R *.dfm}
{-----------------------------------------------------------------------------
  Procedure:    TfraLocusMap.ShowLocus
  Description:  ���Ƶ�ǰ���ݼ��е�ȫ�����ݡ���ǰ���ݼ���Ӧ����һ֧����������
-----------------------------------------------------------------------------}
procedure TfraLocusMap.ShowXYLocus(AName, ATitle: String; AQry: TADOQuery);
var
        oriX, oriY  : Double;
        X0, Y0, dX, dY : Double;
        DTScaleStr: String;    //��������
        dt: TDateTime;
        recIndex: Integer;
        XS, YS, AxisLimit: Double;
        { ------------------------------------------------------ }
        function Max(V1,V2: Double): Double;
        begin
            if abs(v1) >= abs(v2) then
                Result := abs(v1)
            else
                Result := abs(v2);
        end;
        { ------------------------------------------------------ }
        procedure SetAxis;
        begin
            chtLocus.LeftAxis.AutomaticMaximum := False;
            chtLocus.LeftAxis.AutomaticMinimum := False;
            chtLocus.LeftAxis.Maximum := AxisLimit;
            chtLocus.LeftAxis.Minimum := -AxisLimit;

            chtLocus.BottomAxis.AutomaticMaximum := False;
            chtLocus.BottomAxis.AutomaticMinimum := False;
            chtLocus.BottomAxis.Maximum := AxisLimit;
            chtLocus.BottomAxis.Minimum := -AxisLimit;
        end;
        { ------------------------------------------------------ }
begin
        srsPoint.Marks.Transparent := False;
        srsPoint.Marks.Style := smsLabel;
        srsPoint.Marks.Visible := False;

        { ��������� }
        srsPoint.Clear;
        srsPoint.Title := ATitle;
        chtLocus.Title.Text.Text := ATitle;
        { ����������� }
        oriX := 0; oriY := 0;
        X0 := 0; Y0 := 0;
        { ������� }
        if AQry.RecordCount = 0 then Exit;
        AQry.Last;

        if Not FOneColor then
            CreateColorArray(AQry.RecordCount);

        if FDynamicShow then
        begin
            SetLength(FLocusDatas, AQry.RecordCount);
            { Ԥ������������ }
            XS := 0;
            YS := 0;
            recIndex := 0;
            AQry.First;
            repeat
                FLocusDatas[recIndex].dX := AQry.FieldValues['dX'] ;    //mm��λ
                FLocusDatas[recIndex].dY := Aqry.FieldValues['dY'] ;    //mm��λ
                FLocusDatas[recIndex].dH := Aqry.FieldValues['dH'] ;    //mm��λ
                dT := RecodeTime(AQry.FieldValues['DTScale'], Aqry.FieldValues['PTime'],0,0,0);
                FLocusDatas[recIndex].dT := FormatDateTime('yyyy-mm-dd hh:00', dt);

                XS := Max(XS, FLocusDatas[recIndex].dX);
                YS := Max(YS, FLocusDatas[recIndex].dY);
                AQry.Next;
                inc(recIndex);
            until AQry.Eof;

            AxisLimit := Max(XS, YS);
            if AutoAxis then
                AxisLimit := Max(AxisLimit, 1)
            else
                AxisLimit := Max(AxisLimit, FUserYScale);

            SetAxis;
            FRecordIndex := 0;
            { ʱ�ӿ�ʼ��ת }
            tmrDynamic.Enabled := True;
        end
        else
        begin
            tmrDynamic.Enabled := False;

            recIndex := 0;
            AQry.First;
            repeat
                dX := AQry.FieldValues['dX'] ;    //mm��λ
                dY := Aqry.FieldValues['dY'] ;    //mm��λ
                dt := RecodeTime(AQry.FieldValues['DTScale'], Aqry.FieldValues['PTime'],0,0,0);
                DTScaleStr := FormatDateTime('yyyy-mm-dd hh:00', dt);
                if FOneColor then
                    srsPoint.AddArrow(X0, Y0, dX, dY, DTScaleStr)
                else
                    srsPoint.AddArrow(X0, Y0, dX, dY, DTScaleStr, FLocusColors[recIndex]);
                inc(recIndex);
                X0 := dX; Y0 := dY;
                AQry.Next;
            until Aqry.Eof;

            { ���֮������������������ }
            chtLocus.LeftAxis.Automatic := True;
            chtLocus.BottomAxis.Automatic := True;
            { ����ǲ����Զ������ᣬ�� }
            if AutoAxis then
            begin
                XS := Max(srsPoint.XValues.MaxValue, srsPoint.XValues.MinValue);
                YS := Max(srsPoint.YValues.MaxValue, srsPoint.YValues.MinValue);
                AxisLimit := Max(XS, YS);
                AxisLimit := Max(AxisLimit, 1);
                SetAxis;
            end
            else
            begin
                XS := Max(srsPoint.XValues.MaxValue, srsPoint.XValues.MinValue);
                YS := Max(srsPoint.YValues.MaxValue, srsPoint.YValues.MinValue);
                AxisLimit := Max(XS, YS);
                AxisLimit := Max(AxisLimit, FUserYScale);
                SetAxis;
            end;
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraLocusMap.InitParams
  Description:  ��ʼ������
-----------------------------------------------------------------------------}
procedure TfraLocusMap.InitParams;
begin
        FStartColor := RGB2TColor(255,238,255);
        //FStartColor := clGreen;
        FMiddleColor := RGB2TColor(255,119,187);
        //FMiddleColor := clYellow;
        FEndColor   := clRed;
        FUserXScale := 2;
        FUserYScale := 2;
        FOneColor := True;
        FDynamicShow := False;
        FAutoAxis   := True;
        FCloneQry   := TADOQuery.Create(Self);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraLocusMap.FinallyProc
  Description:
-----------------------------------------------------------------------------}
procedure TfraLocusMap.FinallyProc;
begin
        SetLength(FLocusColors, 0);
        FreeAndNil(FCloneQry);
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraLocusMap.CreateColorArray
  Description:  ��������ɫ����
-----------------------------------------------------------------------------}
procedure TfraLocusMap.CreateColorArray(ANum: Integer);
var     sRed, sGreen, sBlue,
        mRed, mGreen, mBlue,
        eRed, eGreen, eBlue: Byte;
        iStep: Integer;
begin
        SetLength(FLocusColors, ANum);
        FStepSM := ANum div 2;
        FStepME := ANum - FStepSM;
        TColor2RGB(FStartColor, sRed, sGreen, sBlue);
        TColor2RGB(FMiddleColor, mRed, mGreen, mBlue);
        TColor2RGB(FEndColor, eRed, eGreen, eBlue);
        { ������ʼ���м�ɫ��ɫ���� }
        FRGBVar1.dR := (mRed - sRed) / FStepSM;
        FRGBVar1.dG := (mGreen - sGreen) / FStepSM;
        FRGBVar1.dB := (mBlue - sBlue) / FStepSM;
        { �����м�ɫ����ɫ��ɫ���� }
        FRGBVar2.dR := (eRed - mRed) / FStepME;
        FRGBVar2.dG := (eGreen - mGreen) / FStepME;
        FRGBVar2.dB := (eBlue - mBlue) / FStepME;
        for iStep := 0 to FStepSM -1 do
            FLocusColors[iStep] := RGB2TColor(sRed + Round(iStep * FRGBVar1.dR),
                sGreen + Round(iStep * FRGBVar1.dG), sBlue + Round(iStep * FRGBVar1.dB));

        for iStep := FStepSM to ANum -1 do
            FLocusColors[iStep] := RGB2TColor(mRed + Round((iStep - FStepSM) * FRGBVar2.dR),
                mGreen + Round((iStep - FStepSM) * FRGBVar2.dG), mBlue + Round((iStep - FStepSM) * FRGBVar2.dB));
end;
{-----------------------------------------------------------------------------
  Procedure:    TfraLocusMap.tmrDynamicTimer
  Description:  ��̬��ʾ  
-----------------------------------------------------------------------------}
procedure TfraLocusMap.tmrDynamicTimer(Sender: TObject);
var
        X0, Y0, dX, dY : Double;
        DTScaleStr: String;    //��������
        dt: TDateTime;
        i: Integer;
begin
        if Not FDynamicShow then Exit;
        if Length(FLocusDatas) = 0 then Exit;

        if FRecordIndex >= Length(FLocusDatas) then
        begin
            FRecordIndex := 0;
            srsPoint.Clear;
            Exit;
        end;

        //srsPoint.Marks.Visible := True;
        //srsPoint.Marks.Transparent := True;

        if FRecordIndex = 0 then
        begin
            X0 := 0; Y0 := 0;
        end
        else
        begin
            X0 := FLocusDatas[FRecordIndex-1].dX;
            Y0 := FLocusDatas[FRecordIndex-1].dY;
        end;

        if FOneColor then
            srsPoint.AddArrow(X0, Y0, FLocusDatas[FRecordIndex].dX, FLocusDatas[FRecordIndex].dY,
                FLocusDatas[FRecordIndex].dT)
        else
        begin
//            srsPoint.AddArrow(X0, Y0, FLocusDatas[FRecordIndex].dX, FLocusDatas[FRecordIndex].dY,
//                FLocusDatas[FRecordIndex].dT, FLocusColors[FRecordIndex]);
            X0 := 0; Y0 := 0;
            srsPoint.Clear;
            for i := 0 to FRecordIndex do
            begin
                { �ý���ɫ��ʾǰ������ݣ�ͬʱ���ǰ�����ݵı�ǩ }
                srsPoint.AddArrow(X0, Y0, FLocusDatas[i].dX, FLocusDatas[i].dY,
                    FLocusDatas[i].dT, FLocusColors[Length(FLocusColors)-FRecordIndex-1+i]);
                X0 := FLocusDatas[i].dX;
                Y0 := FLocusDatas[i].dY;
            end;
            { ��ʾ��̬�����һ�����ݣ�����ʾ��ǩ }
//            srsPoint.AddArrow(X0, Y0, FLocusDatas[FRecordIndex].dX, FLocusDatas[FRecordIndex].dY,
//                FLocusDatas[FRecordIndex].dT, FLocusColors[Length(FLocusColors)-1]);

        end;

        inc(FRecordIndex);
end;

procedure TfraLocusMap.piCopyBitmapClick(Sender: TObject);
begin
        chtLocus.CopyToClipboardBitmap;
end;

procedure TfraLocusMap.piCopyMetafileClick(Sender: TObject);
begin
        chtLocus.CopyToClipboardMetafile(False);
end;

procedure TfraLocusMap.chtLocusMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
        chtMousePos: TPoint;
        Delta: Integer;
        gRect: TRect;
begin
        Handled := True;
        grect := chtLocus.ChartRect;
        chtMousePos := chtLocus.GetCursorPos;
        { Y������ }
        if (chtMousePos.X < gRect.Left) and (Between(chtMousePos.Y, gRect.Top,gRect.Bottom) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtLocus.ZoomRect(Rect(grect.Left,grect.Top +Delta,grect.Right,grect.Bottom-Delta));
        end;
        { X������ }
        if (chtMousePos.Y > gRect.Bottom) and (Between(chtMousePos.X, gRect.Left,gRect.Right) ) then
        begin
            if WheelDelta >0 then Delta := 5 else Delta :=-5;

            chtLocus.ZoomRect(Rect(grect.Left+Delta,grect.Top,grect.Right-Delta,grect.Bottom));
        end;

        if Between(chtMousePos.X, grect.Left, grect.Right)
            and Between(chtMousePos.Y, grect.Top,grect.Bottom) then
            if WheelDelta >0 then
                chtLocus.ZoomPercent(105)
            else
                chtLocus.ZoomPercent(95);

end;

initialization

end.
