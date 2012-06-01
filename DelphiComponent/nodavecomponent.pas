// NoDaveComponent.pas
//
// A unit implementing a wrapper component for easy access to a S7-PLC with
// the libnodave.dll of Thomas Hergenhahn (http://libnodave.sourceforge.net)
//
// (C) 2005, 2006 Gebr. Schmid GmbH + Co., Freudenstadt, Germany
//
// Author: Axel Kinting (akinting@schmid-online.de)
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library; if not, write to the Free Software Foundation, Inc.,
// 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

unit NoDaveComponent;

//The Unit NoDaveComponent implements the class TNoDave, which encapsulates the access to the libnodave.dll.~[BR]
//With TNoDave and libnodave.dll it is very easy to read and write data from and to a S7 PLC.~[BR]~[BR]
//Simatic, Simatic S5, Simatic S7, S7-200, S7-300, S7-400 are registered Trademarks of Siemens Aktiengesellschaft, Berlin und Muenchen.
//~Author Axel Kinting - Gebr. Schmid GmbH + Co.
//~todo Before Installation:~[BR]
//Please copy the file \pascal\nodave.pas into the directory, where the file nodavecomponent.pas is located !~[BR]~[BR]
//Delphi-Installation:~[BR]
//1. Select Component - Install in the Delphi-menu~[BR]
//2. Select Add... button~[BR]
//3. Select Browse~[BR]
//4. Select NoDaveComponent.pas~[BR]
//5. Select OK~[BR]~[BR]
//Lazarus-Installation:~[BR]
//1. Select Components - Open package file~[BR]
//2. Select nodavepackage.lpk~[BR]
//3. Select Open~[BR]
//4. Select Compile~[BR]
//5. Select Install~[BR]
//6. Select Yes~[BR]

interface

uses
  SysUtils, Classes, NoDave, SyncObjs, Controls, {$IFDEF FPC} LCLIntf, LResources {$ELSE} Windows {$ENDIF};

type

  TNoDaveArea = (                                               //The area of the PLC-Data for the TNoDave-Component.
                  daveSysInfo,                                  //System information of 200 family
                  daveSysFlags,                                 //System flag area of 200 family
                  daveAnaIn,                                    //Analog input words of 200 family
                  daveAnaOut,                                   //Analog output words of 200 family
                  daveInputs,                                   //Input memory image
                  daveOutputs,                                  //Output memory image
                  daveFlags,                                    //Flags/Markers
                  daveDB,                                       //Data Blocks (global data)
                  daveDI,                                       //Data Blocks (instance data) ?
                  daveLocal,                                    //Data Blocks (local data) ?
                  daveV,                                        //unknown Area
                  daveCounter,                                  //Counter
                  daveTimer,                                    //Timer
                  daveP                                         //Peripherie Input/Output
  );

  TNoDaveDebugOption = (                                        //The debug-options for the libnodave.dll
                         daveDebugRawRead,
                         daveDebugSpecialChars,
                         daveDebugRawWrite,
                         daveDebugListReachables,
                         daveDebugInitAdapter,
                         daveDebugConnect,
                         daveDebugPacket,
                         daveDebugByte,
                         daveDebugCompare,
                         daveDebugExchange,
                         daveDebugPDU,
                         daveDebugUpload,
                         daveDebugMPI,
                         daveDebugPrintErrors,
                         daveDebugPassive
  );

  TNoDaveDebugOptions = Set of TNoDaveDebugOption;

  TNoDaveProtocol = (                                           //The type of the communication-protocol for the TNoDave-Component.
                      daveProtoMPI,                             //MPI-Protocol
                      daveProtoMPI2,                            //MPI-Protocol (Andrew's version without STX)
                      daveProtoMPI3,                            //MPI-Protocol (Step 7 Version version)
                      daveProtoMPI4,                            //MPI-Protocol (Andrew's version with STX)
                      daveProtoPPI,                             //PPI-Protocol
                      daveProtoISOTCP,                          //ISO over TCP
                      daveProtoISOTCP243,                       //ISO over TCP (for CP243)
                      daveProtoIBH,                             //IBH-Link TCP/MPI-Adapter
                      daveProtoIBH_PPI,                         //IBH-Link TCP/MPI-Adapter with PPI-Protocol
                      daveProtoS7Online,                        //use S7Onlinx.dll for transport via Siemens CP
                      daveProtoAS511,                           //S5 via programmer-port
                      daveProtoNLPro                            //Deltalogic NetLink-PRO TCP/MPI-Adapter
  );

  TNoDaveSpeed = (                                              //The speed of the MPI-protocol for the TNoDave-Component.
                   daveSpeed9k,
                   daveSpeed19k,
                   daveSpeed187k,
                   daveSpeed500k,
                   daveSpeed1500k,
                   daveSpeed45k,
                   daveSpeed93k
  );

  TNoDaveComSpeed = (                                           //The speed of the COM-Port for the TNoDave-Component.
                      daveComSpeed9_6k,
                      daveComSpeed19_2k,
                      daveComSpeed38_4k,
                      daveComSpeed57_6k,
                      daveComSpeed115_2k
  );

//This is the type of the Event-Handler for the OnError-Event of the TNoDave component.
//~param Sender The TNoDave-instance which is the source of the event.
//~param ErrorMsg A clear text message describing the error.
  TNoDaveOnErrorEvent = procedure(Sender: TObject; ErrorMsg: String) of Object;

//List of reachable Partners in the MPI-Network, True = Station is available at this address.
  TNoDaveReachablePartnersMPI = Array [0..126] of Boolean;

