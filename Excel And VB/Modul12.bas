Attribute VB_Name = "Modul12"
'
' Part of Libnodave, a free communication libray for Siemens S7 200/300/400 via
' the MPI adapter 6ES7 972-0CA22-0XAC
' or  MPI adapter 6ES7 972-0CA23-0XAC
' or  TS adapter 6ES7 972-0CA33-0XAC
' or  MPI adapter 6ES7 972-0CA11-0XAC,
' IBH/MHJ-NetLink or CPs 243, 343 and 443
' or VIPA Speed7 with builtin ethernet support.
'
' (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2005
'
' Libnodave is free software; you can redistribute it and/or modify
' it under the terms of the GNU Library General Public License as published by
' the Free Software Foundation; either version 2, or (at your option)
' any later version.
'
' Libnodave is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU Library General Public License
' along with Libnodave; see the file COPYING.  If not, write to
' the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
'
'

''
'    Protocol types to be used with newInterface:
'
Private Const daveProtoMPI = 0      '  MPI for S7 300/400
Private Const daveProtoMPI2 = 1    '  MPI for S7 300/400, "Andrew's version"
Private Const daveProtoMPI3 = 2    '  MPI for S7 300/400, Step 7 Version, not yet implemented
Private Const daveProtoPPI = 10    '  PPI for S7 200
Private Const daveProtoAS511 = 20    '  S5 via programming interface
Private Const daveProtoS7online = 50    '  S7 using Siemens libraries & drivers for transport
Private Const daveProtoISOTCP = 122 '  ISO over TCP
Private Const daveProtoISOTCP243 = 123 '  ISO o?ver TCP with CP243
Private Const daveProtoMPI_IBH = 223   '  MPI with IBH NetLink MPI to ethernet gateway */
Private Const daveProtoPPI_IBH = 224   '  PPI with IBH NetLink PPI to ethernet gateway */
Private Const daveProtoUserTransport = 255 '  Libnodave will pass the PDUs of S7 Communication to user defined call back functions.
'
'    ProfiBus speed constants:
'
Private Const daveSpeed9k = 0
Private Const daveSpeed19k = 1
Private Const daveSpeed187k = 2
Private Const daveSpeed500k = 3
Private Const daveSpeed1500k = 4
Private Const daveSpeed45k = 5
Private Const daveSpeed93k = 6
'
'    S7 specific constants:
'
Private Const daveBlockType_OB = "8"
Private Const daveBlockType_DB = "A"
Private Const daveBlockType_SDB = "B"
Private Const daveBlockType_FC = "C"
Private Const daveBlockType_SFC = "D"
Private Const daveBlockType_FB = "E"
Private Const daveBlockType_SFB = "F"
'
' Use these constants for parameter "area" in daveReadBytes and daveWriteBytes
'
Private Const daveSysInfo = &H3      '  System info of 200 family
Private Const daveSysFlags = &H5   '  System flags of 200 family
Private Const daveAnaIn = &H6      '  analog inputs of 200 family
Private Const daveAnaOut = &H7     '  analog outputs of 200 family
Private Const daveP = &H80          ' direct access to peripheral adresses
Private Const daveInputs = &H81
Private Const daveOutputs = &H82
Private Const daveFlags = &H83
Private Const daveDB = &H84 '  data blocks
Private Const daveDI = &H85  '  instance data blocks
Private Const daveV = &H87      ' don't know what it is
Private Const daveCounter = 28  ' S7 counters
Private Const daveTimer = 29    ' S7 timers
Private Const daveCounter200 = 30       ' IEC counters (200 family)
Private Const daveTimer200 = 31         ' IEC timers (200 family)
'
Private Const daveOrderCodeSize = 21    ' Length of order code (MLFB number)
'
'    Library specific:
'
'
'    Result codes. Genarally, 0 means ok,
'    >0 are results (also errors) reported by the PLC
'    <0 means error reported by library code.
'
Private Const daveResOK = 0                        ' means all ok
Private Const daveResNoPeripheralAtAddress = 1     ' CPU tells there is no peripheral at address
Private Const daveResMultipleBitsNotSupported = 6  ' CPU tells it does not support to read a bit block with a
                                                   ' length other than 1 bit.
Private Const daveResItemNotAvailable200 = 3       ' means a a piece of data is not available in the CPU, e.g.
                                                   ' when trying to read a non existing DB or bit bloc of length<>1
                                                   ' This code seems to be specific to 200 family.
Private Const daveResItemNotAvailable = 10         ' means a a piece of data is not available in the CPU, e.g.
                                                   ' when trying to read a non existing DB
