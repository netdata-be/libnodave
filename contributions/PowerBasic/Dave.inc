'--------------------------------------------------------------------------------
' Dave.inc     4/08/06
' Test of LibNoDave Step7 MPI communication with PBWin 8.01
' credit for all the great code goes to:
' (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2005 '
'
' PBWin version writen by Bob Clarke RT Engineering Larvik Norway (rtc@rte.no)
' some variable and function names have been changed to avoid conflicts with PBW keywords
' all the errors in the translation are surely mine.
'--------------------------------------------------------------------------------

'--------------------------------------------------------------------------------

#IF NOT %DEF(%WINAPI)
    #INCLUDE "WIN32API.INC"
#ENDIF
#IF NOT %DEF(%COMMCTRL_INC)
    #INCLUDE "COMMCTRL.INC"
#ENDIF
#IF NOT %DEF(%PBForms_INC)
    #INCLUDE "PBForms.INC"
#ENDIF
#IF NOT %DEF(%COMDLG32_INC)
    #INCLUDE "COMDLG32.INC"
#ENDIF

#IF NOT %DEF(%Dave_INC)
    %DAVE_INC = 1

'--------------------------------------------------------------------------------
' Declarations
'--------------------------------------------------------------------------------
'    Set and read debug level:
'
DECLARE SUB daveSetDebug LIB "libnodave.dll" (BYVAL level AS LONG)
DECLARE FUNCTION daveGetDebug LIB "libnodave.dll" () AS LONG
'
' You may wonder what sense it might make to set debug level, as you cannot see
' messages when you opened excel or some VB application from Windows GUI.
' You can invoke Excel from the console or from a batch file with:
' <myPathToExcel>\Excel.Exe <MyPathToXLS-File>VBATest.XLS >ExcelOut
' This will start Excel with VBATest.XLS and all debug messages (and a few from Excel itself)
' go into the file ExcelOut.
'
'    Error code to message string conversion:
'    Call this function to get an explanation for error codes returned by other functions.
'
'
' The folowing doesn't work properly. A VB string is something different from a pointer to char:
'
' Declare Function daveStrerror Lib "libnodave.dll" Alias "daveStrerror" (ByVal en As Long) As String
'
DECLARE FUNCTION daveInternalStrerror LIB "libnodave.dll" ALIAS "daveStrerror" (BYVAL en AS LONG) AS LONG
' So, I added another function to libnodave wich copies the text into a VB String.
' This function is still not useful without some code araound it, so I call it "internal"
DECLARE SUB daveStringCopy LIB "libnodave.dll" ALIAS "daveStringCopy" (BYVAL internalPointer AS LONG, BYVAL s AS STRING)
'
' Setup a new interface structure using a handle to an open port or socket:
'
DECLARE FUNCTION daveNewInterface LIB "libnodave.dll" ALIAS "daveNewInterface"(BYVAL fd1 AS LONG, BYVAL fd2 AS LONG, BYVAL sname AS STRING, BYVAL localMPI AS LONG, BYVAL protocol AS LONG, BYVAL speed AS LONG) AS LONG
'
' Setup a new connection structure using an initialized daveInterface and PLC's MPI address.
' Note: The parameter di must have been obtained from daveNewinterface.
'
DECLARE FUNCTION daveNewConnection LIB "libnodave.dll" ALIAS "daveNewConnection" (BYVAL di AS LONG, BYVAL mpi AS LONG, BYVAL Rack AS LONG, BYVAL Slot AS LONG) AS LONG
'
'    PDU handling:
'    PDU is the central structure present in S7 communication.
'    It is composed of a 10 or 12 byte header,a parameter block and a data block.
'    When reading or writing values, the data field is itself composed of a data
'    header followed by payload data
'
'    retrieve the answer:
'    Note: The parameter dc must have been obtained from daveNewConnection.
'
DECLARE FUNCTION daveGetResponse LIB "libnodave.dll" ALIAS "daveGetResponse" (BYVAL DC AS LONG) AS LONG
'
'    send PDU to PLC
'    Note: The parameter dc must have been obtained from daveNewConnection,
'          The parameter pdu must have been obtained from daveNewPDU.
'
DECLARE FUNCTION daveSendMessage LIB "libnodave.dll" ALIAS "daveSendMessage" (BYVAL DC AS LONG, BYVAL pdu AS LONG) AS LONG
'******
'
'Utilities:
'
'****
'*
'    Hex dump PDU:
'
DECLARE SUB daveDumpPDU LIB "libnodave.dll" ALIAS "daveDumpPDU" (BYVAL pdu AS LONG)
'
'    Hex dump. Write the name followed by len bytes written in hex and a newline:
'
DECLARE SUB daveDump LIB "libnodave.dll" ALIAS "daveDump" (BYVAL sname AS STRING, BYVAL pdu AS LONG, BYVAL length AS LONG)
'
'    names for PLC objects. This is again the intenal function. Use the wrapper code below.
'
DECLARE FUNCTION daveInternalAreaName LIB "libnodave.dll" ALIAS "daveAreaName" (BYVAL en AS LONG) AS LONG
DECLARE FUNCTION daveInternalBlockName LIB "libnodave.dll" ALIAS "daveBlockName" (BYVAL en AS LONG) AS LONG
'
'   swap functions. They change the byte order, if byte order on the computer differs from
'   PLC byte order:
'
DECLARE FUNCTION daveSwapIed_16 LIB "libnodave.dll" ALIAS "daveSwapIed_16" (BYVAL x AS LONG) AS LONG
DECLARE FUNCTION daveSwapIed_32 LIB "libnodave.dll" ALIAS "daveSwapIed_32" (BYVAL x AS LONG) AS LONG
'
'    Data conversion convenience functions. The older set has been removed.
'    Newer conversion routines. As the terms WORD, INT, INTEGER etc have different meanings
'    for users of different programming languages and compilers, I choose to provide a new
'    set of conversion routines named according to the bit length of the value used. The 'U'
'    or 'S' stands for unsigned or signed.
'
'
'    Get a value from the position b points to. B is typically a pointer to a buffer that has
'    been filled with daveReadBytes:
'
DECLARE FUNCTION toPLCfloat LIB "libnodave.dll" ALIAS "toPLCfloat" (BYVAL f AS SINGLE) AS SINGLE
DECLARE FUNCTION daveToPLCfloat LIB "libnodave.dll" ALIAS "daveToPLCfloat" (BYVAL f AS SINGLE) AS LONG
'
' Copy and convert value of 8,16,or 32 bit, signed or unsigned at position pos
' from internal buffer:
'
DECLARE FUNCTION daveGetS8from LIB "libnodave.dll" ALIAS "daveGetS8from" (BYREF buffer AS BYTE) AS LONG
DECLARE FUNCTION daveGetU8from LIB "libnodave.dll" ALIAS "daveGetU8from" (BYREF buffer AS BYTE) AS LONG
DECLARE FUNCTION daveGetS16from LIB "libnodave.dll" ALIAS "daveGetS16from" (BYREF buffer AS BYTE) AS LONG
DECLARE FUNCTION daveGetU16from LIB "libnodave.dll" ALIAS "daveGetU16from" (BYREF buffer AS BYTE) AS LONG
DECLARE FUNCTION daveGetS32from LIB "libnodave.dll" ALIAS "daveGetS32from" (BYREF buffer AS BYTE) AS LONG
'
' Is there an unsigned long? Or a longer integer than long? This doesn't work.
' Declare Function daveGetU32from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
'
DECLARE FUNCTION daveGetFloatfrom LIB "libnodave.dll" ALIAS "daveGetFloatfrom" (BYREF buffer AS BYTE) AS SINGLE
'
' Copy and convert a value of 8,16,or 32 bit, signed or unsigned from internal buffer. These
' functions increment an internal buffer position. This buffer position is set to zero by
' daveReadBytes, daveReadBits, daveReadSZL.
'
DECLARE FUNCTION daveGetS8 LIB "libnodave.dll" ALIAS "daveGetS8" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveGetU8 LIB "libnodave.dll" ALIAS "daveGetU8" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveGetS16 LIB "libnodave.dll" ALIAS "daveGetS16" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveGetU16 LIB "libnodave.dll" ALIAS "daveGetU16" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveGetS32 LIB "libnodave.dll" ALIAS "daveGetS32" (BYVAL DC AS LONG) AS LONG
'
' Is there an unsigned long? Or a longer integer than long? This doesn't work.
'Declare Function daveGetU32 Lib "libnodave.dll" (ByVal dc As Long) As Long
DECLARE FUNCTION daveGetFloat LIB "libnodave.dll" ALIAS "daveGetFloat" (BYVAL DC AS LONG) AS SINGLE
'
' Read a value of 8,16,or 32 bit, signed or unsigned at position pos from internal buffer:
'
DECLARE FUNCTION daveGetS8At LIB "libnodave.dll" ALIAS "daveGetS8At" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS LONG
DECLARE FUNCTION daveGetU8At LIB "libnodave.dll" ALIAS "daveGetU8At" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS LONG
DECLARE FUNCTION daveGetS16At LIB "libnodave.dll" ALIAS "daveGetS16At" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS LONG
DECLARE FUNCTION daveGetU16At LIB "libnodave.dll" ALIAS "daveGetU16At" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS LONG
DECLARE FUNCTION daveGetS32At LIB "libnodave.dll" ALIAS "daveGetS32At" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS LONG
'
' Is there an unsigned long? Or a longer integer than long? This doesn't work.
'Declare Function daveGetU32At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
DECLARE FUNCTION daveGetFloatAt LIB "libnodave.dll" ALIAS "daveGetFloatAt" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS SINGLE
'
' Copy and convert a value of 8,16,or 32 bit, signed or unsigned into a buffer. The buffer
' is usually used by daveWriteBytes, daveWriteBits later.
'
DECLARE FUNCTION davePut8 LIB "libnodave.dll" ALIAS "davePut8" (BYREF buffer AS BYTE, BYVAL value AS LONG) AS LONG
DECLARE FUNCTION davePut16 LIB "libnodave.dll" ALIAS "davePut16" (BYREF buffer AS BYTE, BYVAL value AS LONG) AS LONG
DECLARE FUNCTION davePut32 LIB "libnodave.dll" ALIAS "davePut32" (BYREF buffer AS BYTE, BYVAL value AS LONG) AS LONG
DECLARE FUNCTION davePutFloat LIB "libnodave.dll" ALIAS "davePutFloat" (BYREF buffer AS BYTE, BYVAL value AS SINGLE) AS LONG
'
' Copy and convert a value of 8,16,or 32 bit, signed or unsigned to position pos of a buffer.
' The buffer is usually used by daveWriteBytes, daveWriteBits later.
'
DECLARE FUNCTION davePut8At LIB "libnodave.dll" ALIAS "davePut8At" (BYREF buffer AS BYTE, BYVAL POS AS LONG, BYVAL value AS LONG) AS LONG
DECLARE FUNCTION davePut16At LIB "libnodave.dll" ALIAS "davePut16At" (BYREF buffer AS BYTE, BYVAL POS AS LONG, BYVAL value AS LONG) AS LONG
DECLARE FUNCTION davePut32At LIB "libnodave.dll" ALIAS "davePut32At" (BYREF buffer AS BYTE, BYVAL POS AS LONG, BYVAL value AS LONG) AS LONG
DECLARE FUNCTION davePutFloatAt LIB "libnodave.dll" ALIAS "davePutFloatAt" (BYREF buffer AS BYTE, BYVAL POS AS LONG, BYVAL value AS SINGLE) AS LONG
'
' Takes a timer value and converts it into seconds:
'
DECLARE FUNCTION daveGetSeconds LIB "libnodave.dll" ALIAS "daveGetSeconds" (BYVAL DC AS LONG) AS SINGLE
DECLARE FUNCTION daveGetSecondsAt LIB "libnodave.dll" ALIAS "daveGetSecondsAt" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS SINGLE
'
' Takes a counter value and converts it to integer:
'
DECLARE FUNCTION daveGetCounterValue LIB "libnodave.dll" ALIAS "daveGetCounterValue" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveGetCounterValueAt LIB "libnodave.dll" ALIAS "daveGetCounterValueAt" (BYVAL DC AS LONG, BYVAL POS AS LONG) AS LONG
'
' Get the order code (MLFB number) from a PLC. Does NOT work with 200 family.
'
DECLARE FUNCTION daveGetOrderCode LIB "libnodave.dll" ALIAS "daveGetOrderCode" (BYVAL en AS LONG, BYREF buffer AS BYTE) AS LONG
'
' Connect to a PLC.
'
DECLARE FUNCTION daveConnectPLC LIB "libnodave.dll" ALIAS "daveConnectPLC" (BYVAL DC AS LONG) AS LONG
'
'
' Read a value or a block of values from PLC.
'
DECLARE FUNCTION daveReadBytes LIB "libnodave.dll" ALIAS "daveReadBytes" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYVAL buffer AS LONG) AS LONG
'
' Read a long block of values from PLC. Long means too long to transport in a single PDU.
'
DECLARE FUNCTION daveManyReadBytes LIB "libnodave.dll" ALIAS "daveManyReadBytes" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYVAL buffer AS LONG) AS LONG
'
' Write a value or a block of values to PLC.
'
DECLARE FUNCTION daveWriteBytes LIB "libnodave.dll" ALIAS "daveWriteBytes" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYREF buffer AS BYTE) AS LONG
'
' Write a long block of values to PLC. Long means too long to transport in a single PDU.
'
DECLARE FUNCTION daveWriteManyBytes LIB "libnodave.dll" ALIAS "daveWriteManyBytes" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYREF buffer AS BYTE) AS LONG
'
' Read a bit from PLC. numBytes must be exactly one with all PLCs tested.
' Start is calculated as 8*byte number+bit number.
'
DECLARE FUNCTION daveReadBits LIB "libnodave.dll" ALIAS "daveReadBits" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYVAL buffer AS LONG) AS LONG
'
' Write a bit to PLC. numBytes must be exactly one with all PLCs tested.
'
DECLARE FUNCTION daveWriteBits LIB "libnodave.dll" ALIAS "daveWriteBits" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYREF buffer AS BYTE) AS LONG
'
' Set a bit in PLC to 1.
'
DECLARE FUNCTION daveSetBit LIB "libnodave.dll" ALIAS "daveSetBit" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL byteAddress AS LONG, BYVAL bitAddress AS LONG) AS LONG
'
' Set a bit in PLC to 0.
'
DECLARE FUNCTION daveClrBit LIB "libnodave.dll" ALIAS "daveClrBit" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL byteAddress AS LONG, BYVAL bitAddress AS LONG) AS LONG
'
' Read a diagnostic list (SZL) from PLC. Does NOT work with 200 family.
'
DECLARE FUNCTION daveReadSZL LIB "libnodave.dll" ALIAS "daveReadSZL" (BYVAL DC AS LONG, BYVAL ID AS LONG, BYVAL index AS LONG, BYREF buffer AS BYTE) AS LONG
'
DECLARE FUNCTION daveListBlocksOfType LIB "libnodave.dll" ALIAS "daveListBlocksOfType" (BYVAL DC AS LONG, BYVAL typ AS LONG, BYREF buffer AS BYTE) AS LONG
DECLARE FUNCTION daveListBlocks LIB "libnodave.dll" ALIAS "daveListBlocks" (BYVAL DC AS LONG, BYREF buffer AS BYTE) AS LONG
DECLARE FUNCTION internalDaveGetBlockInfo LIB "libnodave.dll" ALIAS "daveGetBlockInfo" (BYVAL DC AS LONG, BYREF buffer AS BYTE, BYVAL ltype AS LONG, BYVAL number AS LONG) AS LONG
'
DECLARE FUNCTION daveGetProgramBlock LIB "libnodave.dll" ALIAS "daveGetProgramBlock" (BYVAL DC AS LONG, BYVAL blockType AS LONG, BYVAL number AS LONG, BYREF buffer AS BYTE, BYREF length AS LONG) AS LONG
'
' Start or Stop a PLC:
'
DECLARE FUNCTION daveStart LIB "libnodave.dll" ALIAS "daveStart" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveStop LIB "libnodave.dll" ALIAS "daveStop" (BYVAL DC AS LONG) AS LONG
'
' Set outputs (digital or analog ones) of an S7-200 that is in stop mode:
'
DECLARE FUNCTION daveForce200 LIB "libnodave.dll" ALIAS "daveForce200" (BYVAL DC AS LONG, BYVAL area AS LONG, BYVAL start AS LONG, BYVAL value AS LONG) AS LONG
'
' Initialize a multivariable read request.
' The parameter PDU must have been obtained from daveNew PDU:
'
DECLARE SUB davePrepareReadRequest LIB "libnodave.dll" ALIAS "davePrepareReadRequest" (BYVAL DC AS LONG, BYVAL pdu AS LONG)
'
' Add a new variable to a prepared request:
'
DECLARE SUB daveAddVarToReadRequest LIB "libnodave.dll" ALIAS "daveAddVarToReadRequest" (BYVAL pdu AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG)
'
' Executes the entire request:
'
DECLARE FUNCTION daveExecReadRequest LIB "libnodave.dll" ALIAS "daveExecReadRequest" (BYVAL DC AS LONG, BYVAL pdu AS LONG, BYVAL rs AS LONG) AS LONG
'
' Use the n-th result. This lets the functions daveGet<data type> work on that part of the
' internal buffer that contains the n-th result:
'
DECLARE FUNCTION daveUseResult LIB "libnodave.dll" ALIAS "daveUseResult" (BYVAL DC AS LONG, BYVAL rs AS LONG, BYVAL resultNumber AS LONG) AS LONG
'
' Frees the memory occupied by single results in the result structure. After that, you can reuse
' the resultSet in another call to daveExecReadRequest.
'
DECLARE SUB daveFreeResults LIB "libnodave.dll" ALIAS "daveFreeResults" (BYVAL rs AS LONG)
'
' Adds a new bit variable to a prepared request. As with daveReadBits, numBytes must be one for
' all tested PLCs.
'
DECLARE SUB daveAddBitVarToReadRequest LIB "libnodave.dll" ALIAS "daveAddBitVarToReadRequest" (BYVAL pdu AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG)
'
' Initialize a multivariable write request.
' The parameter PDU must have been obtained from daveNew PDU:
'
DECLARE SUB davePrepareWriteRequest LIB "libnodave.dll" ALIAS "davePrepareWriteRequest" (BYVAL DC AS LONG, BYVAL pdu AS LONG)
'
' Add a new variable to a prepared write request:
'
DECLARE SUB daveAddVarToWriteRequest LIB "libnodave.dll" ALIAS "daveAddVarToWriteRequest" (BYVAL pdu AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYREF buffer AS BYTE)
'
' Add a new bit variable to a prepared write request:
'
DECLARE SUB daveAddBitVarToWriteRequest LIB "libnodave.dll" ALIAS "daveAddBitVarToWriteRequest" (BYVAL pdu AS LONG, BYVAL area AS LONG, BYVAL areaNumber AS LONG, BYVAL start AS LONG, BYVAL numBytes AS LONG, BYREF buffer AS BYTE)
'
' Execute the entire write request:
'
DECLARE FUNCTION daveExecWriteRequest LIB "libnodave.dll" ALIAS "daveExecWriteRequest" (BYVAL DC AS LONG, BYVAL pdu AS LONG, BYVAL rs AS LONG) AS LONG
'
' Initialize an MPI Adapter or NetLink Ethernet MPI gateway.
' While some protocols do not need this, I recommend to allways use it. It will do nothing if
' the protocol doesn't need it. But you can change protocols without changing your program code.
'
DECLARE FUNCTION daveInitAdapter LIB "libnodave.dll" ALIAS "daveInitAdapter" (BYVAL di AS LONG) AS LONG
'
' Disconnect from a PLC. While some protocols do not need this, I recommend to allways use it.
' It will do nothing if the protocol doesn't need it. But you can change protocols without
' changing your program code.
'
DECLARE FUNCTION daveDisconnectPLC LIB "libnodave.dll" ALIAS "daveDisconnectPLC" (BYVAL DC AS LONG) AS LONG
'
'
' Disconnect from an MPI Adapter or NetLink Ethernet MPI gateway.
' While some protocols do not need this, I recommend to allways use it.
' It will do nothing if the protocol doesn't need it. But you can change protocols without
' changing your program code.
'
DECLARE FUNCTION daveDisconnectAdapter LIB "libnodave.dll" ALIAS "daveDisconnectAdapter" (BYVAL DC AS LONG) AS LONG
'
'
' List nodes on an MPI or Profibus Network:
'
DECLARE FUNCTION daveListReachablePartners LIB "libnodave.dll" ALIAS "daveListReachablePartners" (BYVAL DC AS LONG, BYREF buffer AS BYTE) AS LONG
'
'
' Set/change the timeout for an interface:
'
DECLARE SUB daveSetTimeout LIB "libnodave.dll" ALIAS "daveSetTimeout" (BYVAL di AS LONG, BYVAL maxTime AS LONG)
'
' Read the timeout setting for an interface:
'
DECLARE FUNCTION daveGetTimeout LIB "libnodave.dll" ALIAS "daveGetTimeout" (BYVAL di AS LONG) AS LONG
'
' Get the name of an interface. Do NOT use this, but the wrapper function defined below!
'
DECLARE FUNCTION daveInternalGetName LIB "libnodave.dll" ALIAS "daveGetName" (BYVAL en AS LONG) AS LONG
'
' Get the MPI address of a connection.
'
DECLARE FUNCTION daveGetMPIAdr LIB "libnodave.dll" ALIAS "daveGetMPIAdr" (BYVAL DC AS LONG) AS LONG
'
' Get the length (in bytes) of the last data received on a connection.
'
DECLARE FUNCTION daveGetAnswLen LIB "libnodave.dll" ALIAS "daveGetAnswLen" (BYVAL DC AS LONG) AS LONG
'
' Get the maximum length of a communication packet (PDU).
' This value depends on your CPU and connection type. It is negociated in daveConnectPLC.
' A simple read can read MaxPDULen-18 bytes.
'
DECLARE FUNCTION daveGetMaxPDULen LIB "libnodave.dll" ALIAS "daveGetMaxPDULen" (BYVAL DC AS LONG) AS LONG
'
' Reserve memory for a resultSet and get a handle to it:
'
DECLARE FUNCTION daveNewResultSet LIB "libnodave.dll" ALIAS "daveNewResultSet"() AS LONG
'
' Destroy handles to daveInterface, daveConnections, PDUs and resultSets
' Free the memory reserved for them.
'
DECLARE SUB daveFree LIB "libnodave.dll" ALIAS "daveFree" (BYVAL item AS LONG)
'
' Reserve memory for a PDU and get a handle to it:
'
DECLARE FUNCTION daveNewPDU LIB "libnodave.dll" ALIAS "daveNewPDU" () AS LONG
'
' Get the error code of the n-th single result in a result set:
'
DECLARE FUNCTION daveGetErrorOfResult LIB "libnodave.dll" ALIAS "daveGetErrorOfResult" (BYVAL resultSet AS LONG, BYVAL resultNumber AS LONG) AS LONG
'
DECLARE FUNCTION daveForceDisconnectIBH LIB "libnodave.dll" ALIAS "daveForceDisconnectIBH" (BYVAL di AS LONG, BYVAL src AS LONG, BYVAL dest AS LONG, BYVAL mpi AS LONG) AS LONG
'
' Helper functions to open serial ports and IP connections. You can use others if you want and
' pass their results to daveNewInterface.
'
' Open a serial port using name, baud rate and parity. Everything else is set automatically:
'
DECLARE FUNCTION openPort LIB "libnodave.dll" ALIAS "setPort" (BYVAL sportname AS STRING, BYVAL sbaudrate AS STRING, BYVAL bparity AS BYTE) AS LONG
'
' Open a TCP/IP connection using port number (1099 for NetLink, 102 for ISO over TCP) and
' IP address. You must use an IP address, NOT a hostname!
'
DECLARE FUNCTION openSocket LIB "libnodave.dll" ALIAS "openSocket" (BYVAL lport AS LONG, BYVAL peer AS STRING) AS LONG
'
' Open an access oint. This is a name in you can add in the "set Programmer/PLC interface" dialog.
' To the access point, you can assign an interface like MPI adapter, CP511 etc.
'
DECLARE FUNCTION openS7online LIB "libnodave.dll" ALIAS "openS7online" (BYVAL peer AS STRING) AS LONG
'
' Close connections and serial ports opened with above functions:
'
DECLARE FUNCTION closePort LIB "libnodave.dll" ALIAS "closePort" (BYVAL fh AS LONG) AS LONG
'
' Close handle opende by opens7online:
'
DECLARE FUNCTION closeS7online LIB "libnodave.dll" ALIAS "closeS7online" (BYVAL fh AS LONG) AS LONG
'
' Read Clock time from PLC:
'
DECLARE FUNCTION daveReadPLCTime LIB "libnodave.dll" ALIAS "daveReadPLCTime" (BYVAL DC AS LONG) AS LONG
'
' set clock to a value given by user
'
DECLARE FUNCTION daveSetPLCTime LIB "libnodave.dll" ALIAS "daveSetPLCTime" (BYVAL DC AS LONG, BYREF timestamp AS BYTE) AS LONG
'
' set clock to PC system clock:
'
DECLARE FUNCTION daveSetPLCTimeToSystime LIB "libnodave.dll" ALIAS "daveSetPLCTimeToSystime" (BYVAL DC AS LONG) AS LONG
'
'       BCD conversions:
'
DECLARE FUNCTION daveToBCD LIB "libnodave.dll" ALIAS "daveToBCD" (BYVAL DC AS LONG) AS LONG
DECLARE FUNCTION daveFromBCD LIB "libnodave.dll" ALIAS "daveFromBCD" (BYVAL DC AS LONG) AS LONG
'
' Here comes the wrapper code for functions returning strings:
'
FUNCTION daveStrError(BYVAL code AS LONG) AS STRING
DIM x   AS LOCAL STRING
DIM ip  AS LOCAL LONG

    x$ = STRING$(256, 0)                    ' create a string of sufficient capacity
    ip = daveInternalStrerror(code)         ' have the text for code copied in
    CALL daveStringCopy(ip, x$)             ' have the text for code copied in
    x$ = LEFT$(x$, INSTR(x$, CHR$(0)) - 1)  ' adjust the length
    daveStrError = x$                       ' and return result