//The Class TNoDave encapsulates the access to the libnodave.dll of Thomas Hergenhahn.
//All the settings for the communication are available in the properties of TNoDave.
  TNoDave = class(TComponent)
  private
    FActive: Boolean;
    FArea: TNoDaveArea;
    FBuffer: Pointer;
    FBufLen: Integer;
    FBufOffs: Integer;
    FComPort: String;
    FCpuRack: Integer;
    FCpuSlot: Integer;
    FCycleTime: Cardinal;
    FDBNumber: Integer;
    FDebugOptions: Integer;
    FInterval: Cardinal;
    FIntfName: String;
    FIntfTimeout: Integer;
    FIPAddress: String;
    FIPPort: Integer;
    FMPILocal: Integer;
    FMPIRemote: Integer;
    FMPISpeed: TNoDaveSpeed;
    FLastError: Integer;
    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnError: TNoDaveOnErrorEvent;
    FOnRead: TNotifyEvent;
    FOnWrite: TNotifyEvent;
    FProtocol: TNoDaveProtocol;
    FSZLBuffer: Pointer;
    FComSpeed: TNoDaveComSpeed;
    FHandle: THandle;
    function GetActive: Boolean;
    function GetBuffer: String;
    function GetDebugOptions: TNoDaveDebugOptions;
    function GetLastErrMsg: String;
    procedure SetActive(V: Boolean);
    procedure SetArea(V: TNoDaveArea);
    procedure SetBufLen(V: Integer);
    procedure SetBufOffs(V: Integer);
    procedure SetComPort(V: String);
    procedure SetCpuRack(V: Integer);
    procedure SetCpuSlot(V: Integer);
    procedure SetDBNumber(V: Integer);
    procedure SetDebugOptions(V: TNoDaveDebugOptions);
    procedure SetInterval(V: Cardinal);
    procedure SetIntfName(V: String);
    procedure SetIntfTimeout(V: Integer);
    procedure SetIPAddress(V: String);
    procedure SetIPPort(V: Integer);
    procedure SetMPILocal(V: Integer);
    procedure SetMPIRemote(V: Integer);
    procedure SetMPISpeed(V: TNoDaveSpeed);
    procedure SetProtocol(V: TNoDaveProtocol);
    function GetSZLCount: Integer;
    function GetSZLItemSize: Integer;
    function GetSZLItem(Index: Integer): Pointer;
    function GetMaxPDUData: Integer;
    procedure SetComSpeed(V: TNoDaveComSpeed);
    function GetHandle: THandle;
  protected
    ConnectPending: Boolean;
    DaveFDS: _daveOSSerialType;
    DaveConn: PDaveConnection;
    DaveIntf: PDaveInterface;
    LockNoDave: TCriticalSection;
    ReadThread: TThread;
    procedure DoConnect(OnlyIntf: Boolean = False);
    procedure DoOnConnect;
    procedure DoOnDisconnect;
    procedure DoOnError(ErrorMsg: String);
    procedure DoOnRead;
    procedure DoOnWrite;
    procedure DoReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer = Nil);
    procedure DoWriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer = Nil);
    procedure DoWriteValue(Address, Size: Integer; Value: Pointer);
    procedure Loaded; override;
    procedure WriteBit(Area: TNoDaveArea; DB, Address, Bit: Integer; Value: Boolean); overload;
    function AreaCode(Area: TNoDaveArea): Integer;
    function ProtCode(Prot: TNoDaveProtocol): Integer;
    function BufferAt(Address: Integer; Size: Integer = 1; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): Pointer;
  public
    AreaID: Integer;                                                                        //S7-ID of the selected ~[link .Area Area]
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect(Wait: Boolean = True);
    procedure Disconnect;
    procedure Lock;
    procedure Unlock;
    procedure ResetInterface;
    procedure DoSetDebug(Options: Integer);
    procedure ReadBytes(Buffer: Pointer = Nil); overload;
    Procedure WriteBytes(Buffer: Pointer = Nil); overload;
    procedure ReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer = Nil); overload;
    procedure WriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer = Nil); overload;
    procedure WriteBit(Address, Bit: Integer; Value: Boolean); overload;
    procedure WriteByte(Address: Integer; Value: Byte);
    procedure WriteWord(Address: Integer; Value: Word);
    procedure WriteInt(Address: Integer; Value: SmallInt);
    procedure WriteDWord(Address: Integer; Value: LongWord);
    procedure WriteDInt(Address: Integer; Value: LongInt);
    procedure WriteFloat(Address: Integer; Value: Single);
    function GetBit(Address, Bit: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): Boolean;
    function GetByte(Address: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): Byte;
    function GetWord(Address: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): Word;
    function GetInt(Address: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): SmallInt;
    function GetDWord(Address: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): LongWord;
    function GetDInt(Address: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): LongInt;
    function GetFloat(Address: Integer; Buffer: Pointer = Nil; BufOffs: Integer = 0; BufLen: Integer = 0): Double;
    function GetDBSize(DB: Integer): Integer;
    function ListReachablePartners: TNoDaveReachablePartnersMPI;
    function Swap16(Value: SmallInt): SmallInt;
    function Swap32(Value: Integer): Integer;
    function GetErrorMsg(Error: Integer): String;
    function ReadSZL(ID, Index: Integer): Integer;
    property SZLCount: Integer read GetSZLCount;                                            //Property for the number of items in the internal SZL-Buffer
    property SZLItem[Index: Integer]: Pointer read GetSZLItem;                              //Property for the items in the internal SZL-Buffer
    property SZLItemSize: Integer read GetSZLItemSize;                                      //Property for the size of one item in the internal SZL-Buffer
    property MaxPDUData: Integer read GetMaxPDUData;                                        //Property for the maximum datasize of one read-request
    property Handle: THandle read GetHandle;                                                //Property for the Windows-Handle used for system-calls
  published
    property Active: Boolean read GetActive write SetActive;                                //Property for the connection-status.
    property Area: TNoDaveArea read FArea write SetArea;                                    //Property for the PLC-area
    property Buffer: String read GetBuffer;                                                 //Property for the pointer to the internal buffer memory.
    property BufLen: Integer read FBufLen write SetBufLen;                                  //Property for the length of the buffer.
    property BufOffs: Integer read FBufOffs write SetBufOffs;                               //Property for the offset of the buffer within the address-range of the PLC.
    property COMPort: String read FComPort write SetComPort;                                //Property for the name of the COM-Port used for the serial-to-MPI adapter.
    property COMSpeed: TNoDaveComSpeed read FComSpeed write SetComSpeed;                    //Property for the speed of the COM-Port used for the serial-to-MPI adapter.
    property CPURack: Integer read FCpuRack write SetCpuRack;                               //Property for the number of the rack containing the CPU of the PLC.
    property CPUSlot: Integer read FCpuSlot write SetCpuSlot;                               //Property for the number of the slot containing the CPU of the PLC.
    property CycleTime: Cardinal read FCycleTime;                                           //Property for the duration in ms of the last communication cycle.
    property DBNumber: Integer read FDBNumber write SetDBNumber;                            //Property for the number of the datablock in the PLC.
    property DebugOptions: TNoDaveDebugOptions read GetDebugOptions write SetDebugOptions;  //Property for the debug-options.
    property Interval: Cardinal read FInterval write SetInterval;                           //Property for the minimal round-trip cycle time for the background-communication with the PLC in milliseconds.
    property IntfName: String read FIntfName write SetIntfName;                             //Property for the symbolic name of the interface.
    property IntfTimeout: Integer read FIntfTimeout write SetIntfTimeout;                   //Property for the timeout of the interface in milliseconds.
    property IPAddress: String read FIPAddress write SetIPAddress;                          //Property for the IP-address or name of the TCP/IP partner station.
    property IPPort: Integer read FIPPort write SetIPPort;                                  //Property for the IP-port of the TCP/IP partner station.
    property LastError: Integer read FLastError;                                            //Property for the return-code of the last call of a communication-method.
    property LastErrMsg: String read GetLastErrMsg;                                         //Property for the text describing the code in ~[link .LastError LastError].
    property MPILocal: Integer read FMPILocal write SetMPILocal;                            //Property for the local MPI-address used for the MPI-communication.
    property MPIRemote: Integer read FMPIRemote write SetMPIRemote;                         //Property for the remote MPI-address used for the MPI-communication.
    property MPISpeed: TNoDaveSpeed read FMPISpeed write SetMPISpeed;                       //Property for the MPI-speed used for the MPI-communication.
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;                      //Property for the OnConnect-eventhandler
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;             //Property for the OnDisconnect-eventhandler
    property OnError: TNoDaveOnErrorEvent read FOnError write FOnError;                     //Property for the OnError-eventhandler
    property OnRead: TNotifyEvent read FOnRead write FOnRead;                               //Property for the OnRead-eventhandler
    property OnWrite: TNotifyEvent read FOnWrite write FOnWrite;                            //Property for the OnWrite-eventhandler
    property Protocol: TNoDaveProtocol read FProtocol write SetProtocol;                    //Property for the Protocol used for the communication with the PLC.
  end;


  TSzlLed = (NONE, SF, INTF, EXTF, RUN, STOP, FRCE, CRST, BAF, USR, USR1, BUS1F, BUS2F, REDF, MSTR, RACK0, RACK1, RACK2, IFM1F, IFM2F);

  TSzlBGIdent = Record
    Index:      Word;
    MlfB:       packed Array[1..20] of Char;
    BGTyp:      Word;
    AusBG:      packed Array[1..4] of Byte;
  end;
  PSzlBGIdent = ^TSzlBGIdent;

  TSzlUserMemory = Record
    Index:      Word;
    Code:       Word;
    Size:       LongWord;
    Mode:       Word;
    Granu:      Word;
    Area1:      LongWord;
    Used1:      LongWord;
    Free1:      LongWord;
    Area2:      LongWord;
    Used2:      LongWord;
    Free2:      LongWord;
  end;
  PSzlUserMemory = ^TSzlUserMemory;

  TSzlSystemMemory = Record
    Index:      Word;
    Code:       Word;
    Count:      Word;
    Reman:      Word;
  end;
  PSzlSystemMemory = ^TSzlSystemMemory;

  TSzlBlockType = Record
    Index:      Word;
    Count:      Word;
    Size:       Word;
    MemSize:    LongWord;
  end;
  PSzlBlockType = TSzlBlockType;

  TSzlLedState = packed Record
    Index:      Word;
    State:      Byte;
    Blink:      Byte;
  end;
  PSzlLedState = ^TSzlLedState;

  TSzlBGState = Record
    Addr1:      Word;
    Addr2:      Word;
    LogAddr:    Word;
    ConfTyp:    Word;
    RealTyp:    Word;
    Count:      Word;
    EAStatus:   Word;
    Area:       Word;
  end;
  PSzlBGState = ^TSzlBGState;

  TSzlStationState = Record
    Status:     packed Array[0..15] of Byte;
  end;
  PSzlStationState = ^TSzlStationState;

  TSzlDiagMessage = packed Record
    ID:         Word;
    Info:       Array[1..5] of Word;
    Year:       Byte;
    Month:      Byte;
    Day:        Byte;
    Hour:       Byte;
    Minute:     Byte;
    Second:     Byte;
    MSec:       Word;
  end;
  PSzlDiagMessage = ^TSzlDiagMessage;

  TSzlBGDiagInfo = Record
    Info:       packed Array[1..4] of Byte;
  end;
  PSzlBGDiagInfo = ^TSzlBGDiagInfo;


