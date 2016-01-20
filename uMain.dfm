object fMain: TfMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Email Sender'
  ClientHeight = 469
  ClientWidth = 968
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object bStartStop: TButton
    Left = 535
    Top = 175
    Width = 425
    Height = 25
    Caption = 'START'
    TabOrder = 0
    OnClick = bStartStopClick
  end
  object pQueue: TPanel
    Left = 8
    Top = 8
    Width = 521
    Height = 322
    ShowCaption = False
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 62
      Height = 13
      Caption = 'Emails queue'
    end
    object Label2: TLabel
      Left = 262
      Top = 8
      Width = 53
      Height = 13
      Caption = 'Emails sent'
    end
    object mSent: TMemo
      Left = 262
      Top = 27
      Width = 248
      Height = 254
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object mQueue: TMemo
      Left = 8
      Top = 27
      Width = 248
      Height = 254
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      WordWrap = False
    end
    object bAdd: TButton
      Left = 8
      Top = 287
      Width = 121
      Height = 25
      Caption = 'Add to queue'
      TabOrder = 2
      OnClick = bAddClick
    end
    object bClear: TButton
      Left = 135
      Top = 287
      Width = 121
      Height = 25
      Caption = 'Clear queue'
      TabOrder = 3
      OnClick = bClearClick
    end
    object bClearSent: TButton
      Left = 389
      Top = 287
      Width = 121
      Height = 25
      Caption = 'Clear sent'
      TabOrder = 4
      OnClick = bClearSentClick
    end
  end
  object pProgress: TPanel
    Left = 8
    Top = 336
    Width = 521
    Height = 125
    ShowCaption = False
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 6
      Width = 42
      Height = 13
      Caption = 'Progress'
    end
    object gProgress: TGauge
      Left = 88
      Top = 6
      Width = 422
      Height = 13
      MaxValue = 0
      Progress = 0
    end
    object mLog: TMemo
      Left = 8
      Top = 25
      Width = 502
      Height = 88
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pEmail: TPanel
    Left = 535
    Top = 8
    Width = 425
    Height = 161
    ShowCaption = False
    TabOrder = 3
    object Label4: TLabel
      Left = 10
      Top = 13
      Width = 62
      Height = 13
      Caption = 'Email subject'
    end
    object Label5: TLabel
      Left = 10
      Top = 42
      Width = 47
      Height = 13
      Caption = 'Email text'
    end
    object edSubject: TEdit
      Left = 78
      Top = 10
      Width = 339
      Height = 21
      TabOrder = 0
    end
    object edText: TMemo
      Left = 78
      Top = 37
      Width = 339
      Height = 110
      ScrollBars = ssBoth
      TabOrder = 1
      WordWrap = False
    end
  end
  object pServer: TPanel
    Left = 535
    Top = 206
    Width = 425
    Height = 255
    ShowCaption = False
    TabOrder = 4
    object Label6: TLabel
      Left = 10
      Top = 13
      Width = 61
      Height = 13
      Caption = 'SMTP Server'
    end
    object Label7: TLabel
      Left = 350
      Top = 13
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object Label8: TLabel
      Left = 10
      Top = 40
      Width = 54
      Height = 13
      Caption = 'SMTP Login'
    end
    object Label9: TLabel
      Left = 218
      Top = 40
      Width = 51
      Height = 13
      Caption = 'SMTP Pass'
    end
    object Label10: TLabel
      Left = 10
      Top = 67
      Width = 49
      Height = 13
      Caption = 'Email from'
    end
    object Label11: TLabel
      Left = 218
      Top = 67
      Width = 52
      Height = 13
      Caption = 'Name from'
    end
    object Label12: TLabel
      Left = 218
      Top = 94
      Width = 128
      Height = 13
      Caption = 'Max recipients in one email'
    end
    object Label13: TLabel
      Left = 218
      Top = 121
      Width = 128
      Height = 13
      Caption = 'Delay between emails (ms)'
    end
    object Label14: TLabel
      Left = 218
      Top = 148
      Width = 52
      Height = 13
      Caption = 'Email client'
    end
    object Label15: TLabel
      Left = 10
      Top = 148
      Width = 51
      Height = 13
      Caption = 'Helo Name'
    end
    object edServer: TEdit
      Left = 78
      Top = 10
      Width = 259
      Height = 21
      TabOrder = 0
    end
    object edPort: TEdit
      Left = 376
      Top = 10
      Width = 41
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
    object edLogin: TEdit
      Left = 78
      Top = 37
      Width = 131
      Height = 21
      TabOrder = 2
    end
    object edPass: TEdit
      Left = 286
      Top = 37
      Width = 131
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object edEmailFrom: TEdit
      Left = 78
      Top = 64
      Width = 131
      Height = 21
      TabOrder = 4
    end
    object edNameFrom: TEdit
      Left = 286
      Top = 64
      Width = 131
      Height = 21
      TabOrder = 5
    end
    object cbUseSSL: TCheckBox
      Left = 10
      Top = 91
      Width = 199
      Height = 25
      Caption = 'SSL'
      TabOrder = 6
    end
    object edMaxRec: TEdit
      Left = 360
      Top = 91
      Width = 57
      Height = 21
      NumbersOnly = True
      TabOrder = 7
    end
    object edDelay: TEdit
      Left = 360
      Top = 118
      Width = 57
      Height = 21
      NumbersOnly = True
      TabOrder = 8
    end
    object edEmailClient: TEdit
      Left = 286
      Top = 145
      Width = 131
      Height = 21
      TabOrder = 9
    end
    object edHelo: TEdit
      Left = 78
      Top = 145
      Width = 131
      Height = 21
      TabOrder = 10
    end
    object cbUseHelo: TCheckBox
      Left = 10
      Top = 172
      Width = 199
      Height = 25
      Caption = 'Use Helo'
      TabOrder = 11
    end
  end
  object od: TOpenDialog
    Left = 56
    Top = 208
  end
  object smtp: TIdSMTP
    SASLMechanisms = <>
    Left = 608
    Top = 320
  end
  object ssl: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 656
    Top = 320
  end
  object mess: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 704
    Top = 320
  end
end