END FUNCTION

FUNCTION daveAreaName(BYVAL code AS LONG) AS STRING
DIM x   AS LOCAL STRING
DIM ip  AS LOCAL LONG

    x$ = STRING$(256, 0)                    ' create a string of sufficient capacity
    ip = daveInternalAreaName(code)         ' have the text for code copied in
    CALL daveStringCopy(ip, x$)             ' have the text for code copied in
    x$ = LEFT$(x$, INSTR(x$, CHR$(0)) - 1)  ' adjust the length
    daveAreaName = x$                       ' and return result
END FUNCTION

FUNCTION daveBlockName(BYVAL code AS LONG) AS STRING
DIM x   AS LOCAL STRING
DIM ip  AS LOCAL LONG

    x$ = STRING$(256, 0)                    ' create a string of sufficient capacity
    ip = daveInternalBlockName(code)        ' have the text for code copied in
    CALL daveStringCopy(ip, x$)             ' have the text for code copied in
    x$ = LEFT$(x$, INSTR(x$, CHR$(0)) - 1)  ' adjust the length
    daveBlockName = x$                      ' and return result
END FUNCTION

FUNCTION daveGetName(BYVAL di AS LONG) AS STRING
DIM x   AS LOCAL STRING
DIM ip  AS LOCAL LONG

    x$ = STRING$(256, 0)                    ' create a string of sufficient capacity
    ip = daveInternalGetName(di)            ' have the text for code copied in
    CALL daveStringCopy(ip, x$)             ' have the text for code copied in
    x$ = LEFT$(x$, INSTR(x$, CHR$(0)) - 1)  ' adjust the length
    daveGetName = x$                        ' and return result
