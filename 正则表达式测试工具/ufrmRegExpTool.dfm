object frmRegExprTestTool: TfrmRegExprTestTool
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #27491#21017#34920#36798#24335#27979#35797#24037#20855
  ClientHeight = 556
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 75
    Height = 16
    Caption = #27491#21017#34920#36798#24335
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 163
    Width = 60
    Height = 16
    Caption = #27979#35797#26679#26412
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 363
    Width = 60
    Height = 16
    Caption = #27979#35797#32467#26524
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object mmRegExpr: TMemo
    Left = 8
    Top = 32
    Width = 619
    Height = 113
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'mmRegExpr')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object mmSample: TMemo
    Left = 8
    Top = 180
    Width = 619
    Height = 169
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'mmSample')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object mmResults: TMemo
    Left = 8
    Top = 385
    Width = 619
    Height = 128
    Font.Charset = ANSI_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'mmResults')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button1: TButton
    Left = 552
    Top = 523
    Width = 75
    Height = 25
    Caption = #27979#35797
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 523
    Width = 89
    Height = 25
    Caption = #25335#36125#34920#36798#24335
    TabOrder = 4
    OnClick = Button2Click
  end
end