Private Const daveAddressOutOfRange = 5            ' means the data address is beyond the CPUs address range
Private Const daveWriteDataSizeMismatch = 7        ' means the write data size doesn't fit item size
Private Const daveResCannotEvaluatePDU = -123
Private Const daveResCPUNoData = -124
Private Const daveUnknownError = -125
Private Const daveEmptyResultError = -126
Private Const daveEmptyResultSetError = -127
Private Const daveResUnexpectedFunc = -128
Private Const daveResUnknownDataUnitSize = -129
Private Const daveResShortPacket = -1024
Private Const daveResTimeout = -1025
'
'    Max number of bytes in a single message.
'
Private Const daveMaxRawLen = 2048
'
'    Some definitions for debugging:
'
Private Const daveDebugRawRead = &H1            ' Show the single bytes received
Private Const daveDebugSpecialChars = &H2       ' Show when special chars are read
Private Const daveDebugRawWrite = &H4           ' Show the single bytes written
Private Const daveDebugListReachables = &H8     ' Show the steps when determine devices in MPI net
Private Const daveDebugInitAdapter = &H10       ' Show the steps when Initilizing the MPI adapter
Private Const daveDebugConnect = &H20           ' Show the steps when connecting a PLC
Private Const daveDebugPacket = &H40
Private Const daveDebugByte = &H80
Private Const daveDebugCompare = &H100
Private Const daveDebugExchange = &H200
Private Const daveDebugPDU = &H400      ' debug PDU handling
Private Const daveDebugUpload = &H800   ' debug PDU loading program blocks from PLC
Private Const daveDebugMPI = &H1000
Private Const daveDebugPrintErrors = &H2000     ' Print error messages
Private Const daveDebugPassive = &H4000
Private Const daveDebugErrorReporting = &H8000
Private Const daveDebugOpen = &H8000
Private Const daveDebugAll = &H1FFFF
'
'    Set and read debug level:
'
Private Declare Sub daveSetDebug Lib "libnodave.dll" (ByVal level As Long)
Private Declare Function daveGetDebug Lib "libnodave.dll" () As Long
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
' Private Declare Function daveStrerror Lib "libnodave.dll" Alias "daveStrerror" (ByVal en As Long) As String
'
Private Declare Function daveInternalStrerror Lib "libnodave.dll" Alias "daveStrerror" (ByVal en As Long) As Long
' So, I added another function to libnodave wich copies the text into a VB String.
' This function is still not useful without some code araound it, so I call it "internal"
Private Declare Sub daveStringCopy Lib "libnodave.dll" (ByVal internalPointer As Long, ByVal s As String)
'
' Setup a new interface structure using a handle to an open port or socket:
'
Private Declare Function daveNewInterface Lib "libnodave.dll" (ByVal fd1 As Long, ByVal fd2 As Long, ByVal name As String, ByVal localMPI As Long, ByVal protocol As Long, ByVal speed As Long) As Long
'
' Setup a new connection structure using an initialized daveInterface and PLC's MPI address.
' Note: The parameter di must have been obtained from daveNewinterface.
'
Private Declare Function daveNewConnection Lib "libnodave.dll" (ByVal di As Long, ByVal mpi As Long, ByVal Rack As Long, ByVal Slot As Long) As Long
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
Private Declare Function daveGetResponse Lib "libnodave.dll" (ByVal dc As Long) As Long
'
'    send PDU to PLC
'    Note: The parameter dc must have been obtained from daveNewConnection,
'          The parameter pdu must have been obtained from daveNewPDU.
'
Private Declare Function daveSendMessage Lib "libnodave.dll" (ByVal dc As Long, ByVal pdu As Long) As Long
'******
'
'Utilities:
'
'****
'*
'    Hex dump PDU:
'
Private Declare Sub daveDumpPDU Lib "libnodave.dll" (ByVal pdu As Long)
'
'    Hex dump. Write the name followed by len bytes written in hex and a newline:
'
Private Declare Sub daveDump Lib "libnodave.dll" (ByVal name As String, ByVal pdu As Long, ByVal length As Long)
'
'    names for PLC objects. This is again the intenal function. Use the wrapper code below.
'
Private Declare Function daveInternalAreaName Lib "libnodave.dll" Alias "daveAreaName" (ByVal en As Long) As Long
Private Declare Function daveInternalBlockName Lib "libnodave.dll" Alias "daveBlockName" (ByVal en As Long) As Long
'
'   swap functions. They change the byte order, if byte order on the computer differs from
'   PLC byte order:
'
Private Declare Function daveSwapIed_16 Lib "libnodave.dll" (ByVal x As Long) As Long
Private Declare Function daveSwapIed_32 Lib "libnodave.dll" (ByVal x As Long) As Long
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
Private Declare Function toPLCfloat Lib "libnodave.dll" (ByVal f As Single) As Single
Private Declare Function daveToPLCfloat Lib "libnodave.dll" (ByVal f As Single) As Long
'
' Copy and convert value of 8,16,or 32 bit, signed or unsigned at position pos
' from internal buffer:
'
Private Declare Function daveGetS8from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
Private Declare Function daveGetU8from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
Private Declare Function daveGetS16from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
Private Declare Function daveGetU16from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
Private Declare Function daveGetS32from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
'
' Is there an unsigned long? Or a longer integer than long? This doesn't work.
' Private Declare Function daveGetU32from Lib "libnodave.dll" (ByRef buffer As Byte) As Long
'
Private Declare Function daveGetFloatfrom Lib "libnodave.dll" (ByRef buffer As Byte) As Single
'
' Copy and convert a value of 8,16,or 32 bit, signed or unsigned from internal buffer. These
' functions increment an internal buffer position. This buffer position is set to zero by
' daveReadBytes, daveReadBits, daveReadSZL.
'
Private Declare Function daveGetS8 Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveGetU8 Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveGetS16 Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveGetU16 Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveGetS32 Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' Is there an unsigned long? Or a longer integer than long? This doesn't work.
'Private Declare Function daveGetU32 Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveGetFloat Lib "libnodave.dll" (ByVal dc As Long) As Single
'
' Read a value of 8,16,or 32 bit, signed or unsigned at position pos from internal buffer:
'
Private Declare Function daveGetS8At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
Private Declare Function daveGetU8At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
Private Declare Function daveGetS16At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
Private Declare Function daveGetU16At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
Private Declare Function daveGetS32At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
'
' Is there an unsigned long? Or a longer integer than long? This doesn't work.
'Private Declare Function daveGetU32At Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
Private Declare Function daveGetFloatAt Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Single
'
' Copy and convert a value of 8,16,or 32 bit, signed or unsigned into a buffer. The buffer
' is usually used by daveWriteBytes, daveWriteBits later.
'
Private Declare Function davePut8 Lib "libnodave.dll" (ByRef buffer As Byte, ByVal value As Long) As Long
Private Declare Function davePut16 Lib "libnodave.dll" (ByRef buffer As Byte, ByVal value As Long) As Long
Private Declare Function davePut32 Lib "libnodave.dll" (ByRef buffer As Byte, ByVal value As Long) As Long
Private Declare Function davePutFloat Lib "libnodave.dll" (ByRef buffer As Byte, ByVal value As Single) As Long
'
' Copy and convert a value of 8,16,or 32 bit, signed or unsigned to position pos of a buffer.
' The buffer is usually used by daveWriteBytes, daveWriteBits later.
'
Private Declare Function davePut8At Lib "libnodave.dll" (ByRef buffer As Byte, ByVal pos As Long, ByVal value As Long) As Long
Private Declare Function davePut16At Lib "libnodave.dll" (ByRef buffer As Byte, ByVal pos As Long, ByVal value As Long) As Long
Private Declare Function davePut32At Lib "libnodave.dll" (ByRef buffer As Byte, ByVal pos As Long, ByVal value As Long) As Long
Private Declare Function davePutFloatAt Lib "libnodave.dll" (ByRef buffer As Byte, ByVal pos As Long, ByVal value As Single) As Long
'
' Takes a timer value and converts it into seconds:
'
Private Declare Function daveGetSeconds Lib "libnodave.dll" (ByVal dc As Long) As Single
Private Declare Function daveGetSecondsAt Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Single
'
' Takes a counter value and converts it to integer:
'
Private Declare Function daveGetCounterValue Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveGetCounterValueAt Lib "libnodave.dll" (ByVal dc As Long, ByVal pos As Long) As Long
'
' Get the order code (MLFB number) from a PLC. Does NOT work with 200 family.
'
Private Declare Function daveGetOrderCode Lib "libnodave.dll" (ByVal en As Long, ByRef buffer As Byte) As Long
'
' Connect to a PLC.
'
Private Declare Function daveConnectPLC Lib "libnodave.dll" (ByVal dc As Long) As Long
'
'
' Read a value or a block of values from PLC.
'
Private Declare Function daveReadBytes Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByVal buffer As Long) As Long
'
' Read a long block of values from PLC. Long means too long to transport in a single PDU.
'
Private Declare Function daveManyReadBytes Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByVal buffer As Long) As Long
'
' Write a value or a block of values to PLC.
'
Private Declare Function daveWriteBytes Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByRef buffer As Byte) As Long
'
' Write a long block of values to PLC. Long means too long to transport in a single PDU.
'
Private Declare Function daveWriteManyBytes Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByRef buffer As Byte) As Long
'
' Read a bit from PLC. numBytes must be exactly one with all PLCs tested.
' Start is calculated as 8*byte number+bit number.
'
Private Declare Function daveReadBits Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByVal buffer As Long) As Long
'
' Write a bit to PLC. numBytes must be exactly one with all PLCs tested.
'
Private Declare Function daveWriteBits Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByRef buffer As Byte) As Long
'
' Set a bit in PLC to 1.
'
Private Declare Function daveSetBit Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal byteAddress As Long, ByVal bitAddress As Long) As Long
'
' Set a bit in PLC to 0.
'
Private Declare Function daveClrBit Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal byteAddress As Long, ByVal bitAddress As Long) As Long
'
' Read a diagnostic list (SZL) from PLC. Does NOT work with 200 family.
'
Private Declare Function daveReadSZL Lib "libnodave.dll" (ByVal dc As Long, ByVal ID As Long, ByVal index As Long, ByRef buffer As Byte, ByVal buflen As Long) As Long
'
Private Declare Function daveListBlocksOfType Lib "libnodave.dll" (ByVal dc As Long, ByVal typ As Long, ByRef buffer As Byte) As Long
Private Declare Function daveListBlocks Lib "libnodave.dll" (ByVal dc As Long, ByRef buffer As Byte) As Long
Private Declare Function internalDaveGetBlockInfo Lib "libnodave.dll" Alias "daveGetBlockInfo" (ByVal dc As Long, ByRef buffer as byte, ByVal btype as Long, ByVal number as Long) As Long
'
Private Declare Function daveGetProgramBlock Lib "libnodave.dll" (ByVal dc As Long, ByVal blockType As Long, ByVal number As Long, ByRef buffer As Byte, ByRef length As Long) As Long
'
' Start or Stop a PLC:
'
Private Declare Function daveStart Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveStop Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' Set outputs (digital or analog ones) of an S7-200 that is in stop mode:
'
Private Declare Function daveForce200 Lib "libnodave.dll" (ByVal dc As Long, ByVal area As Long, ByVal start As Long, ByVal value As Long) As Long
'
' Initialize a multivariable read request.
' The parameter PDU must have been obtained from daveNew PDU:
'
Private Declare Sub davePrepareReadRequest Lib "libnodave.dll" (ByVal dc As Long, ByVal pdu As Long)
'
' Add a new variable to a prepared request:
'
Private Declare Sub daveAddVarToReadRequest Lib "libnodave.dll" (ByVal pdu As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long)
'
' Executes the entire request:
'
Private Declare Function daveExecReadRequest Lib "libnodave.dll" (ByVal dc As Long, ByVal pdu As Long, ByVal rs As Long) As Long
'
' Use the n-th result. This lets the functions daveGet<data type> work on that part of the
' internal buffer that contains the n-th result:
'
Private Declare Function daveUseResult Lib "libnodave.dll" (ByVal dc As Long, ByVal rs As Long, ByVal resultNumber As Long) As Long
'
' Frees the memory occupied by single results in the result structure. After that, you can reuse
' the resultSet in another call to daveExecReadRequest.
'
Private Declare Sub daveFreeResults Lib "libnodave.dll" (ByVal rs As Long)
'
' Adds a new bit variable to a prepared request. As with daveReadBits, numBytes must be one for
' all tested PLCs.
'
Private Declare Sub daveAddBitVarToReadRequest Lib "libnodave.dll" (ByVal pdu As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long)
'
' Initialize a multivariable write request.
' The parameter PDU must have been obtained from daveNew PDU:
'
Private Declare Sub davePrepareWriteRequest Lib "libnodave.dll" (ByVal dc As Long, ByVal pdu As Long)
'
' Add a new variable to a prepared write request:
'
Private Declare Sub daveAddVarToWriteRequest Lib "libnodave.dll" (ByVal pdu As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByRef buffer As Byte)
'
' Add a new bit variable to a prepared write request:
'
Private Declare Sub daveAddBitVarToWriteRequest Lib "libnodave.dll" (ByVal pdu As Long, ByVal area As Long, ByVal areaNumber As Long, ByVal start As Long, ByVal numBytes As Long, ByRef buffer As Byte)
'
' Execute the entire write request:
'
Private Declare Function daveExecWriteRequest Lib "libnodave.dll" (ByVal dc As Long, ByVal pdu As Long, ByVal rs As Long) As Long
'
' Initialize an MPI Adapter or NetLink Ethernet MPI gateway.
' While some protocols do not need this, I recommend to allways use it. It will do nothing if
' the protocol doesn't need it. But you can change protocols without changing your program code.
'
Private Declare Function daveInitAdapter Lib "libnodave.dll" (ByVal di As Long) As Long
'
' Disconnect from a PLC. While some protocols do not need this, I recommend to allways use it.
' It will do nothing if the protocol doesn't need it. But you can change protocols without
' changing your program code.
'
Private Declare Function daveDisconnectPLC Lib "libnodave.dll" (ByVal dc As Long) As Long
'
'
' Disconnect from an MPI Adapter or NetLink Ethernet MPI gateway.
' While some protocols do not need this, I recommend to allways use it.
' It will do nothing if the protocol doesn't need it. But you can change protocols without
' changing your program code.
'
Private Declare Function daveDisconnectAdapter Lib "libnodave.dll" (ByVal dc As Long) As Long
'
'
' List nodes on an MPI or Profibus Network:
'
Private Declare Function daveListReachablePartners Lib "libnodave.dll" (ByVal dc As Long, ByRef buffer As Byte) As Long
'
'
' Set/change the timeout for an interface:
'
Private Declare Sub daveSetTimeout Lib "libnodave.dll" (ByVal di As Long, ByVal maxTime As Long)
'
' Read the timeout setting for an interface:
'
Private Declare Function daveGetTimeout Lib "libnodave.dll" (ByVal di As Long)
'
' Get the name of an interface. Do NOT use this, but the wrapper function defined below!
'
Private Declare Function daveInternalGetName Lib "libnodave.dll" Alias "daveGetName" (ByVal en As Long) As Long
'
' Get the MPI address of a connection.
'
Private Declare Function daveGetMPIAdr Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' Get the length (in bytes) of the last data received on a connection.
'
Private Declare Function daveGetAnswLen Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' Get the maximum length of a communication packet (PDU).
' This value depends on your CPU and connection type. It is negociated in daveConnectPLC.
' A simple read can read MaxPDULen-18 bytes.
'
Private Declare Function daveGetMaxPDULen Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' Reserve memory for a resultSet and get a handle to it:
'
Private Declare Function daveNewResultSet Lib "libnodave.dll" () As Long
'
' Destroy handles to daveInterface, daveConnections, PDUs and resultSets
' Free the memory reserved for them.
'
Private Declare Sub daveFree Lib "libnodave.dll" (ByVal item As Long)
'
' Reserve memory for a PDU and get a handle to it:
'
Private Declare Function daveNewPDU Lib "libnodave.dll" () As Long
'
' Get the error code of the n-th single result in a result set:
'
Private Declare Function daveGetErrorOfResult Lib "libnodave.dll" (ByVal resultSet As Long, ByVal resultNumber As Long) As Long
'
Private Declare Function daveForceDisconnectIBH Lib "libnodave.dll" (ByVal di As Long, ByVal src As Long, ByVal dest As Long, ByVal mpi As Long) As Long
'
' Helper functions to open serial ports and IP connections. You can use others if you want and
' pass their results to daveNewInterface.
'
' Open a serial port using name, baud rate and parity. Everything else is set automatically:
'
Private Declare Function setPort Lib "libnodave.dll" (ByVal portName As String, ByVal baudrate As String, ByVal parity As Byte) As Long
'
' Open a TCP/IP connection using port number (1099 for NetLink, 102 for ISO over TCP) and
' IP address. You must use an IP address, NOT a hostname!
'
Private Declare Function openSocket Lib "libnodave.dll" (ByVal port As Long, ByVal peer As String) As Long
'
' Open an access oint. This is a name in you can add in the "set Programmer/PLC interface" dialog.
' To the access point, you can assign an interface like MPI adapter, CP511 etc.
'
Private Declare Function openS7online Lib "libnodave.dll" (ByVal peer As String) As Long
'
' Close connections and serial ports opened with above functions:
'
Private Declare Function closePort Lib "libnodave.dll" (ByVal fh As Long) As Long
'
' Close sockets opened with above functions:
'
Private Declare Function closeSocket Lib "libnodave.dll" (ByVal fh As Long) As Long
'
' Close handle opened by opens7online:
'
Private Declare Function closeS7online Lib "libnodave.dll" (ByVal fh As Long) As Long
'
' Read Clock time from PLC:
'
Private Declare Function daveReadPLCTime Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' set clock to a value given by user
'
Private Declare Function daveSetPLCTime Lib "libnodave.dll" (ByVal dc As Long, ByRef timestamp As Byte) As Long
'
' set clock to PC system clock:
'
Private Declare Function daveSetPLCTimeToSystime Lib "libnodave.dll" (ByVal dc As Long) As Long
'
'       BCD conversions:
'
Private Declare Function daveToBCD Lib "libnodave.dll" (ByVal dc As Long) As Long
Private Declare Function daveFromBCD Lib "libnodave.dll" (ByVal dc As Long) As Long
'
' Here comes the wrapper code for functions returning strings:
'
Private Function daveStrError(ByVal code As Long) As String
    x$ = String$(256, 0)            'create a string of sufficient capacity
    ip = daveInternalStrerror(code)    ' have the text for code copied in
    Call daveStringCopy(ip, x$)    ' have the text for code copied in
    x$ = Left$(x$, InStr(x$, Chr$(0)) - 1) ' adjust the length
    daveStrError = x$                       ' and return result
