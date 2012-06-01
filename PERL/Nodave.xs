/*
 PERL module to library function call translations.
 
 Part of Libnodave, a free communication libray for Siemens S7 200/300/400 via
 the MPI adapter 6ES7 972-0CA22-0XAC
 or  MPI adapter 6ES7 972-0CA23-0XAC
 or  TS adapter 6ES7 972-0CA33-0XAC
 or  MPI adapter 6ES7 972-0CA11-0XAC,
 IBH/MHJ-NetLink or CPs 243, 343 and 443
 
 (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2005

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

/*
    Changes: 05/15/06 applied bug fixes from H.-J. Beie. Thank you!
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#define LINUX
#include <nodave.h>

#include "const-c.inc"

typedef struct _daveInterface*	DaveInterface;
typedef struct _daveConnection*	DaveConnection;
typedef PDU*	DavePDU;
typedef daveResultSet*	DaveResultSet;

MODULE = Nodave		PACKAGE = Nodave		

INCLUDE: const-xs.inc

char *
daveStrerror(code)
    int code
  PROTOTYPE: $
  CODE:
    RETVAL=daveStrerror(code);
  OUTPUT:
    RETVAL

void
daveSetDebug (level)
	int level
  PROTOTYPE: $
  CODE:
	daveSetDebug(level);
  OUTPUT:
	
int
daveGetDebug ()
  PROTOTYPE: 
  CODE:
	RETVAL = daveGetDebug();
  OUTPUT:
	RETVAL

DaveInterface
daveNewInterface (r,w,name,y,x,z)
    
    int r
    int w
    char * name
    int y
    int x
    int z
    
    
  PROTOTYPE: $$$$$$
  CODE:
	_daveOSserialType sif;
	sif.rfd=r;
	sif.wfd=w;
	RETVAL = daveNewInterface(sif,name,y,x,z);
  OUTPUT:
	RETVAL

DaveConnection
daveNewConnection (di,y,x,z)
    DaveInterface di
    int y
    int x
    int z
  PROTOTYPE: $$$$
  CODE:
	RETVAL = daveNewConnection(di,y,x,z);
  OUTPUT:
	RETVAL


int daveGetResponse(dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetResponse(dc);	
  OUTPUT:
	RETVAL

int daveSendMessage(dc, p)
    DaveConnection dc
    DavePDU p
  PROTOTYPE: $
  CODE:
	RETVAL = daveSendMessage(dc, p);
  OUTPUT:
	RETVAL

void daveDumpPDU(p);
    DavePDU p
    PROTOTYPE: $
  CODE:
    _daveDumpPDU(p);

void daveDump(name, b, len);
    char * name
    char * b
    int len
    PROTOTYPE: $$$
  CODE:
    _daveDump(name,b,len);

char * daveBlockName(bn)
    int bn
  PROTOTYPE: $
  CODE:
	RETVAL = daveBlockName(bn);
  OUTPUT:
	RETVAL

char * daveAreaName(n);	
    int n
  PROTOTYPE: $
  CODE:
	RETVAL = daveAreaName(n);
  OUTPUT:
	RETVAL

short daveSwapIed_16(ff);
    short ff
  PROTOTYPE: $
  CODE:
	RETVAL = daveSwapIed_16(ff);
  OUTPUT:
	RETVAL

int daveSwapIed_32(ff);
    int ff
  PROTOTYPE: $
  CODE:
	RETVAL = daveSwapIed_32(ff);
  OUTPUT:
	RETVAL

float
daveGetFloatAt (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetFloatAt(dc,pos);
  OUTPUT:
	RETVAL

float toPLCfloat(f);	
    float f
  PROTOTYPE: $
  CODE:
	RETVAL = toPLCfloat(f);
  OUTPUT:
	RETVAL

int daveToPLCfloat(f);	
    float f
  PROTOTYPE: $
  CODE:
	RETVAL = daveToPLCfloat(f);
  OUTPUT:
	RETVAL

int
daveGetS8from (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetS8from(buffer+pos);
  OUTPUT:
	RETVAL

int
daveGetU8from (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetU8from(buffer+pos);
  OUTPUT:
	RETVAL

int
daveGetS16from (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetS16from(buffer+pos);
  OUTPUT:
	RETVAL

int
daveGetU16from (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetU16from(buffer+pos);
  OUTPUT:
	RETVAL

int
daveGetS32from (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetS32from(buffer+pos);
  OUTPUT:
	RETVAL

unsigned int
daveGetU32from (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetU32from(buffer+pos);
  OUTPUT:
	RETVAL

float
daveGetFloatfrom (buffer, pos)
    char * buffer
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetFloatfrom(buffer+pos);
  OUTPUT:
	RETVAL

int
daveGetS8 (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetS8(dc);
  OUTPUT:
	RETVAL

int
daveGetU8 (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetU8(dc);
  OUTPUT:
	RETVAL

int
daveGetS16 (dc)
    DaveConnection dc

  PROTOTYPE: $
  CODE:
	RETVAL = daveGetS16(dc);
  OUTPUT:
	RETVAL

int
daveGetU16 (dc)
    DaveConnection dc

  PROTOTYPE: $
  CODE:
	RETVAL = daveGetU16(dc);
  OUTPUT:
	RETVAL

int
daveGetS32 (dc)
    DaveConnection dc

  PROTOTYPE: $
  CODE:
	RETVAL = daveGetS32(dc);
  OUTPUT:
	RETVAL

unsigned int
daveGetU32 (dc)
    DaveConnection dc

  PROTOTYPE: $
  CODE:
	RETVAL = daveGetU32(dc);
  OUTPUT:
	RETVAL

float
daveGetFloat (dc)
    DaveConnection dc
    
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetFloat(dc);
  OUTPUT:
	RETVAL

float
daveGetS8At (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetS8At(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetU8At (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetU8At(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetS16At (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetS16At(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetU16At (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetU16At(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetS32At (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetS32At(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetU32At (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetU32At(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetSeconds (dc)
    DaveConnection dc
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetSeconds(dc);
  OUTPUT:
	RETVAL

float
daveGetSecondsAt (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetSecondsAt(dc,pos);
  OUTPUT:
	RETVAL

float
daveGetCounterValue (dc)
    DaveConnection dc
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetCounterValue(dc);
  OUTPUT:
	RETVAL

float
daveGetCounterValueAt (dc, pos)
    DaveConnection dc
    int pos
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetCounterValueAt(dc,pos);
  OUTPUT:
	RETVAL


int
daveConnectPLC (dc)
    DaveConnection dc
    
    
  PROTOTYPE: $
  CODE:
	RETVAL = daveConnectPLC(dc);
  OUTPUT:
	RETVAL

void
daveReadBytes (dc, area, areaNumber, start, bytes)
    DaveConnection dc
    int area
    int areaNumber
    int start
    int bytes
  PROTOTYPE: $$$$$
  PPCODE:
	char buffer[1024];
	int rv;
	rv = daveReadBytes (dc, area, areaNumber, start, bytes, buffer);
	EXTEND(SP,2);
	PUSHs(sv_2mortal(newSVpvn(&buffer[0],bytes)));
	PUSHs(sv_2mortal(newSViv(rv)));

int
daveWriteBytes (dc, area, areaNumber, start, bytes, buffer)
    DaveConnection dc
    int area
    int areaNumber
    int start
    int bytes
    char* buffer
    
  PROTOTYPE: $$$$$$
  CODE:
	RETVAL = daveWriteBytes (dc, area, areaNumber, start, bytes, buffer);
  OUTPUT:
	RETVAL

void
daveReadBits (dc, area, areaNumber, start, bytes=1)
    DaveConnection dc
    int area
    int areaNumber
    int start
    int bytes
  PROTOTYPE: $$$$;$
  PPCODE:
	char buffer[1024];
	int rv;
	rv = daveReadBits (dc, area, areaNumber, start, bytes, buffer);
//	rv = daveReadBits (dc, area, areaNumber, start, bytes, NULL);
	EXTEND(SP,2);
	PUSHs(sv_2mortal(newSVpvn(&buffer[0],bytes)));
	PUSHs(sv_2mortal(newSViv(rv)));

int
daveWriteBits (dc, area, areaNumber, start, bytes, buffer)
    DaveConnection dc
    int area
    int areaNumber
    int start
    int bytes
    char * buffer
    PROTOTYPE: $$$$$$
  CODE:
	RETVAL = daveWriteBits (dc, area, areaNumber, start, bytes, buffer);
  OUTPUT:
	RETVAL

int
daveSetBit (dc, area, DB, byteAdr, bitAdr)
    DaveConnection dc
    int area
    int DB
    int byteAdr
    int bitAdr
  PROTOTYPE: $$$$$
  CODE:
	RETVAL = daveSetBit (dc, area, DB, byteAdr, bitAdr);
  OUTPUT:
	RETVAL

int
daveClrBit (dc, area, DB, byteAdr, bitAdr)
    DaveConnection dc
    int area
    int DB
    int byteAdr
    int bitAdr
  PROTOTYPE: $$$$$
  CODE:
	RETVAL = daveClrBit (dc, area, DB, byteAdr, bitAdr);
  OUTPUT:
	RETVAL











	
DavePDU
daveNewPDU ()
    
  PROTOTYPE:
  CODE:
	RETVAL = daveNewPDU();
  OUTPUT:
	RETVAL

DaveResultSet
daveNewResultSet ()
    
  PROTOTYPE:
  CODE:
	RETVAL = daveNewResultSet();
  OUTPUT:
	RETVAL


int
daveInitAdapter (di)
    DaveInterface di
    
    
  PROTOTYPE: $
  CODE:
	RETVAL = daveInitAdapter(di);
  OUTPUT:
	RETVAL



int
daveDisconnectPLC (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveDisconnectPLC(dc);
  OUTPUT:
	RETVAL

int
daveDisconnectAdapter (di)
    DaveInterface di
  PROTOTYPE: $
  CODE:
	RETVAL = daveDisconnectAdapter(di);
  OUTPUT:
	RETVAL






	
int
daveStop (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveStop(dc);
  OUTPUT:
	RETVAL

int
daveStart (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveStart(dc);
  OUTPUT:
	RETVAL
	


void davePrepareReadRequest(dc, p);
    DaveConnection dc
    DavePDU p
  PROTOTYPE: $$
  CODE:
    davePrepareReadRequest(dc, p);


    
int daveExecReadRequest(dc, p, rl);
    DaveConnection dc
    DavePDU p
    DaveResultSet  rl
  PROTOTYPE: $$$
  CODE:
	RETVAL = daveExecReadRequest(dc, p, rl);
  OUTPUT:
	RETVAL

int daveUseResult(dc, rl, n);
    DaveConnection dc
    DaveResultSet  rl
    int n
  PROTOTYPE: $$$
  CODE:
	RETVAL = daveUseResult(dc, rl, n);
  OUTPUT:
	RETVAL
    
void daveFreeResults(rl);
    DaveResultSet  rl
  PROTOTYPE: $
  CODE:
	daveFreeResults(rl);

void davePrepareWriteRequest(dc, p);
    DaveConnection dc
    DavePDU p
  PROTOTYPE: $$
  CODE:
	davePrepareWriteRequest(dc, p);

void daveAddVarToWriteRequest(p, area, DBnum, start, bytes, buffer);
    DavePDU p
    int area
    int DBnum
    int start
    int bytes
    char* buffer
  PROTOTYPE: $$$$$$
  CODE:
    daveAddVarToWriteRequest(p, area, DBnum, start, bytes, buffer);

void daveAddBitVarToWriteRequest(p, area, DBnum, start, bytes, buffer);
    DavePDU p
    int area
    int DBnum
    int start
    int bytes
    char* buffer        
  PROTOTYPE: $$$$$$
  CODE:
    daveAddBitVarToWriteRequest(p, area, DBnum, start, bytes, buffer);

void daveAddVarToReadRequest(p, area, DBnum, start, bytes);
    DavePDU p
    int area
    int DBnum
    int start
    int bytes
  PROTOTYPE: $$$$$
  CODE:
    daveAddVarToReadRequest(p, area, DBnum, start, bytes);

void daveAddBitVarToReadRequest(p, area, DBnum, start, bytes);
    DavePDU p
    int area
    int DBnum
    int start
    int bytes
  PROTOTYPE: $$$$$
  CODE:
    daveAddBitVarToReadRequest(p, area, DBnum, start, bytes);

int 
setPort (port, baud, parity)
	char* port
	char* baud
	char parity
  PROTOTYPE: $$$
  CODE:
	RETVAL = setPort(port, baud, parity);
  OUTPUT:
	RETVAL

int 
openSocket (port, peer)
	int port
	char* peer
  PROTOTYPE: $$
  CODE:
	RETVAL = openSocket(port, peer);
  OUTPUT:
	RETVAL

int 
closePort (port)
	int port
  PROTOTYPE: $
  CODE:
	RETVAL = closePort(port);
  OUTPUT:
	RETVAL

int 
closeSocket (port)
	int port
  PROTOTYPE: $
  CODE:
	RETVAL = closeSocket(port);
  OUTPUT:
	RETVAL

int
daveGetTimeout (di)
    DaveInterface di
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetTimeout(di);
  OUTPUT:
	RETVAL

void
daveSetTimeout (di, time)
    DaveInterface di
    int time
  PROTOTYPE: $$
  CODE:
	daveSetTimeout(di, time);

char *
daveGetName (di)
    DaveInterface di
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetName(di);
  OUTPUT:
	RETVAL

int
daveGetAnswLen (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetAnswLen(dc);
  OUTPUT:
	RETVAL

int
daveGetMaxPDULen (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetMaxPDULen(dc);
  OUTPUT:
	RETVAL

int
daveGetMPIAdr (dc)
    DaveConnection dc
  PROTOTYPE: $
  CODE:
	RETVAL = daveGetMPIAdr(dc);
  OUTPUT:
	RETVAL

int
daveGetErrorOfResult (drs, n)
    DaveResultSet drs
    int n
  PROTOTYPE: $$
  CODE:
	RETVAL = daveGetErrorOfResult (drs, n);
  OUTPUT:
	RETVAL

int
daveForceDisconnectIBH (di,src,dest,mpi)
    DaveInterface di
    int src
    int dest
    int mpi
  PROTOTYPE: $$$$
  CODE:
	RETVAL = daveForceDisconnectIBH (di,src,dest,mpi);
  OUTPUT:
	RETVAL

int 
daveForce200(dc, area, start, val);
    DaveConnection dc
    int area
    int start
    int val
  PROTOTYPE: $$$$
  CODE:
	RETVAL = daveForce200 (dc, area, start, val);
  OUTPUT:
	RETVAL

void
daveGetOrderCode (dc)
    DaveConnection dc
  PROTOTYPE: $
  PPCODE:
	char buffer[1024];
	int rv;
	rv = daveGetOrderCode(dc, buffer);
	EXTEND(SP,2);
	PUSHs(sv_2mortal(newSVpvn(&buffer[0],daveOrderCodeSize)));
	PUSHs(sv_2mortal(newSViv(rv)));

void daveReadSZL(dc, ID, index);    
    DaveConnection dc
    int ID
    int index
  PROTOTYPE: $$$
  PPCODE:
	char buffer[3000];
	int rv;
	rv = daveReadSZL(dc, ID, index, buffer, 3000);
	EXTEND(SP,2);
	PUSHs(sv_2mortal(newSVpvn(&buffer[0],daveOrderCodeSize)));
	PUSHs(sv_2mortal(newSViv(rv)));

void daveListReachablePartners(di);    
    DaveInterface di
  PROTOTYPE: $
  PPCODE:
	char buffer[126];
	int rv;
	rv = daveListReachablePartners(di, buffer);
	EXTEND(SP,2);
	PUSHs(sv_2mortal(newSVpvn(&buffer[0],daveOrderCodeSize)));
	PUSHs(sv_2mortal(newSViv(rv)));

MODULE = Nodave		PACKAGE = DaveInterface	PREFIX = di_

void di_DESTROY(di)
    DaveInterface di
    CODE:
//	printf("freeing DaveInterface %p\n",di);
	daveFree(di);
	
MODULE = Nodave		PACKAGE = DaveConnection	PREFIX = dc_

void dc_DESTROY(dc)
    DaveConnection dc
    CODE:
//	printf("freeing DaveConnection %p\n",dc);
	daveFree(dc);	

MODULE = Nodave		PACKAGE = DavePDU	PREFIX = dp_

void dp_DESTROY(dp)
    DavePDU dp
    CODE:
//	printf("freeing DavePDU %p\n",dp);
	daveFree(dp);	

MODULE = Nodave		PACKAGE = DaveResultSet	PREFIX = drs_

void drs_DESTROY(drs)
    DaveResultSet drs
    CODE:
//	printf("freeing DaveResultSet %p\n",drs);
	daveFreeResults(drs);
	daveFree(drs);	

