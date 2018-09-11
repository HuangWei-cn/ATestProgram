program RegExprTestTool;

uses
  Vcl.Forms,
  ufrmRegExpTool in 'ufrmRegExpTool.pas' {frmRegExprTestTool};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRegExprTestTool, frmRegExprTestTool);
  Application.Run;
end.