End Function

Private Function daveAreaName(ByVal code As Long) As String
    x$ = String$(256, 0)            'create a string of sufficient capacity
    ip = daveInternalAreaName(code)    ' have the text for code copied in
    Call daveStringCopy(ip, x$)    ' have the text for code copied in
    x$ = Left$(x$, InStr(x$, Chr$(0)) - 1) ' adjust the length
    daveAreaName = x$                       ' and return result
End Function
Private Function daveBlockName(ByVal code As Long) As String
    x$ = String$(256, 0)            'create a string of sufficient capacity
    ip = daveInternalBlockName(code)    ' have the text for code copied in
    Call daveStringCopy(ip, x$)    ' have the text for code copied in
    x$ = Left$(x$, InStr(x$, Chr$(0)) - 1) ' adjust the length
    daveBlockName = x$                       ' and return result
End Function
Private Function daveGetName(ByVal di As Long) As String
    x$ = String$(256, 0)            'create a string of sufficient capacity
    ip = daveInternalGetName(di)    ' have the text for code copied in
    Call daveStringCopy(ip, x$)    ' have the text for code copied in
    x$ = Left$(x$, InStr(x$, Chr$(0)) - 1) ' adjust the length
    daveGetName = x$                       ' and return result
End Function
Private Function daveGetBlockInfo(ByVal di As Long) As Byte
    x$ = String$(256, 0)            'create a string of sufficient capacity
    ip = daveInternalGetName(di)    ' have the text for code copied in
    Call daveStringCopy(ip, x$)    ' have the text for code copied in
    x$ = Left$(x$, InStr(x$, Chr$(0)) - 1) ' adjust the length
    daveGetName = x$                       ' and return result
