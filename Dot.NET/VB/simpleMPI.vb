'
' Very simple program to read from a 300/400 PLC via MPI adapter.
' This shall provide users wit a simple starting point for their own
' applications.
' 
' Part of Libnodave, a free communication libray for Siemens S7 200/300/400
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

Imports System
Imports Microsoft.VisualBasic

Class test
    Public Shared Function Main(args() As String) As Integer

	Dim localMPI As Integer = 0, plcMPI As Integer = 2
	
	Dim fds As libnodave.daveOSserialType
	Dim di as libnodave.daveInterface
	Dim dc as libnodave.daveConnection
	Dim res As Integer
	Dim a,b,c As Integer, d As Single
	Dim buf(1000) as byte
	Dim s As string
	
	Console.WriteLine("Hello World!")
        fds.rfd=libnodave.setPort(args(0), "38400", AscW("O"))	' step 1, open a connection
	fds.wfd=fds.rfd
        if fds.rfd>0 then		' if step 1 is ok
	    di =new libnodave.daveInterface(fds, "My Interface 1", localMPI, libnodave.daveProtoMPI, libnodave.daveSpeed187k)
    	    di.setTimeout(1000000)	' Make this longer if you have a very long response time
	    res = di.initAdapter
'
	    if res=0 then		' init Adapter is ok
		dc = new libnodave.daveConnection(di, plcMPI, 0, 0)  ' rack amd slot don't matter in case of MPI
		res=dc.connectPLC()
		if res=0 then
		    res=dc.readBytes(libnodave.daveFlags, 0, 0, 16, buf)
		    if res=0 then
    			a=dc.getS32
    			b=dc.getS32
    			c=dc.getS32
			d=dc.getFloat
			Console.WriteLine("FD0:  {0:d}", a)
			Console.WriteLine("FD4:  {0:d}", b)
			Console.WriteLine("FD8:  {0:d}", c)
			Console.WriteLine("FD12: {0:f}", d)
		    else
			Console.WriteLine("Error {0:d}={1:s} in readBytes.", res, libnodave.daveStrerror(res))
		    end if
		    dc.disconnectPLC()
		else
		    Console.WriteLine("Error {0:d}={1:s} in connectPLC.", res, libnodave.daveStrerror(res))
		end if
		di.disconnectAdapter()	' End connection to adapter
	    else
		Console.WriteLine("Error {0:d}={1:s} in initAdapter.", res, libnodave.daveStrerror(res))
	    end if
	    libnodave.closePort(fds.rfd)	' Clean up
	else
	    Console.WriteLine("Couldn't open serial port {0:s}", args(0))
	    return -1
	end if 'fds.rfd >0
    end Function 'Main
END class