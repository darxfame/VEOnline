object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'VEOnline'
  ClientHeight = 530
  ClientWidth = 1012
  Color = clBtnFace
  Constraints.MinHeight = 530
  Constraints.MinWidth = 888
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ComLed1: TComLed
    Left = 8
    Top = 449
    Width = 25
    Height = 25
    ComPort = ComPort
    LedSignal = lsConn
    Kind = lkRedLight
  end
  object Label5: TLabel
    Left = 886
    Top = 168
    Width = 53
    Height = 13
    Caption = #1054#1073#1086#1088#1086#1090#1099': '
  end
  object Label6: TLabel
    Left = 886
    Top = 187
    Width = 62
    Height = 13
    Caption = #1050#1086#1088#1088#1077#1082#1094#1080#1103': '
  end
  object StringGrid2: TStringGrid
    Left = 7
    Top = 8
    Width = 873
    Height = 434
    ColCount = 17
    DefaultColWidth = 50
    Enabled = False
    RowCount = 17
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = StringGrid2DrawCell
    OnMouseDown = StringGrid2MouseDown
    OnMouseMove = StringGrid2MouseMove
    OnSelectCell = StringGrid2SelectCell
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object Panel1: TPanel
    Left = 48
    Top = 448
    Width = 177
    Height = 73
    BevelKind = bkTile
    TabOrder = 1
    object Label1: TLabel
      Left = 34
      Top = 5
      Width = 105
      Height = 13
      Caption = #1053#1072#1095#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object Edit1: TEdit
      Left = 8
      Top = 21
      Width = 73
      Height = 21
      TabOrder = 0
      Text = '0.65'
    end
    object Button1: TButton
      Left = 8
      Top = 45
      Width = 161
      Height = 20
      Caption = #1055#1077#1088#1077#1079#1072#1087#1080#1089#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 96
      Top = 21
      Width = 73
      Height = 20
      Caption = #1056#1072#1089#1082#1088#1072#1089#1080#1090#1100
      TabOrder = 2
      OnClick = Button4Click
    end
  end
  object Panel2: TPanel
    Left = 304
    Top = 448
    Width = 257
    Height = 74
    BevelKind = bkTile
    TabOrder = 2
    object Label2: TLabel
      Left = 62
      Top = 6
      Width = 120
      Height = 13
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077' '#1082' Secu-3t'
    end
    object Button2: TButton
      Left = 24
      Top = 25
      Width = 89
      Height = 37
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 134
      Top = 25
      Width = 91
      Height = 37
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100#1089#1103
      Enabled = False
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object Panel3: TPanel
    Left = 622
    Top = 448
    Width = 251
    Height = 74
    BevelKind = bkTile
    TabOrder = 3
    object Label3: TLabel
      Left = 48
      Top = 6
      Width = 138
      Height = 13
      Caption = #1047#1072#1087#1091#1089#1082' '#1080' '#1072#1085#1072#1083#1080#1079' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    end
    object N10: TButton
      Left = 6
      Top = 25
      Width = 105
      Height = 37
      Caption = #1047#1072#1087#1091#1089#1082
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = N10Click
    end
    object N3DPlot2: TButton
      Left = 134
      Top = 25
      Width = 105
      Height = 37
      Caption = #1043#1088#1072#1092#1080#1082' VE'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = N3DPlot1Click
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 478
    Width = 25
    Height = 39
    DoubleBuffered = True
    Glyph.Data = {
      CE040000424DCE04000000000000360000002800000012000000150000000100
      18000000000098040000000000000000000000000000000000008D847C68615C
      4D423D5249414C453E4F4942554A43554942534942544842544A43554A445548
      42534A43524C44504942524C4478706800005D5955656260786E6F737070676F
      6D676F6C6F6A6A6F67676E6C6B70696A6A6A696367666F6767726A6B67676769
      6A685B5A574D454100005C5A5AEAEAEAEAEAEAEAEAEA464646808080EAEAEAEA
      EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA464646808080EAEAEA595D58
      00006C6A69EAEAEAEAEAEAEAEAEA464646808080EAEAEAEAEAEAEAEAEAEAEAEA
      EAEAEAEAEAEAEAEAEAEAEAEA464646808080EAEAEA6969650000656362EAEAEA
      EAEAEAEAEAEA464646808080EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
      EAEAEAEA464646808080EAEAEA6F646200006C69688080808080808080808080
      8080808080808080808080808080808080808080808080808080808080808080
      80808080806A686500006B696846464646464646464646464680808046464646
      4646464646464646464646464646464646464646464646808080464646686867
      00006A6867EAEAEAEAEAEAEAEAEA464646808080EAEAEAEAEAEAFF0000EAEAEA
      EAEAEAFF0000EAEAEAEAEAEA464646808080EAEAEA6C68680000706E6DEAEAEA
      EAEAEAEAEAEA464646808080EAEAEAFF0000FF0000EAEAEAEAEAEAFF0000FF00
      00EAEAEA464646808080EAEAEA6E6B6A00006B6968EAEAEAEAEAEAEAEAEA4646
      46808080FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000046464680
      8080EAEAEA6E6B6A0000686665EAEAEAEAEAEAEAEAEA464646808080EAEAEAFF
      0000FF0000EAEAEAEAEAEAFF0000FF0000EAEAEA464646808080EAEAEA6E6B6A
      00006E6C6BEAEAEAEAEAEAEAEAEA464646808080EAEAEAEAEAEAFF0000EAEAEA
      EAEAEAFF0000EAEAEAEAEAEA464646808080EAEAEA726E6D0000716F6FEAEAEA
      EAEAEAEAEAEA464646808080EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
      EAEAEAEA464646808080EAEAEA746F6E00006C6969EAEAEAEAEAEAEAEAEA4646
      46808080EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA46464680
      8080EAEAEA726E6D00006B696980808080808080808080808080808080808080
      8080808080808080808080808080808080808080808080808080808080727070
      00006C6A6A464646464646464646464646808080464646464646464646464646
      46464646464646464646464646464680808046464674727200006D6B6AEAEAEA
      EAEAEAEAEAEA464646808080EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
      EAEAEAEA464646808080EAEAEA7572740000706E6EEAEAEAEAEAEAEAEAEA4646
      46808080EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA46464680
      8080EAEAEA7472730000706E6EEAEAEAEAEAEAEAEAEA464646808080EAEAEAEA
      EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA464646808080EAEAEA757575
      00006F6E6EEAEAEAEAEAEAEAEAEA464646808080EAEAEAEAEAEAEAEAEAEAEAEA
      EAEAEAEAEAEAEAEAEAEAEAEA464646808080EAEAEA868685000063615FA1A09F
      B2B3B1B2B4B1B5B7B6B6B6B7B7B5B8B7B4B7B7B3B5B7B4B5B7B4B5B6B3B4B6B3
      B4B4B3B5AEB1B2ACAFB1A7A9AB6F6C680000}
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object Panel4: TPanel
    Left = 886
    Top = 8
    Width = 123
    Height = 146
    BevelInner = bvLowered
    TabOrder = 5
    object Label4: TLabel
      Left = 40
      Top = 10
      Width = 49
      Height = 13
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
    end
    object Button5: TButton
      Left = 24
      Top = 29
      Width = 75
      Height = 25
      Caption = 'Save VE'
      TabOrder = 0
      OnClick = EEPROM1Click
    end
    object Button6: TButton
      Left = 8
      Top = 60
      Width = 105
      Height = 25
      Caption = 'Save fixed Points'
      TabOrder = 1
      OnClick = Button6Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 1160
    Top = 8
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N12: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' VE.txt'
        OnClick = N12Click
      end
      object VEtxt1: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' VE.txt'
        OnClick = VEtxt1Click
      end
      object N8: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N8Click
      end
    end
    object N3DPlot1: TMenuItem
      Caption = #1043#1088#1072#1092#1080#1082' VE'
      Enabled = False
      OnClick = N3DPlot1Click
    end
    object N9: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnClick = N9Click
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
    object N11: TMenuItem
      Caption = ' |'
      Enabled = False
    end
    object Log1: TMenuItem
      Caption = 'Status:'
      Enabled = False
      Hint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1090#1082#1088#1099#1090#1086#1075#1086' Log '#1092#1072#1081#1083#1072
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 1264
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Left = 1216
    Top = 8
  end
  object OpenDialog2: TOpenDialog
    Left = 1264
    Top = 56
  end
  object OpenDialog3: TOpenDialog
    Left = 1264
    Top = 112
  end
  object SaveDialog2: TSaveDialog
    Left = 1216
    Top = 56
  end
  object ComDataPacket1: TComDataPacket
    ComPort = ComPort
    IncludeStrings = True
    MaxBufferSize = 8192
    OnPacket = ComDataPacket1Packet
    Left = 1208
    Top = 120
  end
  object ComPort: TComPort
    BaudRate = br57600
    Port = 'COM11'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    Buffer.InputSize = 8192
    Buffer.OutputSize = 8192
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrEnable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = False
    Left = 1152
    Top = 64
  end
end