End Function
'
'*****************************************************
' End of interface declarations and helper functions.
'*****************************************************
'
' Here begins the demo program
Sub initTable()
Cells(2, 4) = "Serial port:"
Cells(2, 5) = "COM1"
Cells(3, 4) = "Baudrate:"
Cells(3, 5) = "38400"
Cells(4, 4) = "Parity:"
Cells(4, 5) = "O"
Cells(6, 4) = "MPI/PPI Address:"
Cells(6, 5) = 2
Cells(7, 4) = "IP Address:"
Cells(7, 5) = "192.168.1.1"
Cells(8, 4) = "Access point:"
Cells(8, 5) = "/S7ONLINE"
End Sub


'
' This initialization is used in all test programs. In a real program, where you would
' want to read again and again, keep the dc and di until your program terminates.
'
Private Function initialize(ByRef ph As Long, ByRef di As Long, ByRef dc As Long)
ph = 0
di = 0
dc = 0
rem uncomment the daveSetDebug... line, save your sheet
rem run excel from dos box with: excel yoursheet >debugout.txt
rem send me the file debugout.txt if you have trouble.
rem call daveSetDebug(daveDebugAll)
initialize = -1
baud$ = Cells(3, 5)
If (baud$ = "") Then Call initTable
Cells(12, 2) = "Running"
res = -1
port = Cells(2, 5)
baud$ = Cells(3, 5)
parity$ = Cells(4, 5)
peer$ = Cells(7, 5)
acspnt$ = Cells(8, 5)
ph = setPort(port, baud$, Asc(Left$(parity$, 1)))
' Alternatives:
Rem ph = openSocket(102, peer$)    ' for ISO over TCP
Rem ph = openSocket(1099, peer$)' for IBH NetLink
Rem ph = openS7online(acspnt$) ' to use Siemes libraries for transport (s7online)
Cells(2, 1) = "port handle:"
Cells(2, 2) = ph
If (ph > 0) Then
    di = daveNewInterface(ph, ph, "IF1", 0, daveProtoMPI, daveSpeed187k)
