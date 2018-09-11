{-----------------------------------------------------------------------------
 Unit Name: uLeicaGPSData
 Author:    ��ΰ
 Date:      23-����-2010
 Purpose:   ����Ԫ���ڴ����⿨GPS���ݣ��Լ�һЩ���ú��������̡�
 History:
-----------------------------------------------------------------------------}

unit uLeicaGPSData;

interface

uses
        Windows, SysUtils, janXMLTree, Graphics;

type
        //���ݿ�������Щʱ�̵����ݣ�������
        TGPSDataTime    = record
            TheHour     : Integer;  //ʱ��
            Number      : Integer;  //����
        end;

        //GPS������
        TGPSPoint       = record
            Name        : String;
            ID          : Longint;
            X,Y,H       : Double;
        end;
        PGPSPoint       = ^TGPSPoint;

        //���棬����
        TGPSProfile     = record
            Name        : String;
            Points      : array of PGPSPoint;
            Descriptoin : String;   //����
        end;
        PGPSProfile     = ^TGPSProfile;

        { ĳ����/������ü���ص� }
        TDataPrecision  = record
            DataNum     : Integer;  //�ղ��
            Interval    : Single;   //Сʱ
            Points      : array of PGPSPoint;
        end;
        PDataPrecision  = ^TDataPrecision;

        { ������Ŀ���� }
        //procedure LoadProjectSetup;

        { ������Ŀ���� }
        //procedure SaveProjectSetup;

        { �������ݿ������� }
        procedure WriteCNStrToSetting(ACNStr: String);
        { �������ļ��ж������ݿ������� }
        function ReadCNStrFromSetting: String;
        { �ҳ����Ͼ���Ҫ��ĵ㣬���'12233,33424,5555'��ʽ���ַ���������ѯIN����ʱ�� }
        function GetInStrWithPrecision(APrecision: Single): String;
        { �������ݾ��ȷ���ָ�������ID }
        function GetPointIDByPrecision(AName: String; ADataPrecision: Integer): Integer;
        { ��RGBת��ΪTColor���� }
        function RGB2TColor(const R, G, B: Byte): Integer;
        { ��TColor���ͷֽ�ΪRGB }
        procedure TColor2RGB(const Color: TColor; var R, G, B: Byte);
        { Between���� }
        function Between(X,A,B:Double): Boolean;
CONST
        SQL_PTIME = 'ROUND(DATEPART(hour,T1.epoch) + DATEPART(MINUTE,T1.epoch)/100.00,0 ) as PTime ';
        SQL_REALNAMEQUERY = 'SELECT ID, left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName FROM Points';
        SQL_REALNAMEIDQUERY = 'SELECT ID, left([Name], PATINDEX (''%[_]%'' , [Name])-1) as PName, ID FROM Points';

var
        GDT         : array of TGPSDataTime;
        GPSPoints   : array of PGPSPoint;
        GPSProfiles : array of PGPSProfile;
        DataPrecisions : array of PDataPrecision;

        PrjSetting  : TJanXMLTree;      //��Ŀ����
        SettingFile : String;
        DataBeginDate, DataLastDate: TDateTime;
implementation
{-----------------------------------------------------------------------------
  Procedure:    RGB2TColor
  Description:  ��RGBֵת��ΪTColor����  
-----------------------------------------------------------------------------}
function RGB2TColor(const R, G, B: Byte): Integer;
begin
  // convert hexa-decimal values to RGB
  Result := R + G shl 8 + B shl 16;
end;
{-----------------------------------------------------------------------------
  Procedure:    TColor2RGB
  Description:  ��TColor�ֽ�ΪRGB  
-----------------------------------------------------------------------------}
procedure TColor2RGB(const Color: TColor; var R, G, B: Byte);
begin
  R := Color and $FF;
  G := (Color shr 8) and $FF;
  B := (Color shr 16) and $FF;
end;
{-----------------------------------------------------------------------------
  Procedure:    LoadProjectSetup
  Description:  
-----------------------------------------------------------------------------}
procedure LoadProjectSetup;
begin
        PrjSetting := TjanXMLTree.Create('LeicaGPS','',nil);
        SettingFile := ExtractFileDir(GetModuleName(MainInstance)) + '\LeicaGPSSetting.xml';

        if FileExists(SettingFile) then
        begin
            PrjSetting.LoadFromFile(SettingFile);
        end
        else
        begin
            PrjSetting.AddNode('PointParams','');   //�������
            PrjSetting.AddNode('Profiles','');      //��������
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    SaveProjectSetup
  Description:
-----------------------------------------------------------------------------}
procedure SaveProjectSetup;
begin
        PrjSetting.SaveToFile(SettingFile);
end;
{-----------------------------------------------------------------------------
  Procedure:    FreePrjSetting
  Description:
-----------------------------------------------------------------------------}
procedure FreePrjSetting;
begin
        SaveProjectSetup;
        FreeAndNil(PrjSetting);
end;
{-----------------------------------------------------------------------------
  Procedure:    ReleaseArray
  Description:  
-----------------------------------------------------------------------------}
procedure ReleaseArray;
var     i: Integer;
begin
        if length(GDT) <> 0 then SetLength(GDT,0);

        if Length(GPSPoints) <> 0 then
        begin
            for i := 0 to Length(GPSPoints)-1 do
                dispose(GPSPoints[i]);

            SetLength(GPSPoints, 0);
        end;

        if Length(GPSProfiles) >0 then
        begin
            for i := 0 to Length(GPSProfiles) -1 do
            begin
                //GPS���Ѿ���ǰ���ѭ���б�ע���ˣ��˴����ͷ�����ռ�
                SetLength(GPSProfiles[i].Points, 0);
                dispose(GPSProfiles[i]);
            end;
            SetLength(GPSProfiles, 0);
        end;

        if Length(DataPrecisions) > 0 then
        begin
            for i := 0 to Length(DataPrecisions) -1 do
            begin
                //���е�Pointsָ���Ѿ���ǰ���ͷ�GPSPoints����ʱ�ͷ���
                if Length(DataPrecisions[i].Points) > 0 then SetLength(DataPrecisions[i].Points, 0);
                dispose(DataPrecisions[i]);
            end;
            SetLength(DataPrecisions, 0);
        end;
end;
{-----------------------------------------------------------------------------
  Procedure:    WriteCNStrToSetting
  Description:  
-----------------------------------------------------------------------------}
procedure WriteCNStrToSetting(ACNStr: String);
var     nd: TJanXMLNode;
begin
        nd :=  prjSetting.findNamedNode('DBConnString');
        if nd = nil then
            nd := prjSetting.AddNode('DBConnString', ACNStr)
        else
            nd.Value := ACNStr;
end;
{-----------------------------------------------------------------------------
  Procedure:    ReadCNStrFromSetting
  Description:  
-----------------------------------------------------------------------------}
function ReadCNStrFromSetting: String;
var     nd: TjanXMLNode;
begin
        Result := '';
        nd := PrjSetting.findNamedNode('DBConnString');
        if nd <> nil then Result := nd.Value;
end;
{-----------------------------------------------------------------------------
  Procedure:    GetInStrWithPrecision
  Description:  ���ط��Ͼ��ȵ�ID�У�����ѯIn����ʹ��  
-----------------------------------------------------------------------------}
function GetInStrWithPrecision(APrecision: Single): String;
var     i,j: Integer;
begin
        result := '';
        for i := 0 to Length(DataPrecisions) -1 do
            if DataPrecisions[i].Interval = APrecision then
                for j := 0 to Length(DataPrecisions[i].Points) -1 do
                    Result := Result + IntToStr(DataPrecisions[i].Points[j]^.ID) + ',';
        if Length(Result) > 1 then
            Result := Copy(Result, 1, Length(Result)-1);
end;
{-----------------------------------------------------------------------------
  Procedure:    GetPointIDByPrecision
  Description:  �������ݾ��ȣ����ݴ��ʱ�Σ�����ָ�������Point_ID  
-----------------------------------------------------------------------------}
function GetPointIDByPrecision(AName: String; ADataPrecision: Integer):Integer;
var
        I, J: Integer;
begin
        Result := -1;
        for I := 0 to Length(DataPrecisions) -1 do
            if DataPrecisions[i].Interval = ADataPrecision then
                for J := 0 to Length(DataPrecisions[I].Points) -1 do
                    if DataPrecisions[I].Points[J]^.Name = AName then
                        Result := DataPrecisions[I].Points[J]^.ID;
end;

function Between(X,A,B:Double):Boolean;
begin
        if (X>=A) and (X<=B) then Result := True else Result := False;
end;

initialization
        LoadProjectSetup;

finalization
        ReleaseArray;
        FreePrjSetting;

end.
