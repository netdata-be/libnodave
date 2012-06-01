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
    int a,b,c,
	res;
    float d;
    daveInterface * di;
    daveConnection * dc;
    _daveOSserialType fds;
    
    if (argc<2) {
	printf("Usage: testPPI serial port.\n");
	exit(-1);
    }    

    fds.rfd=setPort(argv[1],"9600",'E');
    fds.wfd=fds.rfd;
    if (fds.rfd>0) { 
	di =daveNewInterface(fds, "IF1", 0, daveProtoPPI, daveSpeed187k);
	dc =daveNewConnection(di, 2, 0, 0);  
	daveConnectPLC(dc);
	printf("Trying to read 16 bytes from FW0.\n");
	res=daveReadBytes(dc,daveFlags,0,0,16,NULL);
	if (res==0) {
    	    a=daveGetU32(dc);
            b=daveGetU32(dc);
	    c=daveGetU32(dc);
    	    d=daveGetFloat(dc);
	    printf("FD0: %d\n",a);
	    printf("FD4: %d\n",b);
	    printf("FD8: %d\n",c);
	    printf("FD12: %f\n",d);
	}	    
	
	return 0;
    } else {
	printf("Couldn't open serial port %s\n",argv[1]);	
	return -1;
    }	
}

/*
    Changes: 
    07/15/05  did thi simplified version.
*/
