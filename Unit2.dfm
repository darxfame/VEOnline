object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 135
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 62
    Top = 102
    Width = 129
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 233
    Height = 65
    TabOrder = 1
    object Label1: TLabel
      Left = 62
      Top = 8
      Width = 113
      Height = 13
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' COM '#1087#1086#1088#1090#1072
    end
    object ComComboBox2: TComComboBox
      Left = 127
      Top = 35
      Width = 60
      Height = 21
      ComPort = ComPort1
      ComProperty = cpBaudRate
      AutoApply = True
      Text = '57600'
      Style = csDropDownList
      ItemIndex = 12
      TabOrder = 0
    end
    object ComComboBox1: TComComboBox
      Left = 24
      Top = 35
      Width = 58
      Height = 21
      ComPort = ComPort1
      ComProperty = cpPort
      AutoApply = True
      Text = 'COM29'
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 1
    end
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 79
    Width = 209
    Height = 17
    Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1090#1086#1095#1082#1080
    TabOrder = 2
  end
  object DirDialog1: TDirDialog
    NewFolder = True
    Left = 312
    Top = 16
  end
  object ComPort1: TComPort
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
    Left = 272
    Top = 16
  end
end
