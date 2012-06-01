/*
 Very simple program to read from a 200 PLC via PPI cable.
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
    static int localPPI=0;
    static int plcPPI=2;
    public static int Main (string[] args)
    {
	int i,a=0,j,res,b=0,c=0;
	float d=0;

        fds.rfd=libnodave.setPort(args[0],"9600",'E');
	fds.wfd=fds.rfd;
        if (fds.rfd>0) { 
	    di =new libnodave.daveInterface(fds, "IF1", localPPI, libnodave.daveProtoPPI, libnodave.daveSpeed187k);
    	    di.setTimeout(1000000);
//	    res=di.initAdapter();	// does nothing in PPI. But call it to keep your programs indpendent of protocols
//	    if(res==0) {
		dc = new libnodave.daveConnection(di,plcPPI, 0, 0);
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
//	    di.disconnectAdapter();	// does nothing in PPI. But call it to keep your programs indpendent of protocols
	    libnodave.closePort(fds.rfd);
	} else {
	    Console.WriteLine("Couldn't open serial port "+args[0]);
	    return -1;
	}	
	return 0;
    }
}
