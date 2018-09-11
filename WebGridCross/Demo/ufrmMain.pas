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
    Page := wcv.BlankPage; // ȡ�ÿ�ҳ�����

    { ---------- ���1����򵥵ı����ʽ���÷�Ҳ���----------------------- }
    wcv.ColCount := 3;
    wcv.TitleRows := 1;
    // д���ͷ��
    wcv.AddRow(['���', '����', '��ע']);
    // д������
    wcv.AddRow(['1', '����ҵھŽ�����', '������']);
    wcv.AddRow(['2', '�����Ŀ�eС���ھŽ�����', '��˹������']);

    htm := '<br>�������嵥<br>' + wcv.CrossGrid + '<br><hr>';

    { ---------- ���2: ���б�ͷ����Ԫ����������ϲ�      ---------------- }
    wcv.Reset;
    wcv.ColCount := 6;
    wcv.TitleRows := 2; // ��ͷ����3��
    wcv.TitleCols := 3;
    wcv.ColHeader[0].AllowColSpan := True; // ��������ϲ���ͬ��Ԫ��
    wcv.ColHeader[0].Align := taCenter; // �����ж��뷽ʽ
    wcv.ColHeader[1].AllowColSpan := True;
    wcv.ColHeader[1].Align := taCenter;
    wcv.ColHeader[2].AllowColSpan := True;
    // wcv.ColHeader[5].AllowColSpan := True;
    // д���ͷ
    wcv.AddRow(['��Ʊ��', '��װλ��', '����', '���λ��', '���λ��', '��ע']);
    wcv.AddRow(['��Ʊ��', '��װλ��', '����', '�׿�', '�׵�', '��ע']);
    // д������
    wcv.AddCaptionRow(['������']);
    wcv.AddRow(['M4CFX', '������', '2011-09-29', '11.53', '4.31', '����쳣���������λ��']);
    wcv.AddRow(['M4CFX', '������', '2011-10-06', '13.49', '4.34', '����쳣���������λ��']);
    wcv.AddRow(['M4CFX', '������', '�仯��', '1.86', '-0.12', '����쳣���������λ��']);
    // ����м����һ��Caption��
    wcv.AddCaptionRow(['���']);
    wcv.AddRow(['M4CFX2', '���1', '2011-09-29', '11.53', '4.31', '����쳣���������λ��']);
    wcv.AddRow(['M4CFX2', '���1', '2011-10-06', '13.49', '4.34', '����쳣���������λ��']);
    wcv.AddRow(['M4CFX2', '���1', '�仯��', '1.86', '-0.12', '����쳣���������λ��']);

    wcv.AddCaptionRow(['������', '������', '����']);
    wcv.AddRow(['M4CFX3', '������', '2011-09-29', '11.53', '4.31', '����쳣���������λ��']);
    wcv.AddRow(['M4CFX3', '������', '2011-10-06', '13.49', '4.34', '����쳣���������λ��']);
    wcv.AddRow(['M4CFX3', '������', '�仯��', '1.86', '-0.12', '����쳣���������λ��']);

    htm := htm + '�۲�ɹ���<br>' + wcv.CrossGrid + '<br><hr>';

    // ���3�������ˣ������ˡ�
    // wcv.Reset;

    wcv.Free;

    // ����ҳ�����
    Page := StringReplace(Page, '@PageTitle@', '��ҳ�ж�����', [rfReplaceAll]);
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
        AddRow(['����', '�������', '�������', '�۲�����', '�۲�����', '��ע']);
        AddRow(['����', '�������', '�Ӵ�����', '���϶�', '�¶�', '��ע']);
        AddRow([today, 'X', 'X-1', 25, 24, '']);
        AddCaptionRow(['����', '����2', '����2', '����']);
        AddRow([today, 'X', 'X-2', 36.334423, 19.443, '']);
    end; // with

    htm := wcv.CrossPage; // wcv.CrossGrid
    WB_LoadHTML(wbDemo, htm);
    mmoCode.Text := htm;
    wcv.Free;
end;

end.
