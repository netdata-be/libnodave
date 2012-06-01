/*
 This implements a "glue" layer between libnodave.dll and applications written
 in MS .Net languages.
 
 Part of Libnodave, a free communication libray for Siemens S7 200/300/400 via
 the MPI adapter 6ES7 972-0CA22-0XAC
 or  MPI adapter 6ES7 972-0CA23-0XAC
 or  TS adapter 6ES7 972-0CA33-0XAC
 or  MPI adapter 6ES7 972-0CA11-0XAC,
 IBH/MHJ-NetLink or CPs 243, 343 and 443
 or VIPA Speed7 with builtin ethernet support.
  
 (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2002..2005

 Libnodave is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as published by
 the Free Software Foundation; either version 2, or (at your option)
 any later version.

 Libnodave is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU Library General Public License
 along with Libnodave; see the file COPYING.  If not, write to
 the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
*/

using System;
using System.Runtime.InteropServices;

public class libnodave {
/*
    This struct contains whatever your Operating System uses to hold an in and outgoing 
    connection to external devices.
*/
    public struct daveOSserialType {
	public int rfd;
	public int wfd;
    }
/*
    Protocol types to be used with new daveInterface:
*/
    public static readonly int daveProtoMPI=0;		/* MPI for S7 300/400 */    
    public static readonly int daveProtoMPI2 = 1;	/* MPI for S7 300/400, "Andrew's version" */
    public static readonly int daveProtoMPI3 = 2;	/* MPI for S7 300/400, Step 7 Version, experimental */
    public static readonly int daveProtoMPI4 = 3;	/* MPI for S7 300/400, "Andrew's version" with STX */
    public static readonly int daveProtoPPI = 10;	/* PPI for S7 200 */
    
    public static readonly int daveProtoAS511 = 20;	/* S5 via programming interface */
    public static readonly int daveProtoS7online = 50;	/* use s7onlinx.dll for transport */

    public static readonly int daveProtoISOTCP = 122;	/* ISO over TCP */
    public static readonly int daveProtoISOTCP243 = 123;	/* ISO over TCP with CP243 */

    public static readonly int daveProtoMPI_IBH = 223;	/* MPI with IBH NetLink MPI to ethernet gateway */
    public static readonly int daveProtoPPI_IBH = 224;	/* PPI with IBH NetLink PPI to ethernet gateway */

