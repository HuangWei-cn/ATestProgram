unit ufrmExpertDataFromDBGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DBGridEhImpExp;

type
  TfrmExpertDataFromGrid = class(TForm)
    optDataFormat: TRadioGroup;
    optDataRange: TRadioGroup;
    Label1: TLabel;
    edtFileName: TEdit;
    btnSelectFile: TSpeedButton;
    btnOK: TButton;
    btnCancel: TButton;
    dlgSave: TSaveDialog;
    procedure btnSelectFileClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExpertDataFromGrid: TfrmExpertDataFromGrid;

implementation
uses
    Unit1;

{$R *.dfm}

procedure TfrmExpertDataFromGrid.btnSelectFileClick(Sender: TObject);
begin
        case optDataFormat.ItemIndex of    //
          0: begin
                dlgSave.Filter := 'Excel文件 (*.xls)|*.xls';
                dlgSave.DefaultExt := 'xls';
             end;
          1: begin
                dlgSave.Filter := 'HTML文件 (*.htm)|*.htm';
                dlgSave.DefaultExt := 'htm';
             end;
          2: begin
                dlgSave.Filter := 'CSV文件 (*.csv)|*.csv';
                dlgSave.DefaultExt := 'cvs';
             end;
        end;    // case
        if dlgSave.Execute then
            Self.edtFileName.Text := dlgSave.FileName;
end;

procedure TfrmExpertDataFromGrid.btnOKClick(Sender: TObject);
begin
        {  }
        if Trim(edtFileName.Text) = '' then
        begin
            MessageDlg('请输入导出数据的文件名。', mtWarning, [mbOK], 0);
            //Self.ModalResult := ;
            Exit;
        end;

        case optDataFormat.ItemIndex of    //
          0: SaveDBGridEhToExportFile( TDBGridEhExportAsXLS, frmTest.dbgDatas, edtFileName.Text,True);
          1: SaveDBGridEhToExportFile( TDBGridEhExportAsHTML, frmTest.dbgDatas, edtFileName.Text,True);
          2: SaveDBGridEhToExportFile( TDBGridEhExportAsCsv, frmTest.dbgDatas, edtFileName.Text,True);
        end;    // case

        self.ModalResult := mrOK;
end;

end.
