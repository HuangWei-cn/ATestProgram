object fraDataGrid: TfraDataGrid
  Left = 0
  Top = 0
  Width = 623
  Height = 551
  TabOrder = 0
  object dbgDatas: TDBGridEh
    Left = 0
    Top = 30
    Width = 623
    Height = 521
    Align = alClient
    AllowedOperations = []
    ColumnDefValues.Layout = tlCenter
    Flat = True
    FooterColor = 13759742
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    OddRowColor = clMoneyGreen
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghResizeWholeRightPart, dghHighlightFocus, dghClearSelection, dghFitRowHeightToText, dghAutoSortMarking, dghMultiSortMarking, dghDblClickOptimizeColWidth, dghDialogFind]
    ReadOnly = True
    RowHeight = 2
    RowLines = 1
    SortLocal = True
    STFilter.Local = True
    STFilter.Visible = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 1
    UseMultiTitle = True
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 623
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnShowDatas: TButton
      Left = 4
      Top = 0
      Width = 75
      Height = 25
      Caption = #26174#31034#25968#25454
      TabOrder = 0
    end
    object btnExpertData: TButton
      Left = 88
      Top = 0
      Width = 75
      Height = 25
      Caption = #23548#20986#25968#25454
      TabOrder = 1
    end
    object btnPrintData: TButton
      Left = 172
      Top = 0
      Width = 75
      Height = 25
      Caption = #25171#21360
      TabOrder = 2
      Visible = False
    end
  end
end
