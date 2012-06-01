object ConnectionEditor: TConnectionEditor
  Left = 576
  Top = 584
  BorderStyle = bsDialog
  Caption = 'Edit Connection'
  ClientHeight = 221
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 185
    Top = 20
    Width = 39
    Height = 13
    Caption = 'Protocol'
    FocusControl = Protocol
  end
  object Label2: TLabel
    Left = 10
    Top = 90
    Width = 54
    Height = 13
    Caption = 'CPU-Rack:'
    FocusControl = CPURack
  end
  object Label3: TLabel
    Left = 170
    Top = 90
    Width = 21
    Height = 13
    Caption = 'Slot:'
    FocusControl = CPUSlot
  end
  object Label4: TLabel
    Left = 10
    Top = 125
    Width = 54
    Height = 13
    Caption = 'IP-Address:'
    FocusControl = IPAddress
  end
  object Label5: TLabel
    Left = 10
    Top = 160
    Width = 41
    Height = 13
    Caption = 'Timeout:'
    FocusControl = Timeout
  end
  object Label6: TLabel
    Left = 275
    Top = 90
    Width = 49
    Height = 13
    Caption = 'COM-Port:'
  end
  object Label7: TLabel
    Left = 275
    Top = 125
    Width = 56
    Height = 13
    Caption = 'MPI-Speed:'
    FocusControl = MPISpeed
  end
  object Label8: TLabel
    Left = 275
    Top = 160
    Width = 51
    Height = 13
    Caption = 'MPI-Local:'
    FocusControl = MPILocal
  end
  object Label9: TLabel
    Left = 395
    Top = 160
    Width = 40
    Height = 13
    Caption = 'Remote:'
    FocusControl = MPIRemote
  end
  object Label11: TLabel
    Left = 10
    Top = 20
    Width = 31
    Height = 13
    Caption = 'Name:'
    FocusControl = Connection
  end
  object Label12: TLabel
    Left = 10
    Top = 55
    Width = 56
    Height = 13
    Caption = 'Description:'
    FocusControl = Description
  end
  object Label10: TLabel
    Left = 145
    Top = 160
    Width = 38
    Height = 13
    Caption = 'Interval:'
    FocusControl = Interval
  end
  object Protocol: TComboBox
    Left = 240
    Top = 15
    Width = 246
    Height = 21
    Hint = 'Used protocol for the connection'
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ProtocolChange
    Items.Strings = (
      'MPI-Protocol'
      'MPI-Protocol (Andrew'#39's Version without STX)'
      'MPI-Protocol (Step7 Version)'
      'MPI-Protocol (Andrew'#39's Version with STX)'
      'PPI-Protocol'
      'ISO over TCP '
      'ISO over TCP (CP-243)'
      'IBH-Link'
      'IBH-Link (PPI)'
      'S7Onlinx.dll'
      'AS-511'
      'Deltalogic NetLink PRO')
  end
  object MPILocal: TSpinEdit
    Left = 340
    Top = 155
    Width = 46
    Height = 22
    Hint = 'Local (PC-side) MPI-Address'
    MaxValue = 127
    MinValue = 0
    TabOrder = 9
    Value = 0
  end
  object MPIRemote: TSpinEdit
    Left = 440
    Top = 155
    Width = 46
    Height = 22
    Hint = 'Remote (PLC-side) MPI-Address'
    MaxValue = 127
    MinValue = 0
    TabOrder = 10
    Value = 2
  end
  object CPURack: TSpinEdit
    Left = 75
    Top = 85
    Width = 46
    Height = 22
    Hint = 'Number of the rack containing the CPU'
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object CPUSlot: TSpinEdit
    Left = 200
    Top = 85
    Width = 46
    Height = 22
    Hint = 'Number of the slot containing the CPU'
    MaxValue = 32
    MinValue = 1
    TabOrder = 4
    Value = 2
  end
  object MPISpeed: TComboBox
    Left = 340
    Top = 120
    Width = 146
    Height = 21
    Hint = 'Connection-speed of the MPI-connection'
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 8
    Text = '187.5 kBit/s'
    Items.Strings = (
      '9.6 kBit/s'
      '19.2 kBit/s'
      '187.5 kBit/s'
      '500 kBit/s'
      '1.5 MBit/s'
      '45.45 kBit/s'
      '93.75 kBit/s')
  end
  object Timeout: TSpinEdit
    Left = 75
    Top = 155
    Width = 61
    Height = 22
    Hint = 'Timeout for the connection in milliseconds'
    Increment = 10
    MaxValue = 120000
    MinValue = 0
    TabOrder = 6
    Value = 100
  end
  object IPAddress: TEdit
    Left = 75
    Top = 120
    Width = 171
    Height = 21
    Hint = 'IP-Address of the CPU / CP or the IBH-Link at the PLC'
    TabOrder = 5
  end
  object OK: TButton
    Left = 320
    Top = 190
    Width = 76
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 11
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 410
    Top = 190
    Width = 76
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 12
  end
  object Connection: TEdit
    Left = 75
    Top = 15
    Width = 71
    Height = 21
    Hint = 'Symbolic name of the connection'
    TabOrder = 0
  end
  object Description: TEdit
    Left = 75
    Top = 50
    Width = 411
    Height = 21
    Hint = 'Long description of the connection'
    TabOrder = 2
  end
  object Interval: TSpinEdit
    Left = 185
    Top = 155
    Width = 61
    Height = 22
    Hint = 'Configured refresh-cycle for the connection in milliseconds'
    Increment = 10
    MaxValue = 60000
    MinValue = 0
    TabOrder = 7
    Value = 1000
  end
  object COMPort: TEdit
    Left = 340
    Top = 85
    Width = 141
    Height = 21
    TabOrder = 13
    Text = 'COMPort'
  end
end
