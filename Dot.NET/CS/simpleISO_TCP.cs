/*
 Very simple program to read from a 300/400 PLC via MPI adapter.
 This shall provide users with a simple starting point for their own
 applications.
 
 Part of Libnodave, a free communication libray for Siemens S7 200/300/400
  
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

using System;

class test {
    static libnodave.daveOSserialType fds;
    static libnodave.daveInterface di;
    static libnodave.daveConnection dc;
    static int rack=0;
    static int slot=2;
    public static int Main (string[] args)
    {
	int i,a=0,j,res,b=0,c=0;
	float d=0;

        fds.rfd=libnodave.openSocket(102,args[0]);
	fds.wfd=fds.rfd;
        if (fds.rfd>0) { 
	    di =new libnodave.daveInterface(fds, "IF1", 0, libnodave.daveProtoISOTCP, libnodave.daveSpeed187k);
    	    di.setTimeout(1000000);
//	    res=di.initAdapter();	// does nothing in ISO_TCP. But call it to keep your programs indpendent of protocols
//	    if(res==0) {
		dc = new libnodave.daveConnection(di,0 , rack, slot);
		if (0==dc.connectPLC()) {
		    res=dc.readBytes(libnodave.daveFlags, 0, 0, 16, null);
		    if (res==0) {
    			a=dc.getS32();	
    			b=dc.getS32();
    			c=dc.getS32();
			d=dc.getFloat();
			Console.WriteLine("FD0: " + a);
			Console.WriteLine("FD4: " + b);
			Console.WriteLine("FD8: " + c);
			Console.WriteLine("FD12: " + d);
		    } else 
			Console.WriteLine("error "+res+" "+libnodave.daveStrerror(res));
		}
		dc.disconnectPLC();
//	    }	    
//	    di.disconnectAdapter();	// does nothing in ISO_TCP. But call it to keep your programs indpendent of protocols
	    libnodave.closeSocket(fds.rfd);
	} else {
	    Console.WriteLine("Couldn't open TCP connaction to "+args[0]);
	    return -1;
	}	
	return 0;
    }
}

/*
Version 0.8.4.5    
07/10/09  	Added closeSocket()
*/
