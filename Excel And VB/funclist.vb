This is a list of all functions Libnodave provides. Those marked with "i" are implemented. Those
marked with "t" also have been tested. daveStringCopy is a special thing implemented for 
interaction with Visual Basic.

The davePut...() functions marked "to do ?" are used in C language to put a value into an array
of unsigned chars which than serves as a buffer for daveWriteBytes() etc. 

i+t 		char *  daveStrerror(int code);
i+t		void  daveStringCopy(char * intString, char * extString);
i+t		void  daveSetDebug(int nDebug);
i+t		int  daveGetDebug(void);
i+t		daveInterface *  daveNewInterface(_daveOSserialType nfd, char * nname, int localMPI, int protocol, int speed);
i+t		daveConnection *  daveNewConnection(daveInterface * di, int MPI,int rack, int slot);
i		int  daveGetResponse(daveConnection * dc);
i		int  daveSendMessage(daveConnection * dc, PDU * p);
i		void  _daveDumpPDU(PDU * p);
i		void  _daveDump(char * name,uc*b,int len);
i+t		char *  daveBlockName(uc bn);
i+t		char *  daveAreaName(uc n);
i		short  daveSwapIed_16(short ff);
i+t		int  daveSwapIed_32(int ff);
i		float  daveGetFloatAt(daveConnection * dc, int pos);
i		float  toPLCfloat(float ff);
i		int  daveToPLCfloat(float ff);

i		int  daveGetS8from(uc *b);
i		int  daveGetU8from(uc *b);
i		int  daveGetS16from(uc *b);
i		int  daveGetU16from(uc *b);
i		int  daveGetS32from(uc *b);
i		unsigned int  daveGetU32from(uc *b);
i		float  daveGetFloatfrom(uc *b);

i		int  daveGetS8(daveConnection * dc);
i+t		int  daveGetU8(daveConnection * dc);
i		int  daveGetS16(daveConnection * dc);
i+t		int  daveGetU16(daveConnection * dc);
i		int  daveGetS32(daveConnection * dc);
i+t		unsigned int  daveGetU32(daveConnection * dc);
i+t 		float  daveGetFloat(daveConnection * dc);

i		int  daveGetS8At(daveConnection * dc, int pos);
i		int  daveGetU8At(daveConnection * dc, int pos);
i		int  daveGetS16At(daveConnection * dc, int pos);
i		int  daveGetU16At(daveConnection * dc, int pos);
i		int  daveGetS32At(daveConnection * dc, int pos);
i		unsigned int  daveGetU32At(daveConnection * dc, int pos);

i+t		uc *  davePut8(uc *b,int v);
i+t		uc *  davePut16(uc *b,int v);
i+t		uc *  davePut32(uc *b,int v);
i+t		uc *  davePutFloat(uc *b,float v);

i		void  davePut8At(uc *b, int pos, int v);
i		void  davePut16At(uc *b, int pos, int v);
i		void  davePut32At(uc *b, int pos, int v);
i		void  davePutFloatAt(uc *b,int pos, float v);

i		float  daveGetSeconds(daveConnection * dc);
i		float  daveGetSecondsAt(daveConnection * dc, int pos);

i		int  daveGetCounterValue(daveConnection * dc);
i		int  daveGetCounterValueAt(daveConnection * dc,int pos);

not implemented	void  _daveConstructUpload(PDU *p,char blockType, int blockNr);
not implemented	void  _daveConstructDoUpload(PDU * p, int uploadID);
not implemented	void  _daveConstructEndUpload(PDU * p, int uploadID);

i+t		int  daveGetOrderCode(daveConnection * dc,char * buf);

