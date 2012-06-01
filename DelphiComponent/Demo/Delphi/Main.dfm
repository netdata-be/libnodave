object MainForm: TMainForm
  Left = 437
  Top = 243
  Caption = 'TNoDave Test-Utility'
  ClientHeight = 310
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000008484808888888787AFE8A8E0000000404
    848484808888878787E7F8E080000044484848080808888878787E8708000040
    448480808080808088878FA8E080044446404000000000080808887E87000464
    646006867676767680808887A78004464608E7E7E7E7E7E76808080870700464
    60E7449988884047EE8080808E000646074498787870040690E8080808700040
    8498878A8A6040066647E60080800406798878A6A8300408A6690E6008000040
    4887876A8B0060038AF690E6008004049888A6A8A3044400A8EF690E08000044
    48878A8AB0004040BA87E69760800000948878AB30046400A8A6FF69E0000040
    48878A6AB04466FFBEFFFEF070000000848878AB30066400ABAFFFE876000000
    4948878AB0406040BA8AEFF80E000000008488A830044403A8A6FEA607000440
    000948484000600A8A8FE666070000444000948480044008A8F6A6A607000000
    4400064600004062828262600000080044544009600400282626666000000680
    0044544000000000606064000000086800084544440000050505050000500786
    86008453544444000000000045400F78686008856545404656544545584007F7
    8686008686745555555656564480087878686000686785855558544844400687
    8786868000005757545787888840000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 291
    Width = 485
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 269
    Top = 0
    Width = 216
    Height = 291
    Align = alRight
    TabOrder = 1
    object Label1: TLabel
      Left = 20
      Top = 50
      Width = 18
      Height = 13
      Caption = 'DB:'
      FocusControl = SpinEdit1
    end
    object Label2: TLabel
      Left = 20
      Top = 140
      Width = 31
      Height = 13
      Caption = 'Count:'
      FocusControl = SpinEdit2
    end
    object Label3: TLabel
      Left = 20
      Top = 80
      Width = 27
      Height = 13
      Caption = 'Type:'
      FocusControl = ComboBox1
    end
    object Label4: TLabel
      Left = 20
      Top = 20
      Width = 25
      Height = 13
      Caption = 'Area:'
      FocusControl = ComboBox2
    end
    object Label5: TLabel
      Left = 20
      Top = 110
      Width = 31
      Height = 13
      Caption = 'Offset:'
      FocusControl = SpinEdit3
    end
    object StaticText1: TStaticText
      Left = 20
      Top = 240
      Width = 181
      Height = 17
      Hint = 'Display of the connection-status or speed.'
      Alignment = taCenter
      AutoSize = False
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'not Connected !'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
    end
    object Button1: TButton
      Left = 20
      Top = 170
      Width = 181
      Height = 25
      Hint = 'Press to accept the values above.'
      Caption = 'Accept'
      Default = True
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 125
      Top = 205
      Width = 76
      Height = 25
      Hint = 'Open the SZL-Viewer'
      Caption = 'SZL-Viewer'
      TabOrder = 2
      OnClick = Button2Click
    end
    object ComboBox1: TComboBox
      Left = 125
      Top = 75
      Width = 76
      Height = 21
      Hint = 'Select the datatype from the list.'
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'Byte'
      Items.Strings = (
        'Byte'
        'Word'
        'Int'
        'DWord'
        'DInt'
        'Real')
    end
    object Button3: TButton
      Left = 20
      Top = 205
      Width = 71
      Height = 25
      Hint = 'Start / Stop the communication.'
      Caption = 'Start'
      TabOrder = 4
      OnClick = Button3Click
    end
    object ComboBox2: TComboBox
      Left = 80
      Top = 15
      Width = 121
      Height = 21
      Hint = 'Select the PLC-area from the list.'
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 7
      TabOrder = 5
      Text = 'Datablock'
      Items.Strings = (
        'System-Info'
        'System-Flags'
        'analog Inputs (CPU 200)'
        'analog Outputs (CPU 200)'
        'Inputs'
        'Outputs'
        'Flags'
        'Datablock'
        'Instance Data'
        'Local Data'
        'unknown Area'
        'Counter'
        'Timer'
        'PEW/PAW')
    end
    object ProgressBar1: TProgressBar
      Left = 15
      Top = 265
      Width = 186
      Height = 16
      Max = 10
      Step = 1
      TabOrder = 6
    end
    object SpinEdit1: TSpinEdit
      Left = 125
      Top = 45
      Width = 76
      Height = 22
      Hint = 'Set the number of the DB.'
      MaxValue = 9999
      MinValue = 1
      TabOrder = 7
      Value = 1
    end
    object SpinEdit2: TSpinEdit
      Left = 125
      Top = 135
      Width = 76
      Height = 22
      Hint = 'Set the number of addresses to process.'
      MaxValue = 999
      MinValue = 1
      TabOrder = 8
      Value = 1
    end
    object SpinEdit3: TSpinEdit
      Left = 125
      Top = 105
      Width = 76
      Height = 22
      Hint = 'Set the address-offset.'
      MaxValue = 9000
      MinValue = 0
      TabOrder = 9
      Value = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 269
    Height = 291
    Align = alClient
    TabOrder = 2
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 267
      Height = 40
      Align = alTop
      TabOrder = 0
      object Label6: TLabel
        Left = 10
        Top = 15
        Width = 57
        Height = 13
        Caption = 'Connection:'
        FocusControl = ComboBox3
      end
      object ComboBox3: TComboBox
        Left = 80
        Top = 10
        Width = 101
        Height = 21
        Hint = 'Select a connection from the list.'
        Style = csDropDownList
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnSelect = ComboBox3Select
      end
      object Button4: TButton
        Left = 190
        Top = 10
        Width = 31
        Height = 21
        Hint = 'Edit the parameters of the selected connection.'
        Caption = 'Edit'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 225
        Top = 10
        Width = 31
        Height = 21
        Hint = 'Create a new connection and edit the parameters .'
        Caption = 'New'
        TabOrder = 2
        OnClick = Button5Click
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 41
      Width = 267
      Height = 249
      Align = alClient
      BorderWidth = 8
      TabOrder = 1
      object ListBox1: TListBox
        Left = 9
        Top = 9
        Width = 249
        Height = 231
        Hint = 
          'Display of the selected values.'#13#10'Double-click on an entry to cha' +
          'nge the value.'
        Align = alClient
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 0
        OnDblClick = ListBox1DblClick
      end
    end
  end
  object NoDave: TNoDave
    Active = False
    Area = daveDB
    BufLen = 16
    BufOffs = 0
    COMPort = 'COM1:'
    COMSpeed = daveComSpeed38_4k
    CPURack = 0
    CPUSlot = 2
    DBNumber = 1
    DebugOptions = [daveDebugInitAdapter, daveDebugConnect, daveDebugExchange, daveDebugPDU, daveDebugPrintErrors]
    Interval = 1000
    IntfName = 'D11'
    IntfTimeout = 100000
    IPAddress = '172.20.90.11'
    IPPort = 102
    MPILocal = 0
    MPIRemote = 2
    MPISpeed = daveSpeed187k
    OnConnect = NoDaveConnect
    OnDisconnect = NoDaveDisconnect
    OnError = NoDaveError
    OnRead = NoDaveRead
    Protocol = daveProtoISOTCP
    Left = 335
    Top = 40
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 335
    Top = 85
  end
end
