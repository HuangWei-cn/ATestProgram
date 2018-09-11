{-----------------------------------------------------------------------------
 Unit Name: uut4SQL (Unit Utils for SQL Server)
 Author:    黄伟
 Date:      24-三月-2010
 Purpose:   Unit Utils for SQL Server是用于SQL Server的小工具单元
 History:
-----------------------------------------------------------------------------}

unit uut4SQL;

interface

uses
    Windows, SysUtils, TLHelp32, Registry;



    //用于检查SQLServer是否启动的函数
    function CheckTask(ExeFileName: String): Boolean;
    //检查SQL Server是否启动
    function SQLServerStart: Boolean;
    //返回已安装的SQL Server实例名字符串
    procedure RetriveMSSQLInstalledInstances(AInstances: String);
implementation

{-----------------------------------------------------------------------------
  Procedure:    CheckTask
  Description:  本函数用于检查某个进程是否存在于进程表中，即是否正在运行
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
  Description:  检查SQL Server是否启动  
-----------------------------------------------------------------------------}
function SQLServerStart: Boolean;
begin
        Result := CheckTask('sqlservr.exe');
end;
{-----------------------------------------------------------------------------
  Procedure:    RetriveMSSQLInstalledInstances
  Description:  返回已安装的SQL Server实例名字符串，从注册表中读取。  
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
            begin { 如果存在这一项，则检查‘InstalledInstances’的键值 }
                if myreg.ValueExists('InstalledInstances') then
                begin
                    myreg.ReadBinaryData('InstalledInstances', str, myreg.getdataSize('InstalledInstances'));
                    AInstances := Str;
                end;
            end
            else  { 不存在这一项，表明没有安装SQL Server };
        finally
            myreg.Free;
        end;
end;

end.
