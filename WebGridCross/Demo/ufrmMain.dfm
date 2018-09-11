object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demo'
  ClientHeight = 457
  ClientWidth = 623
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object stat1: TStatusBar
    Left = 0
    Top = 438
    Width = 623
    Height = 19
    Panels = <>
  end
  object pnl1: TPanel
    Left = 503
    Top = 0
    Width = 120
    Height = 438
    Align = alRight
    BevelOuter = bvLowered
    TabOrder = 1
    object btnSimpleGrid: TButton
      Left = 7
      Top = 8
      Width = 106
      Height = 25
      Caption = #31616#21333#26647#23376
      TabOrder = 0
      OnClick = btnSimpleGridClick
    end
    object btnMultiGrid: TButton
      Left = 6
      Top = 39
      Width = 107
      Height = 25
      Caption = #22810#34920
      TabOrder = 1
      OnClick = btnMultiGridClick
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 438
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl2'
    TabOrder = 2
    object spl1: TSplitter
      Left = 0
      Top = 241
      Width = 503
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      Beveled = True
      ExplicitWidth = 197
    end
    object wbDemo: TWebBrowser
      Left = 0
      Top = 0
      Width = 503
      Height = 241
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000FD330000E81800000100000001020000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object mmoCode: TMemo
      Left = 0
      Top = 244
      Width = 503
      Height = 194
      Align = alBottom
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'mmoCode')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
      WordWrap = False
    end
  end
end