' Alternatives:
'di = daveNewInterface(ph, ph, "IF1", 0, daveProtoPPI, daveSpeed187k)
'di = daveNewInterface(ph, ph, "IF1", 0, daveProtoMPI_IBH, daveSpeed187k)
'di = daveNewInterface(ph, ph, "IF1", 0, daveProtoISOTCP, daveSpeed187k)
'di = daveNewInterface(ph, ph, "IF1", 0, daveProtoS7online, daveSpeed187k)
'
'You can set longer timeout here, if you have  a slow connection
'    Call daveSetTimeout(di, 500000)
    res = daveInitAdapter(di)
    Cells(3, 1) = "result from initAdapter:"
    Cells(3, 2) = res
    If res = 0 Then
        MpiPpi = Cells(6, 5)
'
' with ISO over TCP, set correct values for rack and slot of the CPU
'
        dc = daveNewConnection(di, MpiPpi, Rack, Slot)
        res = daveConnectPLC(dc)
        Cells(4, 1) = "result from connectPLC:"
        Cells(4, 2) = res
        If res = 0 Then
            initialize = 0
        End If
    End If
End If
End Function
'
' Disconnect from PLC, disconnect from Adapter, close the serial interface or TCP/IP socket
'
Private Sub cleanUp(ByRef ph As Long, ByRef di As Long, ByRef dc As Long)
If dc <> 0 Then
    res = daveDisconnectPLC(dc)
    Call daveFree(dc)
    dc = 0
