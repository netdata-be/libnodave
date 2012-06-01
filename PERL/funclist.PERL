This is a list of all functions Libnodave provides. Those marked with "i" are implemented. Those
marked with "t" also have been tested. daveStringCopy is a special thing implemented for 
interactionwith Visual Basic. No need for that in Perl.

The davePut...() functions marked "to do ?" are used in C language to put a value into an array
of unsigned chars which than serves as a buffer for daveWriteBytes() etc. See test.pl for a more 
"perlish" realization using pack(). While pack() can also reorder bytes for different endianness,
I highly recommend to use daveSwapIed() for this purpose. The implementation of this function will
swap if and only if PLC endianness is different from target machine. While Intel to Siemens 
differs the same way as Intel to Network order, if a future hypothetic Siemens S9 will use Intel 
byte order and you are on a big endian machine, daveSwapIed() can still be supposed to do it right...

The functions marked "to do" will definitely be implemented in a future release, but as they are
useful for program transfer to an S7 PLC, which most users will never attempt, I consider them
not so important. They also need a lot of surrounding code in the application.

This is similar with daveReadSZL: Libnodave provides the basic capability to read out diagnostic
lists as a block of bytes. The PERL example code can divide it into single entries of equal 
length. But a really useful application would need to interpret the contents applying knowledge
about the structure of these lists according to ID and index. While this could be done more or 
less easily, a complete implementation of diagnostics would make Libnodave three times larger,
more dependent of the actual PLC model and most users will never need it. To implement such 
functionaity in your application, refer to publicly available Siemens documentation.

Last, daveFree() is not implemented. PERL doesn't seem to know a typeless pointer (void *). 
daveFree() can free al sort of structures, but that is not necessary. For those structures 
you can allocate via implemented functions like daveNewInterface, automatic destruction
has been implemented. The one thing you'll have to free manually are the results contained 
in a resultSet if and only if you want to use the same resultSet in a second call to 
daveExecReadRequest() or daveExecReadRequest().

i+t 		char *  daveStrerror(int code);
makes no sense	void  daveStringCopy(char * intString, char * extString);
i+t		void  daveSetDebug(int nDebug);
i+t		int  daveGetDebug(void);
i+t		daveInterface *  daveNewInterface(_daveOSserialType nfd, char * nname, int localMPI, int protocol, int speed);
i+t		daveConnection *  daveNewConnection(daveInterface * di, int MPI,int rack, int slot);
i		int  daveGetResponse(daveConnection * dc);
i		int  daveSendMessage(daveConnection * dc, PDU * p);
i+t		void  _daveDumpPDU(PDU * p);
i+t		void  _daveDump(char * name,uc*b,int len);
i+t		char *  daveBlockName(uc bn);
i+t		char *  daveAreaName(uc n);
i+t		short  daveSwapIed_16(short ff);
i+t		int  daveSwapIed_32(int ff);
i+t		float  daveGetFloatAt(daveConnection * dc, int pos);
i		float  toPLCfloat(float ff);
i+t		int  daveToPLCfloat(float ff);

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

to do ?		uc *  davePut8(uc *b,int v);
to do ?		uc *  davePut16(uc *b,int v);
to do ?		uc *  davePut32(uc *b,int v);
to do ?		uc *  davePutFloat(uc *b,float v);

to do ?		void  davePut8At(uc *b, int pos, int v);
to do ?		void  davePut16At(uc *b, int pos, int v);
to do ?		void  davePut32At(uc *b, int pos, int v);
to do ?		void  davePutFloatAt(uc *b,int pos, float v);

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
i+t		int  daveWriteBytes(daveConnection * dc,int area, int DB, int start, int len, void * buffer);
i+t		int  daveReadBits(daveConnection * dc, int area, int DB, int start, int len, void * buffer);
i		int  daveWriteBits(daveConnection * dc,int area, int DB, int start, int len, void * buffer);
i		int  daveSetBit(daveConnection * dc,int area, int DB, int byteAdr, int bitAdr);
i		int  daveClrBit(daveConnection * dc,int area, int DB, int byteAdr, int bitAdr);

i+t		int  daveReadSZL(daveConnection * dc, int ID, int index, void * buf, int buflen);

to do		int  daveListBlocksOfType(daveConnection * dc,uc type,daveBlockEntry * buf);
to do		int  daveListBlocks(daveConnection * dc,daveBlockTypeEntry * buf);

to do 		int  initUpload(daveConnection * dc,char blockType, int blockNr, int * uploadID);
to do 		int  doUpload(daveConnection*dc, int * more, uc**buffer, int*len, int uploadID);
to do 		int  endUpload(daveConnection*dc, int uploadID);

i+t		int  daveStop(daveConnection*dc);
i+t		int  daveStart(daveConnection*dc);
i+t		int  daveForce200(daveConnection * dc, int area, int start, int val);
	
i+t		void  davePrepareReadRequest(daveConnection * dc, PDU *p);
i+t		void  daveAddVarToReadRequest(PDU *p, int area, int DBnum, int start, int bytes);
i+t		int  daveExecReadRequest(daveConnection * dc, PDU *p, daveResultSet * rl);
i+t		int  daveUseResult(daveConnection * dc, daveResultSet * rl, int n);
i+t		void  daveFreeResults(daveResultSet * rl);
i		void  daveAddBitVarToReadRequest(PDU *p, int area, int DBnum, int start, int byteCount);

i		void  davePrepareWriteRequest(daveConnection * dc, PDU *p);
i		void  daveAddVarToWriteRequest(PDU *p, int area, int DBnum, int start, int bytes, void * buffer);
i		void  daveAddBitVarToWriteRequest(PDU *p, int area, int DBnum, int start, int byteCount, void * buffer);
i		int  daveExecWriteRequest(daveConnection * dc, PDU *p, daveResultSet * rl);

i+t		int  daveInitAdapter(daveInterface * di);
i+t		int  daveConnectPLC(daveConnection * dc);
i+t		int  daveDisconnectPLC(daveConnection * dc);

i		int  daveDisconnectAdapter(daveInterface * di);

i+t		int  daveListReachablePartners(daveInterface * di,char * buf);

i		void  daveSetTimeout(daveInterface * di, int tmo);
i		int  daveGetTimeout(daveInterface * di);

i		char *  daveGetName(daveInterface * di);

i		int  daveGetMPIAdr(daveConnection * dc);
i		int  daveGetAnswLen(daveConnection * dc);
i		int  daveGetMaxPDULen(daveConnection * dc);
i+t		daveResultSet *  daveNewResultSet();
not implemented	void  daveFree(void * dc);
i+t		PDU *  daveNewPDU();
i		int  daveGetErrorOfResult(daveResultSet *,int number);

i		int  daveForceDisconnectIBH(daveInterface * di, int src, int dest, int mpi);