    public static readonly int daveProtoUserTransport = 255;	/* Libnodave will pass the PDUs of */
								/* S7 Communication to user defined */
								/* call back functions. */
/*
 *    ProfiBus speed constants. This is the baudrate on MPI network, NOT between adapter and PC:
*/
    public static readonly int daveSpeed9k = 0;
    public static readonly int daveSpeed19k =   1;
    public static readonly int daveSpeed187k =   2;
    public static readonly int daveSpeed500k =  3;
    public static readonly int daveSpeed1500k =  4;
    public static readonly int daveSpeed45k =    5;
    public static readonly int daveSpeed93k =   6;
    
/*
    Some function codes (yet unused ones may be incorrect).
*/
    public static readonly int daveFuncOpenS7Connection	= 0xF0;
    public static readonly int daveFuncRead		= 0x04;
    public static readonly int daveFuncWrite		= 0x05;
    public static readonly int daveFuncRequestDownload	= 0x1A;
    public static readonly int daveFuncDownloadBlock	= 0x1B;
    public static readonly int daveFuncDownloadEnded	= 0x1C;
    public static readonly int daveFuncStartUpload	= 0x1D;
    public static readonly int daveFuncUpload		= 0x1E;
    public static readonly int daveFuncEndUpload	= 0x1F;
    public static readonly int daveFuncInsertBlock	= 0x28;
/*
    S7 specific constants:
*/
    public static readonly int daveBlockType_OB  = '8';
    public static readonly int daveBlockType_DB  = 'A';
    public static readonly int daveBlockType_SDB = 'B';
    public static readonly int daveBlockType_FC  = 'C';
    public static readonly int daveBlockType_SFC = 'D';
    public static readonly int daveBlockType_FB  = 'E';
    public static readonly int daveBlockType_SFB = 'F';
/*
    Use these constants for parameter "area" in daveReadBytes and daveWriteBytes
*/    
    public static readonly int daveSysInfo = 0x3;	/* System info of 200 family */
    public static readonly int daveSysFlags =  0x5;	/* System flags of 200 family */
    public static readonly int daveAnaIn =  0x6;	/* analog inputs of 200 family */
    public static readonly int daveAnaOut =  0x7;	/* analog outputs of 200 family */
    public static readonly int daveP = 0x80;    	/* direct peripheral access */
    public static readonly int daveInputs = 0x81;   
    public static readonly int daveOutputs = 0x82;    
    public static readonly int daveFlags = 0x83;
    public static readonly int daveDB = 0x84;		/* data blocks */
    public static readonly int daveDI = 0x85;	/* instance data blocks */
    public static readonly int daveLocal = 0x86; 	/* not tested */
    public static readonly int daveV = 0x87;	/* don't know what it is */
    public static readonly int daveCounter = 28;	/* S7 counters */
    public static readonly int daveTimer = 29;	/* S7 timers */
    public static readonly int daveCounter200 = 30;	/* IEC counters (200 family) */
    public static readonly int daveTimer200 = 31;	/* IEC timers (200 family) */
/**
    Library specific:
**/
/*
    Result codes. Genarally, 0 means ok, 
    >0 are results (also errors) reported by the PLC
    <0 means error reported by library code.
*/
public static readonly int daveResOK = 0;			/* means all ok */
public static readonly int daveResNoPeripheralAtAddress = 1;	/* CPU tells there is no peripheral at address */
public static readonly int daveResMultipleBitsNotSupported = 6; /* CPU tells it does not support to read a bit block with a */
								/* length other than 1 bit. */
public static readonly int daveResItemNotAvailable200 = 3;	/* means a a piece of data is not available in the CPU, e.g. */
								/* when trying to read a non existing DB or bit bloc of length<>1 */
								/* This code seems to be specific to 200 family. */
					    
public static readonly int daveResItemNotAvailable = 10;	/* means a a piece of data is not available in the CPU, e.g. */
								/* when trying to read a non existing DB */

public static readonly int daveAddressOutOfRange = 5;		/* means the data address is beyond the CPUs address range */
public static readonly int daveWriteDataSizeMismatch = 7;	/* means the write data size doesn't fit item size */
public static readonly int daveResCannotEvaluatePDU = -123;     /* PDU is not understood by libnodave */
public static readonly int daveResCPUNoData = -124; 
public static readonly int daveUnknownError = -125; 
public static readonly int daveEmptyResultError = -126;
public static readonly int daveEmptyResultSetError = -127;
public static readonly int daveResUnexpectedFunc = -128;
public static readonly int daveResUnknownDataUnitSize = -129;

public static readonly int daveResShortPacket = -1024;
public static readonly int daveResTimeout = -1025;
/*
    Error code to message string conversion:
    Call this function to get an explanation for error codes returned by other functions.
*/    
/*
    [DllImport("libnodave.dll")]
    public static extern string 
    daveStrerror(int res);
*/
    [DllImport("libnodave.dll", EntryPoint="daveStrerror" )]
    public static extern IntPtr
    _daveStrerror(int res);
    public static string daveStrerror(int res) {
//        return Marshal.PtrToStringAuto(_daveStrerror(res));
        return Marshal.PtrToStringAnsi(_daveStrerror(res)); //hope this fixes bug with intzerpreting string as unicode. Thanks to Luca Domenichini
    }

    
/*
    Copy an internal String into an external string buffer. This is needed to interface
    with Visual Basic. Maybe it is helpful elsewhere, too.
    C# can well work with C strings.
*/
//EXPORTSPEC void DECL2 daveStringCopy(char * intString, char * extString);
    
/* 
    Max number of bytes in a single message. 
*/
    public static readonly int daveMaxRawLen = 2048;

/*
    Some definitions for debugging:
*/
    public static readonly int daveDebugRawRead = 0x01;	/* Show the single bytes received */
    public static readonly int daveDebugSpecialChars = 0x02;	/* Show when special chars are read */
    public static readonly int daveDebugRawWrite = 0x04;	/* Show the single bytes written */
    public static readonly int daveDebugListReachables = 0x08;	/* Show the steps when determine devices in MPI net */
    public static readonly int daveDebugInitAdapter = 0x10;	/* Show the steps when Initilizing the MPI adapter */
    public static readonly int daveDebugConnect = 0x20;	/* Show the steps when connecting a PLC */
    public static readonly int daveDebugPacket = 0x40;
    public static readonly int daveDebugByte = 0x80;
    public static readonly int daveDebugCompare = 0x100;
    public static readonly int daveDebugExchange = 0x200;
    public static readonly int daveDebugPDU = 0x400;	/* debug PDU handling */
    public static readonly int daveDebugUpload = 0x800;	/* debug PDU loading program blocks from PLC */
    public static readonly int daveDebugMPI = 0x1000;
    public static readonly int daveDebugPrintErrors = 0x2000;	/* Print error messages */
    public static readonly int daveDebugPassive = 0x4000;