procedure Register;

implementation

type

//Worker-thread for asynchronous connecting with the PLC.
  TNoDaveConnectThread = class(TThread)
  private
    NoDave: TNoDave;
    ErrMsg: String;
  protected
    procedure DoOnError;
    procedure DoOnConnect;
    procedure Execute; override;
  public
    constructor Create(Target: TNoDave);
  end;

//Worker-thread for the background-communication with the PLC.
  TNoDaveReadThread = class(TThread)
  private
    NoDave: TNoDave;
    ErrMsg: String;
  protected
    procedure DoOnError;
    procedure DoOnRead;
    procedure Execute; override;
  public
    constructor Create(Target: TNoDave);
  end;

//Installation of TNoDave in the component palette
procedure Register;
begin
  RegisterComponents('System',[TNoDave]);
end;

{ TNoDaveConnectThread }

//Create the worker-thread for asynchronous connecting with the PLC.
//~param Target The TNoDave-instance to connect with the PLC.
constructor TNoDaveConnectThread.Create(Target: TNoDave);
begin
  inherited Create(False);
  NoDave:=Target;
  FreeOnTerminate:=True;
end;

//Synchronization-method for calling the OnConnect-Event of the TNoDave-instance.
procedure TNoDaveConnectThread.DoOnConnect;
begin
  NoDave.DoOnConnect;
end;

//Synchronization-method for calling the OnError-Event of the TNoDave-instance.
procedure TNoDaveConnectThread.DoOnError;
begin
  NoDave.DoOnError(ErrMsg);
end;

//Open the connection to the PLC. If successfull then call the OnConnect-Event else call the OnError-Event of the TNoDave-instance.
procedure TNoDaveConnectThread.Execute;
begin
  try
    NoDave.DoConnect;
    If NoDave.Active then Synchronize(DoOnConnect);
  except
    on E: Exception do
    begin
      ErrMsg:='Error in function TNoDaveConnectThread.Execute: ' + E.Message;
      Synchronize(DoOnError);
    end;
  end;
  NoDave.ConnectPending:=False;
end;

{ TNoDaveReadThread }

//Create the worker-thread for the background-communication with the PLC.
//~param Target The TNoDave-instance for the communication with the PLC.
constructor TNoDaveReadThread.Create(Target: TNoDave);
begin
  inherited Create(False);
  NoDave:=Target;
end;

//Synchronization-method for calling the OnError-Event of the TNoDave-instance.
procedure TNoDaveReadThread.DoOnError;
begin
  NoDave.DoOnError(ErrMsg);
end;

//Synchronization-method for calling the OnRead-Event of the TNoDave-instance.
procedure TNoDaveReadThread.DoOnRead;
begin
  NoDave.DoOnRead;
end;

//Read the data from the PLC, call the OnRead-Event of the TNoDave-instance, wait until the round-trip cycle time is reached and
//then start again from the beginning until the Connection of the TNoDave-instance is active. Disconnect the TNoDave-instance if
//the connection is not longer valid.
procedure TNoDaveReadThread.Execute;
var
  StartTime: Cardinal;
  NextTime: Cardinal;
begin
  While NoDave.Active and (NoDave.Interval > 0) do
  begin
    StartTime:=GetTickCount;
    NextTime:=StartTime + NoDave.Interval;
    try
      NoDave.ReadBytes;
      If NoDave.LastError = 0 then Synchronize(DoOnRead) else
      begin
        If NoDave.LastError = -1 then NoDave.Disconnect else
        begin
          ErrMsg:=NoDave.LastErrMsg;
          Synchronize(DoOnError);
        end;
      end;
    except
      on E: Exception do
      begin
        ErrMsg:='Error in function TNoDaveReadThread.Execute: ' + E.Message;
        Synchronize(DoOnError);
      end;
    end;
    While GetTickCount < NextTime do Sleep(1);
  end;
end;

{ TNoDave }

//Initialize a new instance of the TNoDave component.
//~param aOwner Owner of the created instance.
constructor TNoDave.Create(aOwner: TComponent);
begin
  inherited;
  AreaID:=-1;
  FActive:=False;
  FArea:=daveDB;
  FBuffer:=Nil;
  FBufLen:=0;
  FBufOffs:=0;
  FComPort:='COM1:';
  FComSpeed:=daveComSpeed38_4k;
  FCpuRack:=0;
  FCpuSlot:=2;
  FDBNumber:=1;
  FDebugOptions:=0;
  FIntfName:='IF1';
  FIntfTimeout:=1500000;
  FIPAddress:='';
  FIPPort:=102;
  FMPILocal:=0;
  FMPIRemote:=2;
  FMPISpeed:=daveSpeed187k;
  FLastError:=0;
  FProtocol:=daveProtoMPI;
  LockNoDave:=TCriticalSection.Create;
  daveSetDebug(FDebugOptions);
end;

//Close an active connection and call the inherited Destroy method.
destructor TNoDave.Destroy;
begin
  Disconnect;
  If Assigned(FBuffer) then
  try
    FreeMem(FBuffer);
  except
  end;
  If FHandle <> 0 then
  try
    DeallocateHWnd(FHandle);
  except
  end;
  FHandle:=0;
  LockNoDave.Free;
  inherited;
end;

//Determine the S7-ID of an Area.
//~param Area Requested Area.
//~result S7-ID of the Area.
function TNoDave.AreaCode(Area: TNoDaveArea): Integer;
begin
  Result:=AreaID;
  If Result = -1 then
  begin
    Case Area of
      daveSysInfo:    Result:=3;
      daveSysFlags:   Result:=5;
      daveAnaIn:      Result:=6;
      daveAnaOut:     Result:=7;
      daveCounter:    Result:=28;
      daveTimer:      Result:=29;
      daveP:          Result:=128;
      daveInputs:     Result:=129;
      daveOutputs:    Result:=130;
      daveFlags:      Result:=131;
      daveDB:         Result:=132;
      daveDI:         Result:=133;
      daveLocal:      Result:=134;
      daveV:          Result:=135;
    end;
  end;
