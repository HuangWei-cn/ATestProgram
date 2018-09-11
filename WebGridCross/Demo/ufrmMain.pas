unit ufrmMain;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics, System.DateUtils,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw;

type
    TForm1 = class(TForm)
        wbDemo: TWebBrowser;
        stat1: TStatusBar;
        btnSimpleGrid: TButton;
        pnl1: TPanel;
        btnMultiGrid: TButton;
        pnl2: TPanel;
        spl1: TSplitter;
        mmoCode: TMemo;
        procedure btnSimpleGridClick(Sender: TObject);
        procedure btnMultiGridClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    Form1: TForm1;

implementation

uses
    uWebGridCross, uWBLoadHTML;

{$R *.dfm}

procedure TForm1.btnMultiGridClick(Sender: TObject);
var
    htm, Page: string;
    wcv: TWebCrossView;
begin
    htm := '';
    wcv := TWebCrossView.Create;
    Page := wcv.BlankPage; // 取得空页面代码

    { ---------- 表格1：最简单的表格形式，用法也最简单----------------------- }
    wcv.ColCount := 3;
    wcv.TitleRows := 1;
    // 写入表头行
    wcv.AddRow(['序号', '名称', '备注']);
    // 写入数据
    wcv.AddRow(['1', '贝多芬第九交响曲', '卡拉扬']);
    wcv.AddRow(['2', '德沃夏克e小调第九交响曲', '托斯卡尼尼']);

    htm := '<br>交响曲清单<br>' + wcv.CrossGrid + '<br><hr>';

    { ---------- 表格2: 多行表头、单元格横向和纵向合并      ---------------- }
    wcv.Reset;
    wcv.ColCount := 6;
    wcv.TitleRows := 2; // 表头行有3行
    wcv.TitleCols := 3;
    wcv.ColHeader[0].AllowColSpan := True; // 允许纵向合并相同单元格
    wcv.ColHeader[0].Align := taCenter; // 设置列对齐方式
    wcv.ColHeader[1].AllowColSpan := True;
    wcv.ColHeader[1].Align := taCenter;
    wcv.ColHeader[2].AllowColSpan := True;
    // wcv.ColHeader[5].AllowColSpan := True;
    // 写入表头
    wcv.AddRow(['设计编号', '安装位置', '日期', '相对位移', '相对位移', '备注']);
    wcv.AddRow(['设计编号', '安装位置', '日期', '孔口', '孔底', '备注']);
    // 写入数据
    wcv.AddCaptionRow(['主厂房']);
    wcv.AddRow(['M4CFX', '主厂房', '2011-09-29', '11.53', '4.31', '测点异常，采用相对位移']);
    wcv.AddRow(['M4CFX', '主厂房', '2011-10-06', '13.49', '4.34', '测点异常，采用相对位移']);
    wcv.AddRow(['M4CFX', '主厂房', '变化量', '1.86', '-0.12', '测点异常，采用相对位移']);
    // 表格中间插入一个Caption行
    wcv.AddCaptionRow(['大坝']);
    wcv.AddRow(['M4CFX2', '大坝1', '2011-09-29', '11.53', '4.31', '测点异常，采用相对位移']);
    wcv.AddRow(['M4CFX2', '大坝1', '2011-10-06', '13.49', '4.34', '测点异常，采用相对位移']);
    wcv.AddRow(['M4CFX2', '大坝1', '变化量', '1.86', '-0.12', '测点异常，采用相对位移']);

    wcv.AddCaptionRow(['副厂房', '副厂房', '数据']);
    wcv.AddRow(['M4CFX3', '副厂房', '2011-09-29', '11.53', '4.31', '测点异常，采用相对位移']);
    wcv.AddRow(['M4CFX3', '副厂房', '2011-10-06', '13.49', '4.34', '测点异常，采用相对位移']);
    wcv.AddRow(['M4CFX3', '副厂房', '变化量', '1.86', '-0.12', '测点异常，采用相对位移']);

    htm := htm + '观测成果表<br>' + wcv.CrossGrid + '<br><hr>';

    // 表格3……算了，不玩了。
    // wcv.Reset;

    wcv.Free;

    // 设置页面代码
    Page := StringReplace(Page, '@PageTitle@', '本页有多个表格', [rfReplaceAll]);
    Page := StringReplace(Page, '@PageContent@', htm, [rfReplaceAll]);
    WB_LoadHTML(wbDemo, Page);
    mmoCode.Text := Page;
end;

procedure TForm1.btnSimpleGridClick(Sender: TObject);
var
    wcv: TWebCrossView;
    htm: String;
begin
    wcv := TWebCrossView.Create;
    wcv.ColCount := 6;
    wcv.TitleRows := 2;
    with wcv do
    begin
        AddRow(['日期', '监测仪器', '监测仪器', '观测数据', '观测数据', '备注']);
        AddRow(['日期', '仪器编号', '子传感器', '开合度', '温度', '备注']);
        AddRow([today, 'X', 'X-1', 25, 24, '']);
        AddCaptionRow(['日期', '数据2', '数据2', '内容']);
        AddRow([today, 'X', 'X-2', 36.334423, 19.443, '']);
    end; // with

    htm := wcv.CrossPage; // wcv.CrossGrid
    WB_LoadHTML(wbDemo, htm);
    mmoCode.Text := htm;
    wcv.Free;
end;

end.