END FUNCTION

FUNCTION daveGetBlockInfo(BYVAL di AS LONG) AS BYTE
DIM x   AS LOCAL STRING
DIM ip  AS LOCAL LONG

    x$ = STRING$(256, 0)                    ' create a string of sufficient capacity
    ip = daveInternalGetName(di)            ' have the text for code copied in
    CALL daveStringCopy(ip, x$)             ' have the text for code copied in
    x$ = LEFT$(x$, INSTR(x$, CHR$(0)) - 1)  ' adjust the length
'    daveGetName = x$                        ' and return result
'********** ???????????????? *********
END FUNCTION

'*****************************************************
' End of interface declarations and helper functions.
'*****************************************************


'--------------------------------------------------------------------------------
' Constants
'--------------------------------------------------------------------------------
$ProgVers       = "Ver 1.0 28/07/06"    ' Program version
%MOD_ALT        = &H00000001            ' keyboard hooks
%MOD_CONTROL    = &H00000002
%MOD_SHIFT      = &H00000004
%DLE            = &H10
%ETX            = &H03
%STX            = &H02
%SYN            = &H16
'--------------------------------------------------------------------------------

'--------------------------------------------------------------------------------
' LibNoDave Constants
'--------------------------------------------------------------------------------
' Protocol types to be used with newInterface
%daveProtoMPI              =   0   ' MPI FOR S7 300/400
%daveProtoMPI2             =   1   ' MPI FOR S7 300/400, "Andrew's version"
%daveProtoPPI              =  10   ' PPI FOR S7 200
%daveProtoISOTCP           = 122   ' ISO over TCP
%daveProtoISOTCP243        = 123   ' ISO over TCP WITH CP243
%daveProtoMPI_IBH          = 223   ' MPI WITH IBH NetLink MPI TO ethernet gateway
%daveProtoPPI_IBH          = 224   ' PPI WITH IBH NetLink PPI TO ethernet gateway
%daveProtoNLpro            = 230   ' MPI WITH NetLink Pro MPI TO ethernet gateway
%daveProtoUserTransport    = 255   ' USER defined transport protocol
' ProfiBus speed constants
%daveSpeed9k               = 0
%daveSpeed19k              = 1
%daveSpeed187k             = 2
%daveSpeed500k             = 3
%daveSpeed1500k            = 4
%daveSpeed45k              = 5
%daveSpeed93k              = 6
' Some MPI function codes (yet unused ones may be incorrect)
%daveFuncOpenS7Connection  = &HF0
%daveFuncRead              = &H04
%daveFuncWrite             = &H05
%daveFuncRequestDownload   = &H1A
%daveFuncDownloadBlock     = &H1B
%daveFuncDownloadEnded     = &H1C
%daveFuncStartUpload       = &H1D
%daveFuncUpload            = &H1E
%daveFuncEndUpload         = &H1F
#IF 0
' S7 specific constants
$daveBlockType_OB          = "8"
$daveBlockType_DB          = "A"
$daveBlockType_SDB         = "B"
$daveBlockType_FC          = "C"
$daveBlockType_SFC         = "D"
$daveBlockType_FB          = "E"
$daveBlockType_SFB         = "F"
' Use these constants for parameter "area" in daveReadBytes and daveWriteBytes
$daveSysInfo               = "3"    ' System info OF 200 family
$daveSysFlags              = "5"    ' System flags OF 200 family
$daveAnaIn                 = "6"    ' analog inputs OF 200 family
$daveAnaOut                = "7"    ' analog outputs OF 200 family
$daveP                     = "80"
$daveInputs                = "81"   ' Peripheral DATA like PIW, PQW
$daveOutputs               = "82"
$daveFlags                 = "83"
$daveDB                    = "84"   ' DATA blocks
$daveDI                    = "85"   ' NOT tested
$daveLocal                 = "86"   ' NOT tested
$daveV                     = "87"   ' don't know what it is
$daveCounter               = "28"   ' don't know what it is
$daveTimer                 = "29"   ' don't know what it is
#ENDIF
%daveSysInfo               = &H3    '  System info of 200 family
%daveSysFlags              = &H5    '  System flags of 200 family
%daveAnaIn                 = &H6    '  analog inputs of 200 family
%daveAnaOut                = &H7    '  analog outputs of 200 family
%daveP                     = &H80   ' direct access to peripheral adresses
%daveInputs                = &H81
%daveOutputs               = &H82
%daveFlags                 = &H83
%daveDB                    = &H84   '  data blocks
%daveDI                    = &H85   '  instance data blocks
%daveV                     = &H87   ' don't know what it is
%daveCounter               = 28     ' S7 counters
%daveTimer                 = 29     ' S7 timers
%daveCounter200            = 30     ' IEC counters (200 family)
%daveTimer200              = 31     ' IEC timers (200 family)
'
%daveOrderCodeSize         = 21     ' Length of order code (MLFB number)