    public static readonly int daveDebugErrorReporting = 0x8000;
    public static readonly int daveDebugOpen = 0x10000;

    public static readonly int daveDebugAll = 0x1ffff;
/*
    set and read debug level:
*/
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern void daveSetDebug(int newDebugLevel);
    
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern int daveGetDebug();

    public static int  daveMPIReachable = 0x30;
    public static int  daveMPIunused = 0x10;
    public static int  davePartnerListSize = 126;
    
/*
    This wrapper class is used to avoid dealing with "unsafe" pointers to libnodave
    internal structures. More wrapper classes are derived from this for the different 
    structures. Constructors of derived classes will call functions in libnodave that 
    allocate internal structures via malloc. The functions used return integers by 
    declaration. These integers are stored in "pointer" In fact, these integers contain 
    the "bit patterns" of the pointers. The compiler is deceived about the real nature of 
    the return values. This is ok as long as the pointers are only used in libnodave, 
    because libnodave routines are assumed to know what they may do with them.
    The destructor here passes the pointers back to libnodave's daveFree to release memory
    when the C# object is destructed.
*/    
    public class pseudoPointer {
	public IntPtr pointer;
        [DllImport("libnodave.dll"/*, PreserveSig=false*/)]
	protected static extern int daveFree(IntPtr p);
	
	~pseudoPointer(){
//	    Console.WriteLine("~pseudoPointer()"+pointer);
	    daveFree(pointer);
	}
	
    }