End If
If di <> 0 Then
    res = daveDisconnectAdapter(di)
    Call daveFree(di)
    di = 0
End If
If ph <> 0 Then
    res = closePort(ph)
'   res = closeSocket(ph)
    ph = 0
End If
Cells(12, 2) = "Finished"
End Sub
'
' read some values from FD0,FD4,FD8,FD12 (MD0,MD4,MD8,MD12 in german notation)
'  to read from data block 12, you would need to write:
'  daveReadBytes(dc, daveDB, 12, 0, 16, 0)
'
Sub readFromPLC()
Cells(1, 2) = "Testing PLC read"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
    res2 = daveReadBytes(dc, daveFlags, 0, 0, 16, 0)
    Cells(5, 1) = "result from readBytes:"
    Cells(5, 2) = res2
    If res2 = 0 Then
        v1 = daveGetS32(dc)
        Cells(7, 1) = "MD0(DINT):"
        Cells(7, 2) = v1
        v2 = daveGetS32(dc)
        Cells(8, 1) = "MD4(DINT):"
        Cells(8, 2) = v2
        v3 = daveGetS32(dc)
        Cells(9, 1) = "MD8(DINT):"
        Cells(9, 2) = v3
        v4 = daveGetFloat(dc)
        Cells(10, 1) = "MD12(REAL):"
        Cells(10, 2) = v4
        v5 = daveGetFloatAt(dc, 12)
    Else
        e$ = daveStrError(res)
        Cells(9, 4) = "error:"
        Cells(9, 5) = e$
    End If