end;

//Return a Pointer to the requested PLC-data point within the buffer.
//~param Address PLC-Address of  the datapoint.
//~param Size Size of the datapoint in bytes.
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result Pointer to the requested data point if the address is located in the buffer, else Nil.
function TNoDave.BufferAt(Address: Integer; Size: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): Pointer;
var
  Offset: Integer;
begin
  Result:=Nil;
  try
    If Assigned(Buffer) then
    begin
      Offset:=Address - BufOffs;
      If Offset + Size <= BufLen then Result:=Pointer(Integer(Buffer) +  Offset);
    end else begin
      Offset:=Address - FBufOffs;
      If Offset + Size <= FBufLen then Result:=Pointer(Integer(FBuffer) + Offset);
    end;
  except
    On E: Exception do DoOnError('Error in function TNoDave.BufferAt(' + IntToStr(Address) + ', ' + IntToStr(Size) + ', $' +
                                 IntToHex(Integer(Buffer), 8) + ', ' + IntToStr(BufOffs) + ', ' + IntToStr(BufLen) + '): ' +
                                 E.Message);
  end;
end;

//Open the connection to the PLC.
//~param Wait If False the connection is opened asyncronous in a separate thread. Default is True.
procedure TNoDave.Connect(Wait: Boolean = True);
begin
  If not FActive and not ConnectPending then
  begin
    ConnectPending:=True;
    If Wait then
    begin
      try
        DoConnect;
        If Active and not (csLoading in ComponentState) then DoOnConnect;
      except
        On E: Exception do DoOnError('Error in function TNoDave.Connect: ' + E.Message);
      end;
      ConnectPending:=False;
    end else begin
      TNoDaveConnectThread.Create(Self);
    end;
  end;
end;

//Close the connection to the PLC.
procedure TNoDave.Disconnect;
begin
  If Active then
  begin
    try
      daveDisconnectPLC(DaveConn);
      daveFree(DaveConn);
      daveDisconnectAdapter(DaveIntf);
      daveFree(DaveIntf);
      If FProtocol <> daveProtoS7Online then closePort(DaveFDS.rfd) else closeS7online(DaveFDS.rfd);
    except
      On E: Exception do DoOnError('Error in function TNoDave.Disconnect: ' + E.Message);
    end;
    FActive:=False;
    DoOnDisconnect;
  end;
end;

//Open the connection to the PLC specified by the properties ~[link .Protocol Protocol], ~[link .CPURack CPURack], ~[link .CPUSlot CPUSlot],
//~[link .COMPort COMPort], ~[link .IPAddress IPAddress], ~[link .IPPort IPPort], ~[link .MPILocal MPILocal], ~[link .MPIRemote MPIRemote]
// and/or ~[link .MPISpeed MPISpeed]
//~param OnlyIntf Open only the interface, don't connect to the PLC
procedure TNoDave.DoConnect(OnlyIntf: Boolean = False);
var
  Address: String;
  Speed: PChar;
begin
  If not FActive then
  begin
    If not (csLoading in ComponentState) then
    begin
      Case FProtocol of
        daveProtoMPI, daveProtoMPI2, daveProtoMPI3, daveProtoMPI4, daveProtoPPI, daveProtoAS511:
          begin
            Address:=FComPort + #0;
            Case ComSpeed of
              daveComSpeed9_6k:   Speed:='9600';
              daveComSpeed19_2k:  Speed:='19200';
              daveComSpeed38_4k:  Speed:='38400';
              daveComSpeed57_6k:  Speed:='57600';
              daveComSpeed115_2k: Speed:='115200';
              else                Speed:='38400';
            end;
            DaveFDS.rfd:=SetPort(@Address[1], Speed, 'O');
          end;
        daveProtoISOTCP, daveProtoISOTCP243, daveProtoIBH, daveProtoIBH_PPI, daveProtoNLPro:
          begin
            Address:=FIPAddress + #0;
            DaveFDS.rfd:=OpenSocket(FIPPort, @Address[1]);
          end;
        daveProtoS7Online:
          begin
            Address:=FComPort + #0;
            DaveFDS.rfd:=OpenS7Online(@Address[1], Handle);
          end;
      end;
      DaveFDS.wfd:=DaveFDS.rfd;
      If (DaveFDS.rfd > 0) or ((DaveFDS.rfd = 0) and (FProtocol = daveProtoS7Online)) then
      begin
        Address:=FIntfName + #0;
        DaveIntf:=daveNewInterface(DaveFDS, @Address[1], Ord(FMPIlocal), ProtCode(FProtocol), Ord(FMPISpeed));
        DaveIntf^.timeout:=FIntfTimeout;
        If not OnlyIntf then
        begin
          FLastError:=daveInitAdapter(DaveIntf);
          If FLastError = 0 then
          begin
            DaveConn:=daveNewConnection(DaveIntf, FMPIRemote, FCpuRack, FCpuSlot);
            FLastError:=daveConnectPLC(DaveConn);
            FActive:=(FLastError = 0);
            If Active then ReadBytes else DoOnError(daveStrerror(FLastError));
          end;
        end;
      end;
    end else FActive:=True;
  end;
end;

//Create the worker-thread for cyclic reading if neccessary and call the OnConnect-eventhandler if specified.
procedure TNoDave.DoOnConnect;
begin
  If (FInterval > 0) and not Assigned(ReadThread) and not (csDesigning in ComponentState)
    then ReadThread:=TNoDaveReadThread.Create(Self);
  If Assigned(OnConnect) then OnConnect(Self);
end;

//Stop and Destroy the worker-thread for cyclic reading if neccessary and call the OnDisconnect-eventhandler if specified.
procedure TNoDave.DoOnDisconnect;
begin
  If Assigned(ReadThread) then
  begin
    ReadThread.WaitFor;
    FreeAndNil(ReadThread);
  end;
  If Assigned(OnDisconnect) then OnDisconnect(Self);
end;

//Call the OnError-eventhandler if specified.
//~param ErrorMsg The text-message for the OnError-event
procedure TNoDave.DoOnError(ErrorMsg: String);
begin
  If Assigned(OnError) then OnError(Self, ErrorMsg);
end;

//Call the OnRead-eventhandler if specified.
procedure TNoDave.DoOnRead;
begin
  If Assigned(OnRead) then OnRead(Self);
end;

//Call the OnWrite-eventhandler if specified.
procedure TNoDave.DoOnWrite;
begin
  If Assigned(OnWrite) then OnWrite(Self);
end;

//Read the PLC-data into the buffer.
//~param Area Requested PLC-area.
//~param DB Number of requested datablock. Only used, if reading from Datablocks in the PLC.
//~param Start Start-address of the requested data within the address-range of the PLC.
//~param Size Length of the requested PLC-data in bytes.
//~param Buffer Pointer to the buffer. The internal buffer of the instance is used, if Nil (default).
procedure TNoDave.DoReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
var
  Index, Length, MaxLen: Integer;
  StartTime: Cardinal;