    public class daveInterface: pseudoPointer  {
	
//	[DllImport("libnodave.dll"//, PreserveSig=false)]
/*
	I cannot say why, but when I recompiled the existing code with latest libnodave.dll
	(after using stdcall so that VC++ producs these "decorated names", I got a runtime
	error about not finding daveNewInterface. When I state full name entry point explicitly,
	(like below) it runs. The most strange thing is that all other functions work well...
*/
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	
	static extern IntPtr daveNewInterface(
	    daveOSserialType fd,
	    string name,
	    int localMPI,
	    int  useProto,
	    int speed
        );
	public daveInterface(daveOSserialType fd,
	    string name,
	    int localMPI,
	    int  useProto,
	    int speed) {
	    pointer=daveNewInterface(fd, name, localMPI, useProto, speed);
	}
	
/*
This was just here to check inheritance	
	~daveInterface(){
	    Console.WriteLine("destructor("+daveGetName(pointer)+")");
	    Console.WriteLine("~daveInterface()"+pointer);
	    daveFree(pointer);
	}
*/	
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveInitAdapter(IntPtr di);
	public int initAdapter() {
	    return daveInitAdapter(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected  static extern int daveListReachablePartners(IntPtr di, byte[] buffer);
	public int listReachablePartners(byte[] buffer) {
	    return daveListReachablePartners(pointer,buffer);
	}

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern void daveSetTimeout(IntPtr di, int time);
	public void setTimeout(int time) {
	    daveSetTimeout(pointer, time);
	}    

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetTimeout(IntPtr di);
	public int getTimeout() {
	    return daveGetTimeout(pointer);
	}    
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern IntPtr daveDisconnectAdapter(IntPtr di);
	public IntPtr disconnectAdapter() {
	    return daveDisconnectAdapter(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern string daveGetName(IntPtr di);
	public string getName() {
	    return daveGetName(pointer);
	}
	
    }
    
    public class daveConnection:pseudoPointer {
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern IntPtr daveNewConnection(
	    IntPtr di,
	    int MPI,
	    int rack,
	    int slot
	);
	public daveConnection(
	    daveInterface di,
	    int MPI,
	    int rack,
	    int slot
	) {
	    pointer=daveNewConnection(
	    di.pointer, MPI, rack, slot
	);
	}
/* This wa here to test inheritance
	~daveConnection(){
	    Console.WriteLine("~daveConnection()"+pointer);
	    daveFree(pointer);
	    daveFree(pointer);
	}
*/	
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveConnectPLC(IntPtr dc);
	public int connectPLC(){
	    return daveConnectPLC(pointer);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveDisconnectPLC(IntPtr dc);
	public int disconnectPLC() {
	    return daveDisconnectPLC(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern int daveReadBytes(IntPtr dc, int area, int DBnumber, int start, int len, byte[] buffer);
	public int readBytes(int area, int DBnumber, int start, int len, byte[] buffer) {
	    return daveReadBytes(pointer, area, DBnumber, start, len, buffer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern int daveReadManyBytes(IntPtr dc, int area, int DBnumber, int start, int len, byte[] buffer);
	public int readManyBytes(int area, int DBnumber, int start, int len, byte[] buffer) {
	    return daveReadManyBytes(pointer, area, DBnumber, start, len, buffer);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern int daveReadBits(IntPtr dc, int area, int DBnumber, int start, int len, byte[] buffer);
	public int readBits(int area, int DBnumber, int start, int len, byte[] buffer) {
	    return daveReadBits(pointer, area, DBnumber, start, len, buffer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern int daveWriteBytes(IntPtr dc, int area, int DBnumber, int start, int len, byte[] buffer);
	public int writeBytes(int area, int DBnumber, int start, int len, byte[] buffer) {
	    return daveWriteBytes(pointer, area, DBnumber, start, len, buffer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern int daveWriteManyBytes(IntPtr dc, int area, int DBnumber, int start, int len, byte[] buffer);
	public int writeManyBytes(int area, int DBnumber, int start, int len, byte[] buffer) {
	    return daveWriteManyBytes(pointer, area, DBnumber, start, len, buffer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern int daveWriteBits(IntPtr dc, int area, int DBnumber, int start, int len, byte[] buffer);
	public int writeBits(int area, int DBnumber, int start, int len, byte[] buffer) {
	    return daveWriteBits(pointer, area, DBnumber, start, len, buffer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetS32(IntPtr dc);
	public int getS32() {
	    return daveGetS32(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetU32(IntPtr dc);
        public int getU32() {
	    return daveGetU32(pointer);
	}	
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetS16(IntPtr dc);
	public int getS16() {
	    return daveGetS16(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetU16(IntPtr dc);
	public int getU16() {
	    return daveGetU16(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetS8(IntPtr dc);
	public int getS8() {
	    return daveGetS8(pointer);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetU8(IntPtr dc);
	public int getU8() {
	    return daveGetU8(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern float daveGetFloat(IntPtr dc);
	public float getFloat() {
	    return daveGetFloat(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetCounterValue(IntPtr dc);
	public int getCounterValue() {
	    return daveGetCounterValue(pointer);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern float daveGetSeconds(IntPtr dc);
	public float getSeconds() {
	    return daveGetSeconds(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetS32At(IntPtr dc,int pos);
	public int getS32At(int pos) {
	    return daveGetS32At(pointer, pos);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetU32At(IntPtr dc, int pos);
        public int getU32At(int pos) {
	    return daveGetU32At(pointer, pos);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetS16At(IntPtr dc, int pos);
	public int getS16At(int pos) {
	    return daveGetS16At(pointer, pos);
	}
    	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetU16At(IntPtr dc, int pos);
        public int getU16At(int pos) {
	    return daveGetU16At(pointer, pos);
	}

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetS8At(IntPtr dc, int pos);
        public int getS8At(int pos) {
	    return daveGetS8At(pointer, pos);
	}
    	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetU8At(IntPtr dc, int pos);
        public int getU8At(int pos) {
	    return daveGetU8At(pointer, pos);
	}

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern float daveGetFloatAt(IntPtr dc, int pos);
        public float getFloatAt(int pos) {
	    return daveGetFloatAt(pointer, pos);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetCounterValueAt(IntPtr dc, int pos);
        public int getCounterValueAt(int pos) {
	    return daveGetCounterValueAt(pointer, pos);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern float daveGetSecondsAt(IntPtr dc, int pos);
        public float getSecondsAt(int pos) {
	    return daveGetSecondsAt(pointer, pos);
	}

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetAnswLen(IntPtr dc);
        public int getAnswLen() {
	    return daveGetAnswLen(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetMaxPDULen(IntPtr dc);
        public int getMaxPDULen() {
	    return daveGetMaxPDULen(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int davePrepareReadRequest(IntPtr dc, IntPtr p);
	public PDU prepareReadRequest() {
	    PDU p=new PDU();
	    davePrepareReadRequest(pointer, p.pointer);
	    return p;
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int davePrepareWriteRequest(IntPtr dc, IntPtr p);
	public PDU prepareWriteRequest() {
	    PDU p=new PDU();
	    davePrepareWriteRequest(pointer, p.pointer);
	    return p;
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveExecReadRequest(IntPtr dc, IntPtr p, IntPtr rl);
	public int execReadRequest(PDU p, resultSet rl) {
	    return daveExecReadRequest(pointer, p.pointer, rl.pointer);
	}
    
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveExecWriteRequest(IntPtr dc, IntPtr p, IntPtr rl);
	public int execWriteRequest(PDU p, resultSet rl) {
	    return daveExecWriteRequest(pointer, p.pointer, rl.pointer);
        }
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveUseResult(IntPtr dc, IntPtr rs, int number);	
	public int useResult(resultSet rs, int number) {
	    return daveUseResult(pointer, rs.pointer, number);
        }

	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveReadSZL(IntPtr dc,int id,int index,byte[] ddd, int len);
	public int readSZL(int id,int index,byte[] ddd, int len) {
	    return daveReadSZL(pointer,id,index, ddd, len);
	}	
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveStart(IntPtr dc);
	public int start() {
	    return daveStart(pointer);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveStop(IntPtr dc);
        public int stop() {
	    return daveStop(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveForce200(IntPtr dc, int area, int start, int val);
	public int force200(int area, int start, int val) {
	    return daveForce200(pointer, area, start, val);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveForceDisconnectIBH(IntPtr dc, int src, int dest, int MPI);
	public int forceDisconnectIBH(int src, int dest, int MPI) {
	    return daveForceDisconnectIBH(pointer, src, dest, MPI);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetResponse(IntPtr dc);
	public int getGetResponse() {
	    return daveGetResponse(pointer);
	}

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveSendMessage(IntPtr dc, IntPtr p);
	public int getMessage(PDU p) {
	    return daveSendMessage(pointer, p.pointer);
	}
	
	[DllImport("libnodave.dll")]
	protected static extern int daveGetProgramBlock(IntPtr dc, int blockType, int number, byte[] buffer, ref int length);
	public int getProgramBlock(int blockType, int number, byte[] buffer, ref int length) {
	    Console.WriteLine("length:"+length);
	    int a=daveGetProgramBlock(pointer, blockType, number, buffer, ref length);
	    Console.WriteLine("length:"+length);
	    return a;
	}
	
	[DllImport("libnodave.dll")]
	protected static extern int daveListBlocksOfType(IntPtr dc, int blockType, byte[] buffer);
	public int ListBlocksOfType(int blockType, byte[] buffer) {
	    return daveListBlocksOfType(pointer, blockType, buffer);
//	    return -1;
	}

    }

    public class PDU:pseudoPointer {
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern IntPtr daveNewPDU();

	public PDU() {
	    pointer=daveNewPDU();
	}

/*	~PDU(){
	    Console.WriteLine("~PDU()");
	    daveFree(pointer);
	}
*/
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern void daveAddVarToReadRequest(IntPtr p, int area, int DBnum, int start, int bytes);
	public void addVarToReadRequest(int area, int DBnum, int start, int bytes) {
	    daveAddVarToReadRequest(pointer, area, DBnum, start, bytes);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern void daveAddBitVarToReadRequest(IntPtr p, int area, int DBnum, int start, int bytes);
	public void addBitVarToReadRequest(int area, int DBnum, int start, int bytes) {
	    daveAddBitVarToReadRequest(pointer, area, DBnum, start, bytes);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern void daveAddVarToWriteRequest(IntPtr p, int area, int DBnum, int start, int bytes, byte[] buffer);
	public void addVarToWriteRequest(int area, int DBnum, int start, int bytes, byte[] buffer) {
	    daveAddVarToWriteRequest(pointer, area, DBnum, start, bytes, buffer);
	}
    
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern void daveAddBitVarToWriteRequest(IntPtr p, int area, int DBnum, int start, int bytes, byte[] buffer);
	public void addBitVarToWriteRequest(int area, int DBnum, int start, int bytes, byte[] buffer) {
	    daveAddBitVarToWriteRequest(pointer, area, DBnum, start, bytes, buffer);
	}
	
    } // class PDU

    public class resultSet:pseudoPointer {
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern IntPtr daveNewResultSet();
	public resultSet() {
	    pointer=daveNewResultSet();
	}

	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
        protected static extern void daveFreeResults(IntPtr rs);
	~resultSet(){
//	    Console.WriteLine("~resultSet(1)");
	    daveFreeResults(pointer);
//	    Console.WriteLine("~resultSet(2)");
//	    daveFree(pointer);
	}
	
	[DllImport("libnodave.dll"/*, PreserveSig=false */ )]
	protected static extern int daveGetErrorOfResult(IntPtr rs, int number);
	public int getErrorOfResult(int number) {
	    return daveGetErrorOfResult(pointer, number);
	}	
    
    }

    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern int setPort(
	[MarshalAs(UnmanagedType.LPStr)] string portName,
	[MarshalAs(UnmanagedType.LPStr)] string baud,
	int parity
    );
    
    [DllImport("libnodave.dll" /*, PreserveSig=false */ )]
    public static extern int openSocket(
	int port,
	[MarshalAs(UnmanagedType.LPStr)] string portName
    );

    [DllImport("libnodave.dll" /*, PreserveSig=false */ )]
    public static extern int openS7online(
	[MarshalAs(UnmanagedType.LPStr)] string portName
    );

    [DllImport("libnodave.dll" /*, PreserveSig=false */ )]
    public static extern int closePort(
	int port
    );
    
    [DllImport("libnodave.dll" /*, PreserveSig=false */ )]
    public static extern int closeSocket(
	int port
    );

    [DllImport("libnodave.dll" )]
    public static extern int closeS7online(
	int port
    );

        
        
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern float toPLCfloat(float f);
    
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern int daveToPLCfloat(float f);
    
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern int daveSwapIed_32(int i);
    
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    public static extern int daveSwapIed_16(int i);

    public static int getS16from(byte[] b, int pos) {
	if (BitConverter.IsLittleEndian) {
	    byte[] b1=new byte[2];
	    b1[1]=b[pos+0];
	    b1[0]=b[pos+1];
	    return BitConverter.ToInt16(b1, 0);
	}    
	else 
	    return BitConverter.ToInt16(b, pos);
    }
    
    public static int getU16from(byte[] b, int pos) {
	if (BitConverter.IsLittleEndian) {
	    byte[] b1=new byte[2];
	    b1[1]=b[pos+0];
	    b1[0]=b[pos+1];
	    return BitConverter.ToUInt16(b1, 0);
	}    
	else 
	    return BitConverter.ToUInt16(b, pos);
    }
        
    public static int getS32from(byte[] b, int pos) {
	if (BitConverter.IsLittleEndian) {
	    byte[] b1=new byte[4];
	    b1[3]=b[pos];
	    b1[2]=b[pos+1];
	    b1[1]=b[pos+2];
	    b1[0]=b[pos+3];
	    return BitConverter.ToInt32(b1, 0);
	}    
	else 
	    return BitConverter.ToInt32(b, pos);
    }
    
    public static uint getU32from(byte[] b, int pos) {
	if (BitConverter.IsLittleEndian) {
	    byte[] b1=new byte[4];
	    b1[3]=b[pos];
	    b1[2]=b[pos+1];
	    b1[1]=b[pos+2];
	    b1[0]=b[pos+3];
	    return BitConverter.ToUInt32(b1, 0);
	}    
	else 
	    return BitConverter.ToUInt32(b, pos);
    }
    
    public static float getFloatfrom(byte[] b, int pos) {
	if (BitConverter.IsLittleEndian) {
	    byte[] b1=new byte[4];
	    b1[3]=b[pos];
	    b1[2]=b[pos+1];
	    b1[1]=b[pos+2];
	    b1[0]=b[pos+3];
	    return BitConverter.ToSingle(b1, 0);
	}    
	else 
	    return BitConverter.ToSingle(b, pos);
    }
    
    
    [DllImport("libnodave.dll"/*, PreserveSig=false */ )]
    private static extern int daveAreaName(int area);
    
    [DllImport("libnodave.dll")]
    private static extern int daveBlockName(int blockType);
    [DllImport("libnodave.dll")]
    private static extern void daveStringCopy(int i, byte[] c);
    
    public static string blockName(int blockType) {
	byte[] s=new byte[255];
	int i=daveBlockName(blockType);
	daveStringCopy(i, s);
	string st="";
	i=0;
	while (s[i]!=0) {
	    st=st+(char)s[i];
	    i++;
	}
	return st;
    }
    
    public static string areaName(int blockType) {
	byte[] s=new byte[255];
	int i=daveAreaName(blockType);
	daveStringCopy(i, s);
	string st="";
	i=0;
	while (s[i]!=0) {
	    st=st+(char)s[i];
	    i++;
	}
	return st;
    }
    
}

/* Changes:
    03/30/2006	bug fix: removed double calls to daveFree in nested destructors.
    11/21/2006	bug fix: applied patches from Johann Gail.
Version 0.8.4.5    
    07/10/09  	Added closeSocket()
*/    