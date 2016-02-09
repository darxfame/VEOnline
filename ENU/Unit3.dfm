object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Schedule filling ratio of the engine'
  ClientHeight = 507
  ClientWidth = 994
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
  object Label1: TLabel
    Left = 8
    Top = 454
    Width = 70
    Height = 24
    Caption = 'Consumption:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 114
    Top = 454
    Width = 11
    Height = 24
    Caption = '1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object NLabMag: TNumLab
    Left = 857
    Top = 133
    Width = 133
    Height = 22
    Alignment = taCenter
    ColorLabBakG = clSilver
    ColorLabText = clBlack
    ColorOutBakG = clBtnFace
    ColorOutText = clBlack
    ColorScheme = csBWG
    Comma = False
    DisplayType = dtFixP
    DTFormat = 'mmm-dd, yyyy'
    Empty = False
    ForcePlusSign = False
    FrameStyle = fsLowered
    LabelWidth = 61
    LeftSpace = 66
    LeftText = 'Size'
    LeftTextAlignment = taRightJustify
    OverflowIndicator = '*********'
    Precision = 3
    RightTextAlignment = taLeftJustify
    StateText = 'undefined'
    Transparent = False
    Value = 1
  end
  object Chart1: TChart
    Left = 26
    Top = 8
    Width = 825
    Height = 434
    AllowPanning = pmNone
    Legend.ColorWidth = 15
    Legend.Symbol.Width = 15
    Legend.TopPos = 4
    Legend.Visible = False
    Title.Text.Strings = (
      'TChart')
    BottomAxis.LogarithmicBase = 2.718281828459050000
    View3D = False
    TabOrder = 0
    OnMouseDown = Chart1MouseDown
    OnMouseMove = Chart1MouseMove
    OnMouseUp = Chart1MouseUp
    PrintMargins = (
      15
      17
      15
      17)
    ColorPaletteIndex = 11
    object Series2: TLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Clip = True
      Marks.Margins.Left = 10
      Marks.Margins.Top = 0
      Marks.Margins.Right = 16
      Marks.Shadow.Color = 8487297
      Marks.Shadow.Visible = False
      Marks.Style = smsPointIndex
      Marks.Symbol.Emboss.Smooth = False
      Marks.Symbol.Shadow.HorizSize = 0
      Marks.Symbol.Shadow.Smooth = False
      Marks.Symbol.Shadow.VertSize = 0
      Marks.Symbol.Shadow.Visible = False
      Marks.Visible = True
      LinePen.Color = 13770496
      Pointer.Brush.Gradient.EndColor = 13770496
      Pointer.Gradient.EndColor = 13770496
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      TreatNulls = tnIgnore
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series1: TLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Clip = True
      Marks.Margins.Left = 10
      Marks.Margins.Top = 0
      Marks.Margins.Right = 16
      Marks.Shadow.Color = 8487297
      Marks.Shadow.Visible = False
      Marks.Style = smsPointIndex
      Marks.Symbol.Emboss.Smooth = False
      Marks.Symbol.Shadow.HorizSize = 0
      Marks.Symbol.Shadow.Smooth = False
      Marks.Symbol.Shadow.VertSize = 0
      Marks.Symbol.Shadow.Visible = False
      Marks.Visible = True
      SeriesColor = 13770496
      LinePen.Color = 13770496
      Pointer.Brush.Gradient.EndColor = 13770496
      Pointer.Gradient.EndColor = 13770496
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      TreatNulls = tnIgnore
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object rash1: TScrollBar
    Left = 152
    Top = 448
    Width = 617
    Height = 38
    DragKind = dkDock
    Max = 16
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 1
    OnChange = rash1Change
  end
  object Button1: TButton
    Left = 857
    Top = 417
    Width = 75
    Height = 25
    Caption = 'Plot'
    TabOrder = 2
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 881
    Top = 8
    Width = 69
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 881
    Top = 48
    Width = 97
    Height = 17
    Caption = 'In profile'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Help: TButton
    Left = 881
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 5
    OnClick = HelpClick
  end
  object CheckBox2: TCheckBox
    Left = 881
    Top = 71
    Width = 97
    Height = 17
    Caption = '3D View'
    TabOrder = 6
    OnClick = CheckBox2Click
  end
  object ScrBarMagnif: TScrollBar
    Left = 858
    Top = 159
    Width = 129
    Height = 20
    Max = 200
    PageSize = 0
    Position = 100
    TabOrder = 7
    OnChange = ScrBarMagnifChange
  end
  object Plot3D1: TPlot3D
    Left = 41
    Top = 15
    Width = 793
    Height = 410
    AutoCenter = True
    Visible = False
    BoundBoxStyle = bbFaces
    CaptionX = 'X'
    CaptionY = 'Y'
    CaptionZ = 'Z'
    CentX = 396
    CentY = 205
    ColorBakGnd = clWindow
    ColorCodeAvg = True
    ColorCubeFrame = 4210752
    ColorCubeHidLin = 11579568
    ColorCubeFaceLow = clSilver
    ColorCubeFaceHigh = 16707310
    ColorXCoords = clRed
    ColorYCoords = clBlue
    ColorZCoords = clBlack
    ColorMesh = clBlack
    ColorHigh = clYellow
    ColorMid = clBlue
    ColorLow = clBlack
    ColorScaleHigh = 100
    ColorCodingMode = ccmTwoColors
    ColorScheme = csSystem
    DecPlaceX = 1
    DecPlaceY = 1
    DecPlaceZ = 1
    FrameStyle = fsSimple
    LabDistX = 40
    LabDistY = 40
    LabDistZ = 20
    MeshVisible = True
    MeshKind = mkMesh
    Magnification = 1
    MouseAction = maRotate
    MinTickX = 3
    MinTickY = 3
    MinTickZ = 3
    RangeXLow = -1
    RangeYLow = -1
    RangeZLow = -0.500000000000000000
    RangeXHigh = 16
    RangeYHigh = 1
    RangeZHigh = 1.200000000000000000
    ScaleFactX = 1
    ScaleFactY = 1
    ScaleFactZ = 1
    ViewAngleX = 60
    ViewAngleZ = 15
    VisibleXCoords = True
    VisibleYCoords = True
    VisibleZCoords = True
    OnBeforeRenderPolygon = Plot3D1BeforeRenderPolygon
  end
  object datab: TButton
    Left = 857
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Plot'
    TabOrder = 9
    Visible = False
    OnClick = databClick
  end
  object Panel1: TPanel
    Left = 857
    Top = 185
    Width = 133
    Height = 56
    TabOrder = 10
    object Label3: TLabel
      Left = 32
      Top = 8
      Width = 68
      Height = 13
      Caption = 'Smooth'
    end
    object Button5: TButton
      Left = 86
      Top = 25
      Width = 25
      Height = 25
      Caption = 'x7'
      TabOrder = 0
      OnClick = Button5Click
    end
    object Button4: TButton
      Left = 55
      Top = 25
      Width = 25
      Height = 25
      Caption = 'x5'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button3: TButton
      Left = 24
      Top = 25
      Width = 25
      Height = 25
      Caption = 'x3'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 857
    Top = 247
    Width = 133
    Height = 82
    TabOrder = 11
    object Label4: TLabel
      Left = 27
      Top = 6
      Width = 86
      Height = 13
      Caption = 'Hide Chart'
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 25
      Width = 113
      Height = 17
      Caption = 'Source EEPROM'
      TabOrder = 0
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Changed'
      TabOrder = 1
      OnClick = CheckBox4Click
    end
  end
end
