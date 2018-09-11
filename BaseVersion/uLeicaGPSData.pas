{-----------------------------------------------------------------------------
 Unit Name: uLeicaGPSData
 Author:    黄伟
 Date:      23-四月-2010
 Purpose:   本单元用于处理徕卡GPS数据，以及一些公用函数、过程。
 History:
-----------------------------------------------------------------------------}

unit uLeicaGPSData;

interface

uses
        Windows, SysUtils, janXMLTree, Graphics;

type
        //数据库中有哪些时刻的数据，及数量
        TGPSDataTime    = record
            TheHour     : Integer;  //时刻
            Number      : Integer;  //数量
        end;

        //GPS点数据
        TGPSPoint       = record
            Name        : String;
            ID          : Longint;
            X,Y,H       : Double;
        end;
        PGPSPoint       = ^TGPSPoint;

        //断面，轮廓
        TGPSProfile     = record
            Name        : String;
            Points      : array of PGPSPoint;
            Descriptoin : String;   //描述
        end;
        PGPSProfile     = ^TGPSProfile;

        { 某精度/测次设置及相关点 }
        TDataPrecision  = record
            DataNum     : Integer;  //日测次
            Interval    : Single;   //小时
            Points      : array of PGPSPoint;
        end;
        PDataPrecision  = ^TDataPrecision;

        { 加载项目设置 }
        //procedure LoadProjectSetup;

        { 保存项目设置 }
        //procedure SaveProjectSetup;

        { 保存数据库连接字 }
        procedure WriteCNStrToSetting(ACNStr: String);
        { 从设置文件中读出数据库连接字 }
        function ReadCNStrFromSetting: String;
        { 找出符合精度要求的点，输出'12233,33424,5555'形式的字符串，供查询IN函数时候 }
        function GetInStrWithPrecision(APrecision: Single): String;
        { 根据数据精度返回指定监测点的ID }
        function GetPointIDByPrecision(AName: String; ADataPrecision: Integer): Integer;
        { 将RGB转变为TColor类型 }
        function RGB2TColor(const R, G, B: Byte): Integer;
        { 将TColor类型分解为RGB }
        procedure TColor2RGB(const Color: TColor; var R, G, B: Byte);
        { Between函数 }
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

        PrjSetting  : TJanXMLTree;      //项目设置
        SettingFile : String;
        DataBeginDate, DataLastDate: TDateTime;
implementation
{-----------------------------------------------------------------------------
  Procedure:    RGB2TColor
  Description:  将RGB值转换为TColor类型  
-----------------------------------------------------------------------------}
function RGB2TColor(const R, G, B: Byte): Integer;
begin
  // convert hexa-decimal values to RGB
  Result := R + G shl 8 + B shl 16;
end;
{-----------------------------------------------------------------------------
  Procedure:    TColor2RGB
  Description:  将TColor分解为RGB  
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
            PrjSetting.AddNode('PointParams','');   //监测点参数
            PrjSetting.AddNode('Profiles','');      //断面设置
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
                //GPS点已经在前面的循环中被注销了，此处仅释放数组空间
                SetLength(GPSProfiles[i].Points, 0);
                dispose(GPSProfiles[i]);
            end;
            SetLength(GPSProfiles, 0);
        end;

        if Length(DataPrecisions) > 0 then
        begin
            for i := 0 to Length(DataPrecisions) -1 do
            begin
                //其中的Points指针已经在前面释放GPSPoints数组时释放了
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
  Description:  返回符合精度的ID列，供查询In函数使用  
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
  Description:  根据数据精度（数据打包时段）返回指定监测点的Point_ID  
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