i+t		int  daveConnectPLC(daveConnection * dc);
i+t		int  daveReadBytes(daveConnection * dc, int area, int DB, int start, int len, void * buffer);
i		int  daveReadManyBytes(daveConnection * dc, int area, int DB, int start, int len, void * buffer);
i+t		int  daveWriteBytes(daveConnection * dc,int area, int DB, int start, int len, void * buffer);
i		int  daveWriteManyBytes(daveConnection * dc,int area, int DB, int start, int len, void * buffer);
i		int  daveReadBits(daveConnection * dc, int area, int DB, int start, int len, void * buffer);
i		int  daveWriteBits(daveConnection * dc,int area, int DB, int start, int len, void * buffer);
i		int  daveSetBit(daveConnection * dc,int area, int DB, int byteAdr, int bitAdr);
i		int  daveClrBit(daveConnection * dc,int area, int DB, int byteAdr, int bitAdr);

i+t		int  daveReadSZL(daveConnection * dc, int ID, int index, void * buf);

i		int  daveListBlocksOfType(daveConnection * dc,uc type,daveBlockEntry * buf);
i		int  daveListBlocks(daveConnection * dc,daveBlockTypeEntry * buf);
i		int  daveGetBlockInfo(daveConnection * dc, NULL, int type, int number);

not implemented	int  initUpload(daveConnection * dc,char blockType, int blockNr, int * uploadID);
not implemented	int  doUpload(daveConnection*dc, int * more, uc**buffer, int*len, int uploadID);
not implemented	int  endUpload(daveConnection*dc, int uploadID);

i+t		int  daveStop(daveConnection*dc);
i+t		int  daveStart(daveConnection*dc);
i		int  daveForce200(daveConnection * dc, int area, int start, int val);
	
i+t		void  davePrepareReadRequest(daveConnection * dc, PDU *p);
i+t		void  daveAddVarToReadRequest(PDU *p, int area, int DBnum, int start, int bytes);
i+t		int  daveExecReadRequest(daveConnection * dc, PDU *p, daveResultSet * rl);
i+t		int  daveUseResult(daveConnection * dc, daveResultSet * rl, int n);
i+t		void  daveFreeResults(daveResultSet * rl);
i		void  daveAddBitVarToReadRequest(PDU *p, int area, int DBnum, int start, int byteCount);

i+t		void  davePrepareWriteRequest(daveConnection * dc, PDU *p);
i+t		void  daveAddVarToWriteRequest(PDU *p, int area, int DBnum, int start, int bytes, void * buffer);
i+t		void  daveAddBitVarToWriteRequest(PDU *p, int area, int DBnum, int start, int byteCount, void * buffer);
i+t		int   daveExecWriteRequest(daveConnection * dc, PDU *p, daveResultSet * rl);

i+t		int  daveInitAdapter(daveInterface * di);
i+t		int  daveDisconnectPLC(daveConnection * dc);

i+t		int  daveDisconnectAdapter(daveInterface * di);

i		int  daveListReachablePartners(daveInterface * di,char * buf);

i+t		void  daveSetTimeout(daveInterface * di, int tmo);
i+t		int  daveGetTimeout(daveInterface * di);

i+t		char *  daveGetName(daveInterface * di);

i		int  daveGetMPIAdr(daveConnection * dc);
i+t		int  daveGetAnswLen(daveConnection * dc);
i+t		daveResultSet *  daveNewResultSet();
i+t		void  daveFree(void * dc);
i+t		PDU *  daveNewPDU();
i+t		int  daveGetErrorOfResult(daveResultSet *,int number);
i		int  daveForceDisconnectIBH(daveInterface * di, int src, int dest, int mpi);

i		int daveGetProgramBlock(daveConnection * dc, int blockType, int number, char* buffer);
i		daveReadPLCTime Lib "libnodave.dll" (ByVal dc As Long) As Long
i		daveSetPLCTime Lib "libnodave.dll" (ByVal dc As Long, ByRef timestamp As Byte) As Long
i		daveSetPLCTimeToSystime Lib "libnodave.dll" (ByVal dc As Long) As Long
i		daveToBCD Lib "libnodave.dll" (ByVal dc As Long) As Long
i		daveFromBCD Lib "libnodave.dll" (ByVal dc As Long) As Long