' Library specific Result codes
'  Generally, 0 means ok,
'  >0 are results (also errors) reported by the PLC
'  <0 means error reported by library code.
%daveResOK                          = 0    ' means ALL ok
' CPU tells it does not support to read a bit block with a length other than 1 bit
%daveResMultipleBitsNotSupported    = 6
' means a a piece of data is not available in the CPU, e.g.
'  when trying TO READ a non existing DB OR BIT block OF length<>1
%daveResItemNotAvailable200         = 3
' This code seems to be specific to 200 family
'  means a a piece of data is not available in the CPU, e.g.
'  when trying TO READ a non existing DB
%daveResItemNotAvailable            = 10
' means the data address is beyond the CPUs address range
%daveAddressOutOfRange              = 5
%daveResCannotEvaluatePDU           = -123
%daveResCPUNoData                   = -124
%daveUnknownError                   = -125
%daveEmptyResultError               = -126
%daveEmptyResultSetError            = -127

' Max number of bytes in a single message.
' An upper limit for MPI over serial is:
' 8       transport header
' +2 240  max PDU len  2 if every character were a DLE
' +3      DLE,ETX and BCC
' = 491

' Later I saw some programs offering up to 960 bytes in PDU size negotiation

' Max number of bytes in a single message.
' An upper limit for MPI over serial is:
' 8       transport header
' +2 960  max PDU len  2 if every character were a DLE
' +3      DLE,ETX and BCC
' = 1931

