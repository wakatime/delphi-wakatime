object WakaTimeSettingsForm: TWakaTimeSettingsForm
  Left = 87
  Top = 251
  BorderStyle = bsDialog
  Caption = 'WakaTime Settings'
  ClientHeight = 143
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 38
    Height = 13
    Caption = 'API Key'
  end
  object ButtonOk: TBitBtn
    Left = 288
    Top = 96
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
  end
  object ButtonCancel: TBitBtn
    Left = 208
    Top = 96
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object EditApiKey: TEdit
    Left = 16
    Top = 40
    Width = 345
    Height = 21
    TabOrder = 2
  end
  object CheckBoxDebugMode: TCheckBox
    Left = 16
    Top = 72
    Width = 145
    Height = 17
    Caption = 'Debug Mode?'
    TabOrder = 3
  end
end