begin
  Index:=0;
  StartTime:=GetTickCount;
  MaxLen:=MaxPDUData;
  While (Index < Size) and (MaxLen > 0) do
  begin
    Length:=(Size - Index);
    If Length > MaxLen then Length:=MaxLen;
    try
      LockNoDave.Enter;
      FLastError:=daveReadBytes(DaveConn, AreaCode(Area), DB, Index+Start, Size, Pointer(Integer(Buffer) + Index));
    except
      On E: Exception do DoOnError('Error in function TNoDave.DoReadBytes: ' + E.Message);
    end;
    LockNoDave.Leave;
    Inc(Index, Length);
  end;
  try
    FCycleTime:=GetTickCount - StartTime;
  except
  end;
end;

//Write the Buffer-data into the PLC.
//~param Area Requested PLC-area.
//~param DB Number of requested datablock. Only used, if reading from Datablocks in the PLC.
//~param Start Start-address of the requested data within the address-range of the PLC.
//~param Size Length of the requested PLC-data in bytes.
//~param Buffer Pointer to the buffer. The internal buffer of the instance is used, if Nil (default).
procedure TNoDave.DoWriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
var
  Index, Length, MaxLen: Integer;
begin
  Index:=0;
  MaxLen:=MaxPDUData-4;
  While (Index < Size) and (MaxLen > 0) do
  begin
    Length:=(Size - Index);
    If Length > MaxLen then Length:=MaxLen;
    try
      LockNoDave.Enter;
      FLastError:=daveWriteBytes(DaveConn, AreaCode(Area), DB, Index+Start, Size, Pointer(Integer(Buffer) + Index));
    except
      On E: Exception do DoOnError('Error in function TNoDave.DoWriteBytes: ' + E.Message);
    end;
    LockNoDave.Leave;
    Inc(Index, Length);
  end;
end;

//Write a single value into the specified address of the PLC without changing the properties of the TNoDave-instance.
//~param Address PLC-Address of the data point.
//~param Size Size in bytes of the value.
//~param Value The value to be written.
procedure TNoDave.DoWriteValue(Address, Size: Integer; Value: Pointer);
begin
  try
    LockNoDave.Enter;
    FLastError:=daveWriteBytes(DaveConn, AreaCode(FArea), FDBNumber, Address, Size, Value);
  except
    On E: Exception do DoOnError('Error in function TNoDave.DoWriteValue: ' + E.Message);
  end;
  LockNoDave.Leave;
end;

//Set the debug-options of the libnodave.dll
//~param Options Value of the debug-options.
procedure TNoDave.DoSetDebug(Options: Integer);
begin
  daveSetDebug(Options);
  FDebugOptions:=Options;
end;

//Return the state of the connection to the PLC.
//~result True, if connection is open, else False.
function TNoDave.GetActive: Boolean;
begin
  Result:=FActive and not (csLoading in ComponentState);
end;

//Return a textual representation of the content of the internal buffer.
//~result String with the hexadecimal value of the bytes in the buffer.
function TNoDave.GetBuffer: String;
var
  Index: Integer;
  Value: Byte;
begin
  Result:='';
  If Assigned(FBuffer) then
  begin
    Index:=0;
    While Index < FBufLen do
    begin
      Value:=Byte(Pointer(Integer(FBuffer) + Index)^);
      If Result <> '' then Result:=Result + ' ';
      Result:=Result + IntToHex(Value, 2);
      Inc(Index);
    end;
  end;
end;

//Return the Bit-value read last from the PLC at the specified address.
//~param Address Byte-address of the requested value
//~param Bit Bit-address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or False, if the requested address was not found within the buffer.
function TNoDave.GetBit(Address, Bit: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): Boolean;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 1, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=(daveGetU8From(BufPtr) and (1 shl Bit)) <> 0 else Result:=False;
end;

//Return the Byte-value read last from the PLC at the specified address.
//~param Address Address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or 0, if the requested address was not found within the buffer.
function TNoDave.GetByte(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): Byte;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 1, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=daveGetU8From(BufPtr) else Result:=0;
end;

//Return the LongInt-value read last from the PLC at the specified address.
//~param Address Address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or 0, if the requested address was not found within the buffer.
function TNoDave.GetDInt(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): LongInt;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 4, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=daveGetS32From(BufPtr) else Result:=0;
end;

//Return the LongWord-value read last from the PLC at the specified address.
//~param Address Address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or 0, if the requested address was not found within the buffer.
function TNoDave.GetDWord(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): LongWord;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 4, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=daveGetU32From(BufPtr) else Result:=0;
end;

//Return the Float-value read last from the PLC at the specified address.
//~param Address Address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or 0, if the requested address was not found within the buffer.
function TNoDave.GetFloat(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): Double;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 4, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=daveGetFloatFrom(BufPtr) else Result:=0;
end;

//Return the Window-Handle (HWND) used for system-calls.
//~result The Window-Handle (HWND).
function TNoDave.GetHandle: THandle;
var
  Parent: TComponent;
begin
  Parent:=Self;
  while Assigned(Parent.Owner) and not (Parent is TWinControl) do Parent:=Parent.Owner;
  if Parent is TWinControl then Result:=TWinControl(Parent).Handle else
  begin
    If FHandle = 0 then FHandle:=AllocateHwnd(Nil);
    Result:=FHandle;
  end;
end;

//Return the SmallInt-value read last from the PLC at the specified address.
//~param Address Address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or 0, if the requested address was not found within the buffer.
function TNoDave.GetInt(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): SmallInt;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 2, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=daveGetS16From(BufPtr) else Result:=0;
end;

//Return the Word-value read last from the PLC at the specified address.
//~param Address Address of the requested value
//~param Buffer Pointer to the buffer holding the PLC-data. The internal buffer is used, if Nil (default).
//~param BufOffs Offset-address of the buffer within the address-range of the PLC.
//~param BufLen Length of the buffer in bytes.
//~result The requested value or 0, if the requested address was not found within the buffer.
function TNoDave.GetWord(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): Word;
var
  BufPtr: Pointer;
begin
  BufPtr:=BufferAt(Address, 2, Buffer, BufOffs, BufLen);
  If Assigned(BufPtr) then Result:=daveGetU16From(BufPtr) else Result:=0;
end;

//Return the description of the return-code in ~[link .LastError LastError].
//~result The description of the return-code.
function TNoDave.GetLastErrMsg: String;
begin
  If FLastError = 0 then Result:='' else Result:=GetErrorMsg(FLastError);
end;

//Scan the MPI-bus for all reachable partners
//~result List with True for available partners and False for unavailable partners.
function TNoDave.ListReachablePartners: TNoDaveReachablePartnersMPI;
type
  TByteList = Array [0..126] of Byte;
  PByteList = ^TByteList;
var
  List: Pointer;
  WasActive: Boolean;
  Index: Integer;
begin
  GetMem(List, SizeOf(TByteList));
  try
    WasActive:=Active;
    Active:=True;
    If Active then
    begin
      daveListReachablePartners(DaveIntf, List);
      Index:=0;
      While Index < 127 do
      begin
        Result[Index]:=(PByteList(List)^[Index] = daveMPIReachable);
        Inc(Index);
      end;
    end else begin
      Index:=0;
      While Index < 127 do
      begin
        Result[Index]:=False;
        Inc(Index);
      end;
    end;
    Active:=WasActive;
  finally
    FreeMem(List);
  end;
end;

//Open the connection to the PLC after the instance is completely loaded from the stream and if Active is True.
procedure TNoDave.Loaded;
begin
  inherited;
  If FActive then
  begin
    FActive:=False;
    Connect;
  end;
end;

//Lock the communication-routines for the current tread.
procedure TNoDave.Lock;
begin
  LockNoDave.Enter;
end;