' For now, we take the rounded max of all this to determine our buffer size. This is ok
' for PC systems, where one k less or more doesn't matter.
%daveMaxRawLen                  = 2048

' Some definitions for debugging
$daveDebugRawRead               = "01"  ' SHOW the SINGLE bytes received
$daveDebugSpecialChars          = "02"  ' SHOW when special chars are READ
$daveDebugRawWrite              = "04"  ' SHOW the SINGLE bytes written
$daveDebugListReachables        = "08"  ' SHOW the steps when determine devices IN MPI net
$daveDebugInitAdapter           = "10"  ' SHOW the steps when Initilizing the MPI adapter
$daveDebugConnect               = "20"  ' SHOW the steps when connecting a PLC
$daveDebugPacket                = "40"
$daveDebugByte                  = "80"
$daveDebugCompare               = "100"
$daveDebugExchange              = "200"
$daveDebugPDU                   = "400"  ' debug PDU handling
$daveDebugUpload                = "800"  ' debug PDU loading program blocks FROM PLC
$daveDebugMPI                   = "1000"
$daveDebugPrintErrors           = "2000" ' PRINT ERROR messages
$daveDebugPassive               = "4000"
$daveDebugErrorReporting        = "8000"
$daveDebugOpen                  = "10000"
$daveDebugAll                   = "1FFFF"
$LibName                        = "libnodave.dll"   ' WIN32


