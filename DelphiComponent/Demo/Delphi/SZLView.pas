unit SZLView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Spin, ExtCtrls, Main;

type
  TSZLViewer = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    SZLClass: TComboBox;
    Label2: TLabel;
    SZLList: TSpinEdit;
    Label3: TLabel;
    SZLPart: TSpinEdit;
    Label4: TLabel;
    SZLIndex: TSpinEdit;
    Panel2: TPanel;
    SZLGrid: TStringGrid;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    { Public-Deklarationen }
  end;

var
  SZLViewer: TSZLViewer;

implementation

{$R *.dfm}

procedure TSZLViewer.FormCreate(Sender: TObject);
begin
//  GetMem(SZLBuffer, 10000);
end;

procedure TSZLViewer.FormDestroy(Sender: TObject);
begin
//  FreeMem(SZLBuffer);
end;

procedure TSZLViewer.Button1Click(Sender: TObject);
var
  SZLID: Integer;
  DLen: Integer;
  DCount: Integer;
  Line: Integer;
  Column: Integer;
  Value: Byte;
  SZLBuffer: Pointer;
begin
  Case SZLClass.ItemIndex of
    0: SZLID:=0;
    1: SZLID:=12;
    2: SZLID:=8;
    3: SZLID:=4;
  end;
  SZLID:=(SZLID shl 4) + SZLPart.Value;
  SZLID:=(SZLID shl 8) + SZLList.Value;
  MainForm.NoDave.ReadSZL(SZLID, SZLIndex.Value);
  If MainForm.NoDave.LastError <> 0 then
  begin
    SZLGrid.ColCount:=1;
    SZLGrid.RowCount:=1;
    SZLGrid.DefaultColWidth:=500;
    SZLGrid.Cells[0,0]:=MainForm.NoDave.LastErrMsg;
  end else begin
    DLen:=MainForm.NoDave.SZLItemSize;
    DCount:=MainForm.NoDave.SZLCount;
    SZLGrid.ColCount:=DLen;
    SZLGrid.RowCount:=DCount;
    Line:=0;
    While Line < DCount do
    begin
      SZLBuffer:=MainForm.NoDave.SZLItem[Line];
      Column:=0;
      While Column < DLen do
      begin
        Value:=MainForm.NoDave.GetByte(Column, SZLBuffer, 0, DLen);
        SZLGrid.Cells[Column, Line]:=IntToStr(Value) + '  [' + IntToHex(Value, 2) + ']';
        Inc(Column);
      end;
      Inc(Line);
    end;
//    DLen:=MainForm.NoDave.GetWord(4, SZLBuffer, 0, 10000);
//    DCount:=MainForm.NoDave.GetWord(6, SZLBuffer, 0, 10000);
//    SZLGrid.ColCount:=DLen;
//    SZLGrid.RowCount:=DCount;
//    SZLGrid.DefaultColWidth:=50;
//    Line:=0;
//    While Line < DCount do
//    begin
//      Column:=0;
//      While Column < DLen do
//      begin
//        Value:=MainForm.NoDave.GetByte(8 + (Line * DLen) + Column, SZLBuffer, 0, 10000);
//        SZLGrid.Cells[Column, Line]:=IntToStr(Value) + '  [' + IntToHex(Value, 2) + ']';
//        Inc(Column);
//      end;
//      Inc(Line);
//    end;
  end;
end;

end.

// 28.11.2005 10:48:42 [C:\Programme\Borland\Delphi6\User\GsfExperts\NoDave\Demo\Delphi\SZLView.pas]  Projekt Version: 1.0.0.1
//     Created !