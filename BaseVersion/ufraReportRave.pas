unit ufraReportRave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, RpRenderRTF, RpRenderHTML, RpRenderPDF, RpRenderPrinter,
  RpRender, RpRenderCanvas, RpRenderPreview, RpBase, RpFiler, RpConBDE,
  RpCon, RpConDS, RpSystem, RpDefine, RpRave;

type
  TfraReportRave = class(TFrame)
    RvProject1: TRvProject;
    RvSystem1: TRvSystem;
    RvDataSetConnection1: TRvDataSetConnection;
    RvQueryConnection1: TRvQueryConnection;
    rvWriter: TRvNDRWriter;
    rvrPreview: TRvRenderPreview;
    rvrPrinter: TRvRenderPrinter;
    rvrPDF: TRvRenderPDF;
    rvrHTML: TRvRenderHTML;
    rvrRTF: TRvRenderRTF;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