'--------------------------------------------------------------------------------
' Data structures
'--------------------------------------------------------------------------------
' WIN32
TYPE typDaveOSserial BYTE
     rfd                AS DWORD
     wfd                AS DWORD
END TYPE

' Helper struct to manage PDUs. This is NOT the part of the packet I would call PDU, but
' a set of pointers that ease access to the "parts" of a PDU.
'    pointer to start of PDU (PDU header)
'    pointer to start of parameters inside PDU
'    pointer to start of data inside PDU
'    pointer to start of data inside PDU
'    header length
'    parameter length
'    data length
'    user or result data length
TYPE typPDU BYTE
     pheader            AS BYTE POINTER
     pparam             AS BYTE POINTER
     pDATA              AS BYTE POINTER
     udata              AS BYTE POINTER
     hlen               AS LONG
     plen               AS LONG
     dlen               AS LONG
     udlen              AS LONG
END TYPE

' Definitions of prototypes for the protocol specific functions. The library "switches"
' protocol by setting pointers to the protol specific implementations.
' This groups an interface together with some information about it's properties
' in the library's context.
'    some handle for the serial interface
'    a counter used when multiple PLCs are accessed via
'    the same serial interface and adapter.
'    the adapter's MPI address
'    just a name that can be used in programs dealing with multiple
'    daveInterfaces
'    Timeout in microseconds used in transort.
'    The kind of transport protocol used on this interface.
'    The MPI or Profibus speed
'    position of some packet number that has to be repeated in ackknowledges
'    pointers to the protocol
'    specific implementations
'    of these functions
TYPE typMPIheader BYTE
     src_conn               AS BYTE
     dst_conn               AS BYTE
     MPI                    AS BYTE
     localMPI               AS BYTE
     leng                   AS BYTE
     func                   AS BYTE
     packetNumber           AS BYTE
