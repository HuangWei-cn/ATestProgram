object fraReportRave: TfraReportRave
  Left = 0
  Top = 0
  Width = 520
  Height = 457
  TabOrder = 0
  object RvProject1: TRvProject
    Engine = rvWriter
    Left = 88
    Top = 12
  end
  object RvSystem1: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 180
    Top = 80
  end
  object RvDataSetConnection1: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    Left = 88
    Top = 160
  end
  object RvQueryConnection1: TRvQueryConnection
    RuntimeVisibility = rtDeveloper
    Left = 160
    Top = 176
  end
  object rvWriter: TRvNDRWriter
    StatusFormat = 'Printing page %p'
    UnitsFactor = 1.000000000000000000
    Title = 'Rave Report'
    Orientation = poPortrait
    ScaleX = 100.000000000000000000
    ScaleY = 100.000000000000000000
    Left = 100
    Top = 264
  end
  object rvrPreview: TRvRenderPreview
    DisplayName = 'RPRender'
    ZoomFactor = 100.000000000000000000
    RulerType = rtBothCm
    ShadowDepth = 0
    Left = 204
    Top = 264
  end
  object rvrPrinter: TRvRenderPrinter
    DisplayName = 'RPRender'
    Left = 148
    Top = 264
  end
  object rvrPDF: TRvRenderPDF
    DisplayName = 'Adobe Acrobat (PDF)'
    FileExtension = '*.pdf'
    EmbedFonts = False
    ImageQuality = 95
    MetafileDPI = 300
    FontEncoding = feWinAnsiEncoding
    DocInfo.Creator = 'Rave (http://www.nevrona.com/rave)'
    DocInfo.Producer = 'Nevrona Designs'
    Left = 144
    Top = 328
  end
  object rvrHTML: TRvRenderHTML
    DisplayName = 'Web Page (HTML)'
    FileExtension = '*.html;*.htm'
    ServerMode = False
    Left = 196
    Top = 328
  end
  object rvrRTF: TRvRenderRTF
    DisplayName = 'Rich Text Format (RTF)'
    FileExtension = '*.rtf'
    Left = 244
    Top = 328
  end
end
