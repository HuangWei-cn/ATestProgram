object frmExpertDataFromGrid: TfrmExpertDataFromGrid
  Left = 587
  Top = 328
  BorderStyle = bsDialog
  Caption = #25968#25454#23548#20986#35774#32622
  ClientHeight = 134
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 104
    Width = 36
    Height = 13
    Caption = #25991#20214#21517
  end
  object btnSelectFile: TSpeedButton
    Left = 200
    Top = 100
    Width = 23
    Height = 22
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    OnClick = btnSelectFileClick
  end
  object optDataFormat: TRadioGroup
    Left = 8
    Top = 8
    Width = 105
    Height = 89
    Caption = #23548#20986#25968#25454#26684#24335
    ItemIndex = 0
    Items.Strings = (
      'Excel'
      'HTML'
      'CSV')
    TabOrder = 0
  end
  object optDataRange: TRadioGroup
    Left = 116
    Top = 8
    Width = 109
    Height = 89
    Caption = #25968#25454#33539#22260
    ItemIndex = 0
    Items.Strings = (
      #20840#37096#23548#20986
      #36873#20013#37096#20998)
    TabOrder = 1
  end
  object edtFileName: TEdit
    Left = 48
    Top = 100
    Width = 149
    Height = 21
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 232
    Top = 12
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 232
    Top = 44
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 4
  end
  object dlgSave: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofEnableSizing]
    Left = 260
    Top = 84
  end
end