//Determine the libnodave.dll-code of a protocol
//~param Prot The requested protocol
//~result The libnodave.dll code for the protocol
function TNoDave.ProtCode(Prot: TNoDaveProtocol): Integer;
begin
  Result:=-1;
  Case Prot of
    daveProtoMPI:       Result:=0;
    daveProtoMPI2:      Result:=1;
    daveProtoMPI3:      Result:=2;
    daveProtoMPI4:      Result:=3;
    daveProtoPPI:       Result:=10;
    daveProtoAS511:     Result:=20;
    daveProtoS7Online:  Result:=50;
    daveProtoISOTCP:    Result:=122;
    daveProtoISOTCP243: Result:=123;
    daveProtoIBH:       Result:=223;
    daveProtoIBH_PPI:   Result:=224;
    daveProtoNLPro:     Result:=230;
  end;
end;

//Read the Data specified by the properties ~[link .Area Area], ~[link .DBNumber DBNumber], ~[link .BufOffs BufOffs]
//and ~[link .BufLen BufLen] from the PLC into the buffer.
//~param Buffer Pointer to the buffer for PLC-data. The internal buffer is used, if Nil (default).
procedure TNoDave.ReadBytes(Buffer: Pointer);
begin
  If not Assigned(Buffer) then Buffer:=FBuffer;
  If Active then
  begin
    DoReadBytes(FArea, FDBNumber, FBufOffs, FBufLen, Buffer);
    DoOnRead;
  end;
end;

//Read the specified Data from the PLC into the buffer.
//~param Area Requested PLC-area.
//~param DB Number of requested datablock. Only used, if reading from Datablocks in the PLC.
//~param Start Start-address of the requested data within the address-range of the PLC.
//~param Size Length of the requested PLC-data in bytes.
//~param Buffer Pointer to the buffer for PLC-data. The internal buffer is used, if Nil (default).
procedure TNoDave.ReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
begin
  If not Assigned(Buffer) then
  begin
    FArea:=Area;
    FDBNumber:=DB;
    FBufOffs:=Start;
    FBufLen:=Size;
    ReadBytes(Buffer);
  end else begin
    DoReadBytes(Area, DB, Start, Size, Buffer);
  end;
end;

//Set the property ~[link .Active Active] and call either ~[link .Connect Connect] or ~[link .Disconnect Disconnect].
//depending on the requested value.
//~param V The requested state.
procedure TNoDave.SetActive(V: Boolean);
begin
  If V then Connect else Disconnect;
end;

//Set the property ~[link .Area Area].
//~param V The ~[link TNoDaveArea PLC-Area].
procedure TNoDave.SetArea(V: TNoDaveArea);
begin
  FArea:=V;
  If V in [daveDB, daveDI, daveLocal] then
  begin
    If FDBNumber = 0 then FDBNumber:=1;
  end else FDBNumber:=0;
  If Active and (csDesigning in ComponentState) then ReadBytes;
end;

//Set the property ~[link .BufLen BufLen] and reserve the required memory.
//~param V The length of the buffer in bytes.
procedure TNoDave.SetBufLen(V: Integer);
begin
  If Assigned(FBuffer) then
  try
    FreeMem(FBuffer);
  except
  end;
  FBufLen:=V;
  GetMem(FBuffer, FBufLen);
  If Active and (csDesigning in ComponentState) then ReadBytes;
end;

//Set the property ~[link .BufOffs BufOffs].
//~param V The address within the address-range of the PLC.
procedure TNoDave.SetBufOffs(V: Integer);
begin
  FBufOffs:=V;
  If Active and (csDesigning in ComponentState) then ReadBytes;
end;

//Set the property ~[link .ComPort ComPort].
//~param V The Name of the ComPort.
procedure TNoDave.SetComPort(V: String);
begin
  If FProtocol in [daveProtoMPI, daveProtoMPI2, daveProtoMPI3, daveProtoMPI4, daveProtoPPI, daveProtoAS511] then Disconnect;
  FComPort:=V;
end;

//Set the property ~[link .ComSpeed ComComSpeed].
//~param V The Name of the ComPort.
procedure TNoDave.SetComSpeed(V: TNoDaveComSpeed);
begin
  If FProtocol in [daveProtoMPI, daveProtoMPI2, daveProtoMPI3, daveProtoMPI4, daveProtoPPI, daveProtoAS511] then Disconnect;
  FComSpeed:=V;
end;

//Set the property ~[link .CpuRack CpuRack].
//~param V The rack of the PLC containing the CPU.
procedure TNoDave.SetCpuRack(V: Integer);
begin
  Disconnect;
  FCpuRack:=V;
end;

//Set the property ~[link .CpuSlot CpuSlot].
//~param V The Slot of the PLC containing the CPU.
procedure TNoDave.SetCpuSlot(V: Integer);
begin
  Disconnect;
  FCpuSlot:=V;
end;

//Set the property ~[link .DBNumber DBNumber].
//~param V The requested number of the datablock.
procedure TNoDave.SetDBNumber(V: Integer);
begin
  FDBNumber:=V;
  If Active and (csDesigning in ComponentState) then ReadBytes;
end;

//Set the property ~[link .Interval Interval].
//~param V The Interval for the background-communication in milliseconds. 0 if no background-communication is desired.
procedure TNoDave.SetInterval(V: Cardinal);
begin
  FInterval:=V;
  If Active then
  begin
    If (FInterval > 0) then
    begin
      If not Assigned(ReadThread) and not (csDesigning in ComponentState) then ReadThread:=TNoDaveReadThread.Create(Self);
    end else begin
      If Assigned(ReadThread) then
      begin
        ReadThread.WaitFor;
        FreeAndNil(ReadThread);
      end;
    end;
  end;
end;

//Set the property ~[link .IntfName IntfName].
//~param V The symbolic name of the interface.
procedure TNoDave.SetIntfName(V: String);
begin
  Disconnect;
  FIntfName:=V;
end;

//Set the property ~[link .IntfTimeout IntfTimeout].
//~param V The timeout of the interface in milliseconds.
procedure TNoDave.SetIntfTimeout(V: Integer);
begin
  FIntfTimeout:=V;
  If Active then DaveIntf^.timeout:=FIntfTimeout;
end;

//Set the property ~[link .IPAddress IPAddress].
//~param V The IP-address or name of the TCP/IP partner station.
procedure TNoDave.SetIPAddress(V: String);
begin
  If FProtocol in [daveProtoISOTCP, daveProtoISOTCP243, daveProtoIBH, daveProtoIBH_PPI, daveProtoNLPro] then Disconnect;
  FIPAddress:=V;
end;

//Set the property ~[link .IPPort IPPort].
//~param V The IP-Port of the TCP/IP parter station.
procedure TNoDave.SetIPPort(V: Integer);
begin
  If FProtocol in [daveProtoISOTCP, daveProtoISOTCP243, daveProtoIBH, daveProtoIBH_PPI, daveProtoNLPro] then Disconnect;
  FIPPort:=V;
end;

//Set the property ~[link .MPILocal MPILocal].
//~param V The local MPI-address for the MPI communication.
procedure TNoDave.SetMPILocal(V: Integer);
begin
  If FProtocol in [daveProtoMPI, daveProtoMPI2, daveProtoMPI3, daveProtoMPI4, daveProtoPPI, daveProtoIBH, daveProtoIBH_PPI, daveProtoNLPro] then Disconnect;
  FMPILocal:=V;
end;

//Set the property ~[link .MPIRemote MPIRemote].
//~param V The remote MPI-address for the MPI communication.
procedure TNoDave.SetMPIRemote(V: Integer);
begin
  If FProtocol in [daveProtoMPI, daveProtoMPI2, daveProtoMPI3, daveProtoMPI4, daveProtoPPI, daveProtoIBH, daveProtoIBH_PPI, daveProtoNLPro] then Disconnect;
  FMPIRemote:=V;
