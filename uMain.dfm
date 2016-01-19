object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Email Sender'
  ClientHeight = 469
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Emails queue'
  end
  object Label2: TLabel
    Left = 311
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Emails sent'
  end
  object mQueue: TMemo
    Left = 8
    Top = 27
    Width = 297
    Height = 318
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object Memo1: TMemo
    Left = 311
    Top = 27
    Width = 297
    Height = 318
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
end