End If
Call cleanUp(ph, di, dc)
End Sub

Sub startPLC()
Cells(1, 2) = "Testing Start PLC"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
    res2 = daveStart(dc)
    Cells(14, 2) = res2
Else
    e$ = daveStrError(res)
    Cells(9, 5) = e$
End If
Call cleanUp(ph, di, dc)
End Sub
Sub stopPLC()
Cells(1, 2) = "Testing Start PLC"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
    res2 = daveStop(dc)
    Cells(14, 1) = "result:"
    Cells(14, 2) = res2
Else
    e$ = daveStrError(res)
    Cells(9, 4) = "error:"
    Cells(9, 5) = e$
End If
Call cleanUp(ph, di, dc)
End Sub

Sub readOrderCode()
Cells(1, 2) = "Testing read Order code"
Dim ph As Long, di As Long, dc As Long
Dim buffer(50) As Byte
res = initialize(ph, di, dc)
If res = 0 Then
    res2 = daveGetOrderCode(dc, buffer(0))
    Cells(14, 2) = res2
    If res2 = 0 Then
        For i = 0 To daveOrderCodeSize - 2 'last character is chr$(0), don't copy it
            oc$ = oc$ + Chr$(buffer(i))
        Next i
        Cells(14, 3) = oc$
    Else
        e$ = daveStrError(res)
        Cells(9, 4) = "error:"
        Cells(9, 5) = e$
    End If
End If
Call cleanUp(ph, di, dc)
End Sub

Sub readDiagnostic()
' The internal buffer is not big enough for all SZL lists.
' You must provide a buffer of sufficient size.
Dim buffer(4096) As Byte
Cells(1, 2) = "Testing read CPU Diagnostic List SZL (A0,0)"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
    ID = &HA0
    res2 = daveReadSZL(dc, ID, 0, buffer(0), 4096)
    If res2 = 0 Then
        al = daveGetAnswLen(dc)
        If (al >= 4) Then
            ID = daveGetU16from(buffer(0))
            index = daveGetU16from(buffer(2))
            If (al >= 8) Then
                Cells(1, 15) = "Diagnostic List from CPU"
                ItemLen = daveGetU16from(buffer(4))
                ItemCount = daveGetU16from(buffer(6))
                bpos = 8    ' remember buffer position
                For i = 0 To ItemCount - 1
                    dia$ = ""
                    For j = 0 To ItemLen - 1
                        dia$ = dia$ + Hex$(buffer(bpos)) + ","
                        bpos = bpos + 1
                    Next j
                    Cells(i + 3, 15) = dia$
                Next i
            End If
        End If
    Else
        e$ = daveStrError(res2)
        Cells(9, 4) = "error:"
        Cells(9, 5) = e$
    End If
End If
Call cleanUp(ph, di, dc)
End Sub



Sub bufferTest()
Dim buffer(1024) As Byte
    buffer(0) = 255
    buffer(1) = 255
    buffer(2) = 255
    buffer(3) = 255
    t1 = daveGetS8from(buffer(0))
    t2 = daveGetU8from(buffer(1))
    t3 = daveGetS16from(buffer(0))
    t4 = daveGetU16from(buffer(1))
    t5 = daveGetS32from(buffer(0))
    't6 = daveGetU32from(buffer(0))
    
    v1 = Cells(7, 2)
    a = davePut32(buffer(0), Cells(7, 2))
    a = davePut32(buffer(4), Cells(8, 2))
    a = davePut32(buffer(8), Cells(9, 2))
    a = davePutFloat(buffer(12), Cells(10, 2))
    a0 = buffer(0)
    a1 = buffer(1)
    a2 = buffer(2)
    a3 = buffer(3)
    a4 = buffer(4)
    a5 = buffer(5)
    a6 = buffer(6)
    a7 = buffer(7)
    a8 = buffer(8)
    a9 = buffer(9)
    a10 = buffer(10)
    a11 = buffer(11)
    a12 = buffer(12)
    a13 = buffer(13)
    a14 = buffer(14)
    a15 = buffer(15)
