object frmProfile: TfrmProfile
  Left = 212
  Top = 325
  BorderStyle = bsDialog
  Caption = #30417#27979#26029#38754#35774#32622
  ClientHeight = 263
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 60
    Height = 12
    Caption = #30417#27979#26029#38754#65306
  end
  object Label2: TLabel
    Left = 212
    Top = 12
    Width = 60
    Height = 12
    Caption = #26029#38754#27979#28857#65306
  end
  object lstProfiles: TListBox
    Left = 12
    Top = 28
    Width = 185
    Height = 225
    ItemHeight = 12
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnClick = lstProfilesClick
  end
  object Button1: TButton
    Left = 340
    Top = 28
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 340
    Top = 60
    Width = 75
    Height = 25
    Caption = #21462#28040
    Enabled = False
    ModalResult = 2
    TabOrder = 2
  end
  object chklstPoints: TCheckListBox
    Left = 208
    Top = 28
    Width = 121
    Height = 225
    OnClickCheck = chklstPointsClickCheck
    ItemHeight = 12
    Items.Strings = (
      'G1'
      'G2'
      'G3'
      'G4'
      'G5'
      'G6'
      'G7'
      'G8'
      'G9'
      'G10'
      'G11')
    TabOrder = 3
  end
  object PopupMenu1: TPopupMenu
    Left = 104
    Top = 140
    object miProfile_Rename: TMenuItem
      Caption = #37325#21629#21517#26029#38754
      OnClick = miProfile_RenameClick
    end
    object miProfile_NewProfile: TMenuItem
      Caption = #21019#24314#26032#26029#38754
      OnClick = miProfile_NewProfileClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miProfile_Delete: TMenuItem
      Caption = #21024#38500#26029#38754
      OnClick = miProfile_DeleteClick
    end
  end
end
