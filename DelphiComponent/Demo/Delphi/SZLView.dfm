object SZLViewer: TSZLViewer
  Left = 716
  Top = 366
  Width = 567
  Height = 315
  Caption = 'SZL-Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 559
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 15
      Width = 28
      Height = 13
      Caption = 'Class:'
    end
    object Label2: TLabel
      Left = 140
      Top = 15
      Width = 19
      Height = 13
      Caption = 'List:'
    end
    object Label3: TLabel
      Left = 235
      Top = 15
      Width = 22
      Height = 13
      Caption = 'Part:'
    end
    object Label4: TLabel
      Left = 330
      Top = 15
      Width = 29
      Height = 13
      Caption = 'Index:'
    end
    object SZLClass: TComboBox
      Left = 65
      Top = 10
      Width = 56
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'CPU'
      Items.Strings = (
        'CPU'
        'CP'
        'FM'
        'IM')
    end
    object SZLList: TSpinEdit
      Left = 170
      Top = 10
      Width = 46
      Height = 22
      MaxValue = 255
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SZLPart: TSpinEdit
      Left = 265
      Top = 10
      Width = 46
      Height = 22
      MaxValue = 15
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object SZLIndex: TSpinEdit
      Left = 365
      Top = 10
      Width = 56
      Height = 22
      MaxValue = 65535
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object Button1: TButton
      Left = 455
      Top = 10
      Width = 75
      Height = 21
      Caption = 'Request'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 559
    Height = 247
    Align = alClient
    BorderWidth = 5
    TabOrder = 1
    object SZLGrid: TStringGrid
      Left = 6
      Top = 6
      Width = 547
      Height = 235
      Align = alClient
      ColCount = 1
      DefaultColWidth = 50
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 0
    end
  end
end