End Sub
Sub writeToPLC()
Dim buffer(1024) As Byte
Cells(1, 2) = "Testing PLC write"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
'
' Here we put thre DINTs and a REAL into the buffer. davePutXXX does the necessary conversions.
' The resulting byte pattern in the buffer is the same you would get, when you watch the PLC
' memory (FB0 .. FB15) as bytes
'
    a = davePut32(buffer(0), Cells(7, 2))
    a = davePut32(buffer(4), Cells(8, 2))
    a = davePut32(buffer(8), Cells(9, 2))
    a = davePutFloat(buffer(12), Cells(10, 2))
    res2 = daveWriteBytes(dc, daveFlags, 0, 0, 16, buffer(0))
    e$ = daveStrError(res2)
    Cells(9, 4) = "error:"
    Cells(9, 5) = e$
End If
Call cleanUp(ph, di, dc)
End Sub
'
' This is a test for passing back strings from Libnodave to VB(A):
'
Sub stringtest()
For i = 0 To 255
    a$ = daveStrError(i)
    b$ = daveAreaName(i)
    C$ = daveBlockName(i)
    Cells(6 + i, 7) = i
    Cells(6 + i, 8) = a$
    Cells(6 + i, 9) = b$
    Cells(6 + i, 10) = C$
Next i
End Sub

Sub readMultipleItemsFromPLC()
Dim resultSet As Long
Dim pdu As Long
'
' Call daveSetDebug(&HFFFF)
' You may wonder what sense it might make to set debug level, as you cannot see
' messages when you opened excel from Widows GUI.
' You can invoke Excel from the console or from a batch file with:
' <myPathToExcel>\Excel.Exe <MyPathToXLS-File>VBATest.XLS >ExcelOut
' This will start Excel with VBATest.XLS and all debug messages (and a few from Excel itself)
' go into the file ExcelOut.
'
Cells(1, 2) = "Testing multiple item PLC read"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
    pdu = daveNewPDU
    Call davePrepareReadRequest(dc, pdu)
    Call daveAddVarToReadRequest(pdu, daveFlags, 0, 0, 4)
    Call daveAddVarToReadRequest(pdu, daveFlags, 0, 8, 8)
    resultSet = daveNewResultSet
    res2 = daveExecReadRequest(dc, pdu, resultSet)
    Cells(5, 2) = res2
    If res2 = 0 Then
        res3 = daveUseResult(dc, resultSet, 0)
        v1 = daveGetS32(dc)
        Cells(7, 2) = v1
        res3 = daveUseResult(dc, resultSet, 0)
        v2 = daveGetS32(dc)
        Cells(8, 2) = v2
        v4 = daveGetFloat(dc)
        Cells(10, 2) = v4
        daveFreeResults (resultSet)
    Else
        e$ = daveStrError(res2)
        Cells(9, 4) = "error:"
        Cells(9, 5) = e$
    End If
    daveFree (resultSet)
    daveFree (pdu)
End If
Call cleanUp(ph, di, dc)
End Sub

Sub writeMultipleItemsToPLC()
Dim resultSet As Long
Dim pdu As Long
Cells(1, 2) = "Testing multiple item PLC write"
Dim ph As Long, di As Long, dc As Long
res = initialize(ph, di, dc)
If res = 0 Then
    pdu = daveNewPDU
    res = daveGetMaxPDULen(dc)
    Call davePrepareWriteRequest(dc, pdu)
    Call daveAddVarToWriteRequest(pdu, daveFlags, 0, 0, 4, buffer)
    Call daveAddVarToWriteRequest(pdu, daveDB, 6, 8, 8, buffer)
    resultSet = daveNewResultSet
    res2 = daveExecWriteRequest(dc, pdu, resultSet)
    Cells(5, 1) = "result of exec request:"
    Cells(5, 2) = res2
    If res2 = 0 Then
        res3 = daveGetErrorOfResult(resultSet, 0)
        res3 = daveGetErrorOfResult(resultSet, 1)
        daveFreeResults (resultSet)
    Else
        e$ = daveStrError(res2)
        Cells(9, 4) = "error:"
        Cells(9, 5) = e$
    End If
    daveFree (resultSet)
    daveFree (pdu)
End If
Call cleanUp(ph, di, dc)
End Sub

Sub readProgramBlock()
Cells(1, 2) = "Testing read program block OB1"
Dim ph As Long, di As Long, dc As Long, buffer(3000) As Byte, length As Long
res = initialize(ph, di, dc)
If res = 0 Then
    res = daveGetProgramBlock(dc, Asc("8"), 1, buffer(0), length)
    bpos = 0
    Cells(16, 2) = "Contents of OB1:"
    For i = 0 To 1 + Int(length / 16)
        dia$ = ""
        For j = 0 To 15
            dia$ = dia$ + Hex$(buffer(bpos)) + ","
            bpos = bpos + 1
        Next j
        Cells(i + 17, 2) = dia$
    Next i
End If
Call cleanUp(ph, di, dc)
End Sub