END TYPE

TYPE typDaveInterface BYTE
     ttimeout               AS LONG
     fd                     AS typDaveOSserial
     localMPI               AS LONG
     users                  AS LONG
     pname                  AS BYTE POINTER
     protocol               AS LONG
     speed                  AS LONG
     ackPos                 AS LONG
     nextConnection         AS DWORD
     initAdapter            AS DWORD
     connectPLC             AS DWORD
     disconnectPLC          AS DWORD
     disconnectAdapter      AS DWORD
     exchange               AS DWORD
     sendMessage            AS DWORD
     getResponse            AS DWORD
     listReachablePartners  AS DWORD
END TYPE

' This holds data for a PLC connection
'    pointer to used interface
'    The PLC's address
'    current message number
'    message number we need ackknowledge for
'    length of last message
'    template of MPI Header, setup once, copied in and then modified
'    used to retrieve single values from the result byte array
'    packetNumber in transport layer
'    position of PDU in outgoing messages. This is different for different transport methodes.
'    position of PDU in incoming messages. This is different for different transport methodes.
'    rack number for ISO over TCP
'    slot number for ISO over TCP
TYPE typDaveConnection BYTE
     AnswLen            AS LONG
     resultPointer      AS BYTE POINTER
     maxPDUlength       AS LONG
     MPIAdr             AS LONG
     pIface             AS LONG
     needAckNumber      AS LONG
     PDUnumber          AS LONG
     ibhSrcConn         AS LONG
     ibhDstConn         AS LONG
     msgIn              (0 TO (%daveMaxRawLen)-1) AS BYTE
     msgOut             (0 TO (%daveMaxRawLen)-1) AS BYTE
     r_resultPointer    AS BYTE POINTER
     PDUstartO          AS LONG
     PDUstartI          AS LONG
     rack               AS LONG
     slot               AS LONG
     connectionNumber   AS LONG
     connectionNumber2  AS LONG
     messageNumber      AS BYTE
     packetNumber       AS BYTE
END TYPE
'--------------------------------------------------------------------------------


#ENDIF ' #IF NOT %DEF(%DAVE_INC)