end;

//Set the property ~[link .MPISpeed MPISpeed].
//~param V The ~[link TNoDaveSpeed speed] of the MPI-bus.
procedure TNoDave.SetMPISpeed(V: TNoDaveSpeed);
begin
  If FProtocol in [daveProtoMPI, daveProtoMPI2, daveProtoMPI3, daveProtoMPI4, daveProtoPPI, daveProtoIBH, daveProtoIBH_PPI, daveProtoNLPro] then Disconnect;
  FMPISpeed:=V;
end;

//Set the property ~[link .Protocol Protocol].
//~param V The requested ~[link TNoDaveProtocol Protocol].
procedure TNoDave.SetProtocol(V: TNoDaveProtocol);
begin
  Disconnect;
  FProtocol:=V;
  If FProtocol in [daveProtoIBH, daveProtoIBH_PPI] then FIPPort:=1099;
  If FProtocol in [daveProtoNLPro] then FIPPort:=7777;
  If FProtocol in [daveProtoISOTCP, daveProtoISOTCP243] then FIPPort:=102;
end;

//Swap the byte-order in a 16-bit value.
//~param Value The value for the conversion.
//~result The converted value.
function TNoDave.Swap16(Value: SmallInt): SmallInt;
begin
  Result:=daveSwapIed_16(Value);
end;

//Swap the byte-order in a 32-bit value.
//~param Value The value for the conversion.
//~result The converted value.
function TNoDave.Swap32(Value: Integer): Integer;
begin
  Result:=daveSwapIed_32(Value);
end;

//Unlock the communication-routines for other threads.
procedure TNoDave.Unlock;
begin
  LockNoDave.Leave;
end;

//Write a Bit-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Area Requested PLC-area.
//~param DB Number of requested datablock. Only used, if writing into datablocks of the PLC.
//~param Address Byte-address of the value
//~param Bit Bit-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteBit(Area: TNoDaveArea; DB, Address, Bit: Integer; Value: Boolean);
var
  Output: LongInt;
begin
  try
    LockNoDave.Enter;
    If Value then Output:=1 else Output:=0;
    FLastError:=daveWriteBits(DaveConn, AreaCode(Area), DB, (Address*8)+Bit, 1, @Output);
  except
    On E: Exception do DoOnError('Error in function TNoDave.WriteBit: ' + E.Message);
  end;
  LockNoDave.Leave;
end;

//Write the buffer into the PLC at the address specified by the properties ~[link .Area Area], ~[link .DBNumber DBNumber],
//~[link .BufOffs BufOffs] and ~[link .BufLen BufLen].
//~param Buffer Pointer to the buffer for PLC-data. The internal buffer is used, if Nil (default).
procedure TNoDave.WriteBytes(Buffer: Pointer);
begin
  If not Assigned(Buffer) then Buffer:=FBuffer;
  If Active then
  begin
    DoWriteBytes(FArea, FDBNumber, FBufOffs, FBufLen, Buffer);
    DoOnWrite;
  end;
end;

//Write the buffer into the PLC at the specified address after setting up the properties with the given values.
//~param Area Requested PLC-area. Changes the property ~[link .Area Area].
//~param DB Number of requested datablock. Changes the property ~[link .DBNumber DBNumber]. Only used, if writing into datablocks of the PLC.
//~param Start Start-address of the buffer within the address-range of the PLC. Changes the property ~[link BufOffs].
//~param Size Length of the buffer in bytes. Changes the property ~[link .BufLen BufLen].
//~param Buffer Pointer to the buffer for PLC-data. The internal buffer is used, if Nil (default).
procedure TNoDave.WriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
begin
  If not Assigned(Buffer) then
  begin
    FArea:=Area;
    FDBNumber:=DB;
    FBufOffs:=Start;
    FBufLen:=Size;
    WriteBytes(Buffer);
  end else begin
    DoWriteBytes(Area, DB, Start, Size, Buffer);
  end;
end;

//Write a Bit-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Bit Bit-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteBit(Address, Bit: Integer; Value: Boolean);
begin
  WriteBit(FArea, FDBNumber, Address, Bit, Value);
end;

//Write a Byte-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteByte(Address: Integer; Value: Byte);
begin
  DoWriteValue(Address, 1, @Value);
end;

//Write a LongInt-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteDInt(Address, Value: Integer);
var
  Dummy: LongInt;
begin
  Dummy:=daveSwapIed_32(Value);
  DoWriteValue(Address, 4, @Dummy);
end;

//Write a LongWord-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteDWord(Address: Integer; Value: LongWord);
var
  Dummy: LongInt;
begin
  Dummy:=daveSwapIed_32(Value);
  DoWriteValue(Address, 4, @Dummy);
end;

//Write a Float-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteFloat(Address: Integer; Value: Single);
var
  Dummy: LongInt;
  FltVal: Single absolute Dummy;
begin
  FltVal:=Value;
  Dummy:=daveSwapIed_32(Dummy);
  DoWriteValue(Address, 4, @Dummy);
end;

//Write a SmallInt-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteInt(Address: Integer; Value: SmallInt);
var
  Dummy: SmallInt;
begin
  Dummy:=daveSwapIed_16(Value);
  DoWriteValue(Address, 2, @Dummy);
end;

//Write a Word-value into the PLC at the specified address without changing the properties of the TNoDave-instance.
//~param Address Byte-address of the value
//~param Value Value to write into the PLC.
procedure TNoDave.WriteWord(Address: Integer; Value: Word);
var
  Dummy: SmallInt;
begin
  Dummy:=daveSwapIed_16(Value);
  DoWriteValue(Address, 2, @Dummy);
end;

//Return the length of a DB.
//~param DB The number of the DB.
//~result Length of the DB in Bytes.
function TNoDave.GetDBSize(DB: Integer): Integer;
var
  Info: daveBlockInfo;
begin
  try
    Result:=daveGetBlockInfo(DaveConn, @Info, daveBlockType_DB, DB);
    If Result = 0 then
    begin
      Result:=Info.length;
    end else Result:=0;
  except
  end;
end;

//Return the actual debug-options.
//~result Set of the actual debug-options.
function TNoDave.GetDebugOptions: TNoDaveDebugOptions;
begin
  Result:=[];
  If FDebugOptions and $0001 <> 0 then Result:=Result + [daveDebugRawRead];
  If FDebugOptions and $0002 <> 0 then Result:=Result + [daveDebugSpecialChars];
  If FDebugOptions and $0004 <> 0 then Result:=Result + [daveDebugRawWrite];
  If FDebugOptions and $0008 <> 0 then Result:=Result + [daveDebugListReachables];
  If FDebugOptions and $0010 <> 0 then Result:=Result + [daveDebugInitAdapter];
  If FDebugOptions and $0020 <> 0 then Result:=Result + [daveDebugConnect];
  If FDebugOptions and $0040 <> 0 then Result:=Result + [daveDebugPacket];
  If FDebugOptions and $0080 <> 0 then Result:=Result + [daveDebugByte];
  If FDebugOptions and $0100 <> 0 then Result:=Result + [daveDebugCompare];
  If FDebugOptions and $0200 <> 0 then Result:=Result + [daveDebugExchange];
  If FDebugOptions and $0400 <> 0 then Result:=Result + [daveDebugPDU];
  If FDebugOptions and $0800 <> 0 then Result:=Result + [daveDebugUpload];
  If FDebugOptions and $1000 <> 0 then Result:=Result + [daveDebugMPI];
  If FDebugOptions and $2000 <> 0 then Result:=Result + [daveDebugPrintErrors];
  If FDebugOptions and $4000 <> 0 then Result:=Result + [daveDebugPassive];
