{-----------------------------------------------------------------------------
 Unit Name: uut4SQL (Unit Utils for SQL Server)
 Author:    ��ΰ
 Date:      24-����-2010
 Purpose:   Unit Utils for SQL Server������SQL Server��С���ߵ�Ԫ
 History:
-----------------------------------------------------------------------------}

unit uut4SQL;

interface

uses
    Windows, SysUtils, TLHelp32, Registry;



    //���ڼ��SQLServer�Ƿ������ĺ���
    function CheckTask(ExeFileName: String): Boolean;
    //���SQL Server�Ƿ�����
    function SQLServerStart: Boolean;
    //�����Ѱ�װ��SQL Serverʵ�����ַ���
    procedure RetriveMSSQLInstalledInstances(AInstances: String);
implementation

{-----------------------------------------------------------------------------
  Procedure:    CheckTask
  Description:  ���������ڼ��ĳ�������Ƿ�����ڽ��̱��У����Ƿ���������
-----------------------------------------------------------------------------}
function CheckTask(ExeFileName: String): Boolean;
const PROCESS_TERMINATE = $0001;
var
        ContinueLoop: Bool;
        FSnapshotHandle: THandle;
        FProcessEntry32: TProcessEntry32;
begin
        result := False;
        FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
        ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
        while integer(ContinueLoop) <> 0 do
        begin
            if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
                or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
                result := True;
            ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
        end;

end;
{-----------------------------------------------------------------------------
  Procedure:    SQLServerStart
  Description:  ���SQL Server�Ƿ�����  
-----------------------------------------------------------------------------}
function SQLServerStart: Boolean;
begin
        Result := CheckTask('sqlservr.exe');
end;
{-----------------------------------------------------------------------------
  Procedure:    RetriveMSSQLInstalledInstances
  Description:  �����Ѱ�װ��SQL Serverʵ�����ַ�������ע����ж�ȡ��  
-----------------------------------------------------------------------------}
procedure RetriveMSSQLInstalledInstances(AInstances: String);
var
        myreg: TRegistry;
        str: string[255];
begin
        AInstances := '';
        myreg := TRegistry.Create;
        myreg.RootKey := HKEY_LOCAL_MACHINE;
        try
            if myreg.OpenKey('\Software\Microsoft\Microsoft SQL Server', false) then
            begin { ���������һ����顮InstalledInstances���ļ�ֵ }
                if myreg.ValueExists('InstalledInstances') then
                begin
                    myreg.ReadBinaryData('InstalledInstances', str, myreg.getdataSize('InstalledInstances'));
                    AInstances := Str;
                end;
            end
            else  { ��������һ�����û�а�װSQL Server };
        finally
            myreg.Free;
        end;
end;

end.
