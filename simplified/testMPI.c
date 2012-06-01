/*
 Simplified test and demo program for Libnodave, a free communication libray for Siemens S7.
 
 **********************************************************************
 * WARNING: This and other test programs overwrite data in your PLC.  *
 * DO NOT use it on PLC's when anything is connected to their outputs.*
 * This is alpha software. Use entirely on your own risk.             * 
 **********************************************************************
 
 (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2005.

 This is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2, or (at your option)
 any later version.

 This is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Libnodave; see the file COPYING.  If not, write to
 the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
*/
#include <stdlib.h>
#include <stdio.h>
#include "nodavesimple.h"
#include "setport.h"

int main(int argc, char **argv) {
    int i, a,b,c, initSuccess,
	res;
    float d;
    daveInterface * di;
    daveConnection * dc;
    _daveOSserialType fds;
    
    if (argc<2) {
	printf("Usage: testMPI serial port.\n");
	exit(-1);
    }    

    fds.rfd=setPort(argv[1],"38400",'O');
    fds.wfd=fds.rfd;
    initSuccess=0;	
    if (fds.rfd>0) { 
	di =daveNewInterface(fds, "IF1", 0, daveProtoMPI, daveSpeed187k);
	daveSetTimeout(di,5000000);
	for (i=0; i<3; i++) {
	    if (0==daveInitAdapter(di)) {
		initSuccess=1;	
		break;	
	    } else daveDisconnectAdapter(di);
	}
	if (!initSuccess) {
	    printf("Couldn't connect to Adapter!.\n Please try again. You may also try the option -2 for some adapters.\n");	
	    return -3;
	}
	dc =daveNewConnection(di, 2, 0, 0);
	printf("ConnectPLC\n");
	if (0==daveConnectPLC(dc)) {;
	res=daveReadBytes(dc, daveFlags, 0, 0, 16,NULL);
	if (res==0) {
    	    a=daveGetS32(dc);	
    	    b=daveGetS32(dc);
    	    c=daveGetS32(dc);
	    d=daveGetFloat(dc);
	    printf("PLC FD0: %d\n", a);
	    printf("PLC FD4: %d\n", b);
	    printf("PLC FD8: %d\n", c);
	    printf("PLC FD12: %f\n", d);
	} else 
	    printf("error %d=%s\n", res, daveStrerror(res));
	
	daveFree(dc);
	daveDisconnectAdapter(di);
	daveFree(di);
	return 0;
	} else {
	    printf("Couldn't connect to PLC.\n Please try again. You may also try the option -2 for some adapters.\n");	
	    daveDisconnectAdapter(di);
	    daveDisconnectAdapter(di);
	    daveDisconnectAdapter(di);
	    return -2;
	}
    } else {
	printf("Couldn't open serial port %s\n",argv[1]);	
	return -1;
    }	
}

/*
    Changes: 
    07/15/05  did this simplified version.
*/