end;

//Set the debug-options to a new value.
//~param V The new set of debug-options.
procedure TNoDave.SetDebugOptions(V: TNoDaveDebugOptions);
var
  Result: Integer;
begin
  Result:=0;
  If daveDebugRawRead in V then Result:=Result + $0001;
  If daveDebugSpecialChars in V then Result:=Result + $0002;
  If daveDebugRawWrite in V then Result:=Result + $0004;
  If daveDebugListReachables in V then Result:=Result + $0008;
  If daveDebugInitAdapter in V then Result:=Result + $0010;
  If daveDebugConnect in V then Result:=Result + $0020;
  If daveDebugPacket in V then Result:=Result + $0040;
  If daveDebugByte in V then Result:=Result + $0080;
  If daveDebugCompare in V then Result:=Result + $0100;
  If daveDebugExchange in V then Result:=Result + $0200;
  If daveDebugPDU in V then Result:=Result + $0400;
  If daveDebugUpload in V then Result:=Result + $0800;
  If daveDebugMPI in V then Result:=Result + $1000;
  If daveDebugPrintErrors in V then Result:=Result + $2000;
  If daveDebugPassive in V then Result:=Result + $4000;
  DoSetDebug(Result);
end;

//Read a SZL-list from the connected PLC.
//~param ID The SZL-ID of the list.
//~param Index The SZL-Index of the list.
//~result Error code for the function result, 0 if OK.
function TNoDave.ReadSZL(ID, Index: Integer): Integer;
var
  WasActive: Boolean;
  HeaderID: Integer;
  Size, Count: Integer;
  Buffer: Pointer;
begin
  WasActive:=Active;
  Active:=True;
  FreeMem(FSZLBuffer);
  FSZLBuffer:=Nil;
  GetMem(Buffer, 8{000});
  HeaderID:=ID; // or $0F00;
  try
    LockNoDave.Enter;
    Count:=daveReadSZL(daveConn, HeaderID, Index, Buffer, 8);
    LockNoDave.Leave;
    If Count = 0 then
    begin
      Size:=GetWord(4, Buffer, 0, 8);
      Count:=GetWord(6, Buffer, 0, 8);
      GetMem(FSZLBuffer, (Size * Count) + 8);
    end;
  except
    Result:=-1;
    Exit;
  end;
  If Assigned(FSZLBuffer) then
  begin
    LockNoDave.Enter;
    Result:=daveReadSZL(daveConn, ID, Index, FSZLBuffer, (Size * Count) + 8);
    LockNoDave.Leave;
  end;
  If Result <> 0 then
  begin
    FreeMem(FSZLBuffer);
    FSZLBuffer:=nil;
  end;
  FreeMem(Buffer);
  Active:=WasActive;
end;


//Return the text message for an error code.
//~param Error The error code.
//~result Text message correspondig to the error code.
function TNoDave.GetErrorMsg(Error: Integer): String;
begin
  Result:=daveStrerror(FLastError);
end;

//Return the count of items in the SZL buffer
//~result Actual item count.
function TNoDave.GetSZLCount: Integer;
begin
  Result:=0;
  try
    If Assigned(FSZLBuffer) then
    begin
      Result:=GetWord(6, FSZLBuffer, 0, 8);
    end;
  except
  end;
end;

//Return the size of one single item in the SZL buffer.
//~result Actual item size.
function TNoDave.GetSZLItemSize: Integer;
begin
  Result:=0;
  try
    If Assigned(FSZLBuffer) then
    begin
      Result:=GetWord(4, FSZLBuffer, 0, 8);
    end;
  except
  end;
end;

//Return a pointer to an item in the SZL buffer.
//~param Index The SZL-Index of the list.
//~result Pointer to the Item[Index].
function TNoDave.GetSZLItem(Index: Integer): Pointer;
var
  BufIdx: Integer;
begin
  try
    If (Index >= 0) and (SZLCount > Index) then
    begin
      BufIdx:=(Index * SZLItemSize) + 8;
      Result:=Pointer(Integer(FSZLBuffer) + BufIdx);
    end;
  except
    Result:=Nil;
  end;
end;

//Reset the NetLink-adapter via network-command
procedure TNoDave.ResetInterface;
begin
  If (Protocol in [daveProtoIBH, daveProtoIBH_PPI]) and not Active then
  begin
    DoConnect(True);
    daveResetIBH(DaveIntf);
    daveFree(DaveIntf);
    closePort(DaveFDS.rfd);
    Sleep(5000);
  end;
end;

//Return the max. datasize in a single read-request.
//~result maximal datasize.
function TNoDave.GetMaxPDUData: Integer;
begin
  Result:=0;
  If Assigned(DaveConn) then
  begin
    Result:=DaveConn^.maxPDUlength - 24;
    If Protocol in [daveProtoIBH, daveProtoIBH_PPI] then Result:=220;
  end;
  if Result <= 0 then Result:=200;
end;

{$IFDEF FPC}
initialization
  {$I nodavecomponent.lrs}
{$ENDIF}
end.

// 24.02.2005 15:15:12 [c:\programme\borland\delphi6\User\gsfexperts\NoDave\LibNoDave.pas]
//     Created !
// 02.03.2005 15:57:15 [c:\programme\borland\delphi6\User\gsfexperts\NoDave\LibNoDave.pas]
//     Cyclic reading implemented in an own thread.
// 13.04.2005 16:47:25 [c:\programme\borland\delphi6\User\gsfexperts\NoDave\LibNoDave.pas]
//     DelphiDoc - comments added.
// 02.05.2005 11:47:36 [c:\programme\borland\delphi6\user\gsfexperts\nodave\LibNoDave.pas]
//     Property for the debug-options added.
// 03.05.2005 08:59:45 [c:\programme\borland\delphi6\user\gsfexperts\nodave\nodavecomponent.pas]
//     Compatibility with FreePascal/Lazarus implemented and renamed to nodavecomponent.
// 22.09.2005 09:05:19 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     BugFixes in TNoDave.ReadBytes and TNoDave.WriteBytes.
// 22.09.2005 09:16:15 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     Closing the serial port or the socket and cleaning up memory used by libnodave in TNoDave.Disconnect now.
// 24.10.2005 08:15:29 [c:\programme\borland\delphi6\User\gsfexperts\NoDave\NoDaveComponent.pas]
//     Handle = 0 for daveProtoS7Online allowed.
// 28.11.2005 10:37:45 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     Function for reading of SZL-lists added.
// 02.12.2005 09:21:42 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     Usage of daveReadManyBytes implemented.
// 06.12.2005 18:25:20 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     Changed private functions DoOnRead and DoOnWrite.
// 21.02.2006 18:18:50 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     Procedure TNoDave.ResetInterface implemented.
// 21.02.2006 19:44:04 [c:\programme\borland\delphi6\user\gsfexperts\nodave\NoDaveComponent.pas]
//     Added function TNoDave.MaxPDUData.
// 27.10.2006 09:21:43 [C:\Programme\Borland\BDS\User\GsfExperts\NoDave\NoDaveComponent.pas]
//     Bugfix in TNoDaveReadThread.Execute. Thanks to Jose for the hint !
// 20.12.2006 09:19:09 [C:\Programme\Borland\BDS\User\GsfExperts\NoDave\NoDaveComponent.pas]
//     Using a windows-handle in OpenS7Online.
