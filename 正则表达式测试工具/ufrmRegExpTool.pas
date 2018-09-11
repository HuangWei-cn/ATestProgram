unit ufrmRegExpTool;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.RegularExpressions;

type
    TfrmRegExprTestTool = class(TForm)
        mmRegExpr: TMemo;
        mmSample: TMemo;
        mmResults: TMemo;
        Button1: TButton;
        Button2: TButton;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var
    frmRegExprTestTool: TfrmRegExprTestTool;

implementation

{$R *.dfm}


procedure TfrmRegExprTestTool.Button1Click(Sender: TObject);
var i:integer;
begin
    mmResults.Clear;
    for i := 0 to mmSample.Lines.Count -1 do
    begin
        if TRegEx.IsMatch(mmSample.Lines.Strings[i], mmRegExpr.Text) then
            mmResults.Lines.Add(Format('OK    : 第%d行满足表达式',[i]))
        else
            mmResults.Lines.Add(Format('Failed: 第%d行不满足表达式',[i]));
    end;
end;

procedure TfrmRegExprTestTool.Button2Click(Sender: TObject);
begin
    mmRegExpr.CopyToClipboard;
end;

procedure TfrmRegExprTestTool.FormCreate(Sender: TObject);
begin
    mmRegExpr.Text := '';
    mmSample.Text := '';
    mmResults.Text := '';
end;

end.
