// Editor.pas (Part of NoDaveDemo.dpr)
//
// A program demonstrating the functionality of the TNoDave component.
// This unit implements the editor-form for a connection.
//
// (C) 2005 Gebr. Schmid GmbH + Co., Freudenstadt, Germany
//
// Author: Axel Kinting (akinting@schmid-online.de)
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

unit Editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, IniFiles, ComCtrls;

type
  TConnectionEditor = class(TForm)
    Protocol: TComboBox;
    MPILocal: TSpinEdit;
    MPIRemote: TSpinEdit;
    CPURack: TSpinEdit;
    CPUSlot: TSpinEdit;
    MPISpeed: TComboBox;
    Timeout: TSpinEdit;
    IPAddress: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OK: TButton;
    Cancel: TButton;
    Connection: TEdit;
    Description: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Interval: TSpinEdit;
    Label10: TLabel;
    COMPort: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ProtocolChange(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    IniFile: TIniFile;
    procedure DelConnection(Name: String);
    procedure SetConnection(Name: String);
  end;

var
  ConnectionEditor: TConnectionEditor;

implementation

{$R *.dfm}

procedure TConnectionEditor.DelConnection(Name: String);
begin
  If Name <> '' then
  begin
    IniFile.DeleteKey('Connections', Name);
    IniFile.EraseSection(Name);
  end;
end;

procedure TConnectionEditor.SetConnection(Name: String);
begin
  Connection.Text:=Name;
  If Name = '' then
  begin
    Description.Text:='';
    CPURack.Value:=0;
    CPUSlot.Value:=2;
    COMPort.Text:='';
    IPAddress.Text:='';
    Timeout.Value:=100;
    Interval.Value:=1000;
    MPISpeed.ItemIndex:=2;
    MPILocal.Value:=1;
    MPIRemote.Value:=2;
  end else begin
    Description.Text:=IniFile.ReadString('Connections', Name, '');
    Protocol.ItemIndex:=IniFile.ReadInteger(Name, 'Protocol', 3);
    CPURack.Value:=IniFile.ReadInteger(Name, 'CPURack', 0);
    CPUSlot.Value:=IniFile.ReadInteger(Name, 'CPUSlot', 2);
    COMPort.Text:=IniFile.ReadString(Name, 'COMPort', '');
    IPAddress.Text:=IniFile.ReadString(Name, 'IPAddress', '');
    Timeout.Value:=IniFile.ReadInteger(Name, 'Timeout', 100000) div 1000;
    Interval.Value:=IniFile.ReadInteger(Name, 'Interval', 1000);
    MPISpeed.ItemIndex:=IniFile.ReadInteger(Name, 'MPISpeed', 2);
    MPILocal.Value:=IniFile.ReadInteger(Name, 'MPILocal', 1);
    MPIRemote.Value:=IniFile.ReadInteger(Name, 'MPIRemote', 2);
  end;
  Connection.Enabled:=(Name = '');
  ProtocolChange(Self);
end;

procedure TConnectionEditor.FormCreate(Sender: TObject);
begin
  IniFile:=TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TConnectionEditor.ProtocolChange(Sender: TObject);
begin
  COMPort.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,9,10]);
  IPAddress.Enabled:=(Protocol.ItemIndex in [5,6,7,8,11]);
  Timeout.Enabled:=(Protocol.ItemIndex in [5,6,7,8,9,11]);
  MPISpeed.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,7,8,11]);
  MPILocal.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,7,8,11]);
  MPIRemote.Enabled:=(Protocol.ItemIndex in [0,1,2,3,4,7,8,9,11]);
end;

procedure TConnectionEditor.OKClick(Sender: TObject);
var
  Name: String;
begin
  Name:=Connection.Text;
  If Name <> '' then
  begin
    IniFile.WriteString('Connections', Name, Description.Text);
    IniFile.WriteInteger(Name, 'Protocol', Protocol.ItemIndex);
    IniFile.WriteInteger(Name, 'CPURack', CPURack.Value);
    IniFile.WriteInteger(Name, 'CPUSlot', CPUSlot.Value);
    IniFile.WriteString(Name, 'COMPort', COMPort.Text);
    IniFile.WriteString(Name, 'IPAddress', IPAddress.Text);
    IniFile.WriteInteger(Name, 'Timeout', Timeout.Value * 1000);
    IniFile.WriteInteger(Name, 'Interval', Interval.Value);
    IniFile.WriteInteger(Name, 'MPISpeed', MPISpeed.ItemIndex);
    IniFile.WriteInteger(Name, 'MPILocal', MPILocal.Value);
    IniFile.WriteInteger(Name, 'MPIRemote', MPIRemote.Value);
    ModalResult:=mrOK;
  end else ModalResult:=mrCancel;
end;

procedure TConnectionEditor.FormShow(Sender: TObject);
begin
  If Connection.Enabled then Connection.SetFocus else Protocol.SetFocus;
end;

end.

// 16.03.2005 11:29:35 [C:\Programme\Borland\Delphi6\User\GsfExperts\NoDave\Demo\Delphi\Editor.pas]  Projekt Version: 1.0.0.1
//     Created !