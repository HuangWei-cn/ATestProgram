program pWebGridDemo;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  uWBLoadHTML in 'uWBLoadHTML.pas',
  uWebGridCross in 'uWebGridCross.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
