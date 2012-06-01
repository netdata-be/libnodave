(*
 Test and demo program for Libnodave, a free communication libray for Siemens S7.
 
 **********************************************************************
 * WARNING: This and other test programs overwrite data in your PLC.  *
 * DO NOT use it on PLC's when anything is connected to their outputs.*
 * This is alpha software. Use entirely on your own risk.             * 
 **********************************************************************
 
 (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2002, 2003.

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
*)
uses nodave, tests
{$ifdef WIN32}
, windows
{$endif}
{$ifdef LINUX}
,oldlinux
{$define UNIX_STYLE}
{$endif}
;



{$ifdef CYGWIN}
{$define UNIX_STYLE}
{$endif}


procedure usage;
begin
    writeln('Usage: testPPI [-d] [-w] serial port.');
    writeln('-w will try to write to Flag words. It will overwrite FB0 to FB15 (MB0 to MB15) !');
    writeln('-d will produce a lot of debug messages.');
    writeln('-b will run benchmarks. Specify -b and -w to run write benchmarks.');
    writeln('-m will run a test for multiple variable reads.');
    writeln('-c will write 0 to the PLC memory used in write tests.');
    writeln('-s will put the CPU in STOP mode.');
    writeln('-r will put the CPU in RUN mode.');
    writeln('--mpi=<number> will use number as the PPI adddres of the PLC. Default is 2.');
    writeln('--ppi=<number> will use number as the PPI adddres of the PLC. Default is 2.');
    writeln('--local=<number> will set the local PPI adddres to number. Default is 0.');
{$ifdef UNIX_STYLE}    
    writeln('Example: testPPI -w /dev/ttyS0');
{$endif}    
{$ifdef WIN32}
    writeln('Example: testPPI -w COM1');
{$endif}
end;


    var i, a,b,c,adrPos, doWrite, doBenchmark, doMultiple, doClear, doNewfunctions,
	doRun,doStop,
	res, saveDebug, plcMPI, localmpi: longint;
    d: single;
    di:pdaveInterface;
    dc:pdaveConnection;
    rs:daveResultSet;
    fds: _daveOSserialType;
{$ifdef UNIX_STYLE}
    t1,t2:timeval;
{$endif}
{$ifdef WIN32}
    t1, t2:longint;
{$endif}
    usec:double;
    p:PDU;
    pms:string;
    COMname: array[0..20] of char;
begin
USEC:=0;
    adrPos:=1;
    doWrite:=0;
    doBenchmark:=0;
    doMultiple:=0;
    doClear:=0;
    doNewfunctions:=0;
    doRun:=0;
    doStop:=0;
    plcMPI:=2;

    if (paramcount<1) then begin
	usage;
	halt(1);
    end;

    while (paramstr(adrPos)[1]='-') do begin
	if paramstr(adrPos)='-d' then begin
(*    daveDebug:=daveDebugAll; *)
		daveSetDebug(daveDebugAll);
            writeln('turning debug on');
	end
	else if copy(paramstr(adrPos),1,6)='--mpi=' then begin
	    val(copy(paramstr(adrPos),7,255),plcMPI,res);
	    writeln('set PLC PPI adress to: ',plcMPI);
	end 
	else if copy(paramstr(adrPos),1,6)='--ppi=' then begin
	    val(copy(paramstr(adrPos),7,255),plcMPI,res);
	    writeln('set PLC PPI adress to: ',plcMPI);
	end 
	else if copy(paramstr(adrPos),1,8)='--local=' then begin
	    val(copy(paramstr(adrPos),9,255),localMPI,res);
	    writeln('setting local MPI adress to: ',localMPI);
	end 
	else if paramstr(adrPos)='-w' then begin
	    doWrite:=1;
	end 
	else if paramstr(adrPos)='-b' then begin
	    doBenchmark:=1;
	end
	else if paramstr(adrPos)='-m' then begin
	    doMultiple:=1;
	end
	else if paramstr(adrPos)='-c' then begin
	    doClear:=1;
	end
	else if paramstr(adrPos)='-n' then begin
	    doNewfunctions:=1;
	end
	else if paramstr(adrPos)='-r' then begin
	    doRun:=1;
	end
	else if paramstr(adrPos)='-s' then begin
	    doStop:=1;
	end;

	adrPos:=adrPos+1;
	if (paramcount<adrPos) then begin
	    usage;
	    halt(1);
	end;
    end;
    writeln('fds',sizeof(fds));
    pms:=paramstr(adrPos);
    move(pms[1], COMname,length(paramstr(adrPos)));
    COMname[length(paramstr(adrPos))+1]:=#0;
    fds.rfd:=setPort(COMname,'9600','E');
    fds.wfd:=fds.rfd;
    writeln('fds.rfd ',longint(fds.rfd));
    writeln('fds.wfd ',longint(fds.wfd));

    if (fds.rfd>0) then begin

	di :=daveNewInterface(fds, 'IF1',localmpi, daveProtoPPI, daveSpeed187k);
	dc :=daveNewConnection(di,plcMPI,0,0);  // insert your PPI address here

(*
// just try out what else might be readable in an S7-200 (on your own risk!):
*)
	writeln('Trying to read 64 bytes (32 words) from data block 1. This is V memory of the 200.');
	wait;
        res:=daveReadBytes(dc,daveDB,1,0,64,nil);
	if (res=0) then begin
	    a:=daveGetU16(dc);
	    writeln('VW0: ',a);
	    a:=daveGetU16(dc);
	    writeln('VW2: ',a);
	end;
(*	a:=daveGetU16at(dc,62);
	writeln('DB1:DW32: %d',a);
*)
	writeln('Trying to read 16 bytes from FW0.');
	wait;
(*
 * Some comments about daveReadBytes():
 *
 * The 200 family PLCs have the V area. This is accessed like a datablock with number 1.
 * This is not a quirk or convention introduced by libnodave, but the command transmitted
 * to the PLC is exactly the same that would read from DB1 of a 300 or 400.
 *
 * to read VD68 and VD72 use:
 * 	daveReadBytes(dc, daveDB, 1, 68, 6, nil);
 * to read VD68 and VD72 into your applications buffer appBuffer use:
 * 	daveReadBytes(dc, daveDB, 1, 68, 6, appBuffer);
 * to read VD68 and VD78 into your applications buffer appBuffer use:
 * 	daveReadBytes(dc, daveDB, 1, 68, 14, appBuffer);
 * this reads DBD68 and DBD78 and everything in between and fills the range
 * appBuffer+4 to appBuffer+9 with unwanted bytes, but is much faster than:
 *	daveReadBytes(dc, daveDB, 1, 68, 4, appBuffer);
 *	daveReadBytes(dc, daveDB, 1, 78, 4, appBuffer+4);
 *)
	res:=daveReadBytes(dc,daveFlags,0,0,16,nil);
	if (res=0) then begin
(*
 *	daveGetU32(dc); reads a word (2 bytes) from the current buffer position and increments
 *	an internal pointer by 2, so next daveGetXXX() wil read from the new position behind that
 *	word.
 *)
    	    a:=daveGetU32(dc);
            b:=daveGetU32(dc);
	    c:=daveGetU32(dc);
    	    d:=daveGetFloat(dc);
	    writeln('FD0: ',a);
	    writeln('FD4: ',b);
	    writeln('FD8: ',c);
	    writeln('FD12:',d);
(*
	    d:=daveGetFloatAt(dc,12);
	    writeln('FD12:',d);
*)
	end;

	if(doNewfunctions<>0) then begin
(*
//	    saveDebug:=daveDebug;
//	    daveDebug:=daveDebugAll;
*)
	    res:=daveReadBits(dc, daveInputs, 0, 2, 1,nil);
	    writeln('function result:%d:=%s', res, daveStrerror(res));
//	    daveDebug:=0;
	    res:=daveReadBits(dc, daveDB, 1, 1, 2,nil);
	    writeln('function result:%d:=%s', res, daveStrerror(res));
	    res:=daveReadBits(dc, daveDB, 1, 1, 0,nil);
	    writeln('function result:%d:=%s', res, daveStrerror(res));
	    res:=daveReadBits(dc, daveDB, 1, 1, 1,nil);
	    writeln('function result:%d:=%s', res, daveStrerror(res));

	    a:=0;
	    res:=daveWriteBytes(dc, daveOutputs, 0, 0, 1, @a);
//	    daveDebug:=daveDebugAll;
	    a:=1;
	    res:=daveWriteBits(dc, daveOutputs, 0, 5, 1, @a);
	    writeln('function result:', res,' = ', daveStrerror(res));


	    res:=daveReadBytes(dc, daveAnaOut, 0, 0, 1,nil);
	    writeln('function result:%d:=%s', res, daveStrerror(res));
	    a:=2341;
	    res:=daveWriteBytes(dc, daveAnaOut, 0, 0, 2,@a);
	    writeln('function result:%d:=%s', res, daveStrerror(res));

//	    daveDebug:=saveDebug;
	end;
	if doRun<>0 then begin
	    daveStart(dc);
	end;
	if doStop<>0 then begin
	    daveStop(dc);
	end;	

	if(doMultiple<>0) then begin
    	    writeln('Now testing read multiple variables.''This will read 1 Byte from inputs,''4 bytes from flags, 2 bytes from DB6'' and other 2 bytes from flags');
    	    wait;
	    davePrepareReadRequest(dc, @p);
	    daveAddVarToReadRequest(@p,daveInputs,0,0,1);
	    daveAddVarToReadRequest(@p,daveFlags,0,0,4);
	    daveAddVarToReadRequest(@p,daveDB,6,20,2);
	    daveAddVarToReadRequest(@p,daveSysInfo,0,0,24);
	    daveAddVarToReadRequest(@p,daveFlags,0,12,2);
	    daveAddVarToReadRequest(@p,daveAnaIn,0,0,2);
	    daveAddVarToReadRequest(@p,daveAnaOut,0,0,2);
	    res:=daveExecReadRequest(dc, @p, @rs);

	    write('Input Byte 0: ');
	    res:=daveUseResult(dc, @rs, 0); // first result
	    if (res=0) then begin
		a:=daveGetU8(dc);
        	writeln(a);
	    end else
		writeln('*** Error: ',daveStrerror(res));

	    write('Flag DWord 0: ');
	    res:=daveUseResult(dc, @rs, 1); // 2nd result
	    if (res=0) then begin
		a:=daveGetS16(dc);
        	writeln(a);
	    end else
		writeln('*** Error: ',daveStrerror(res));

	    write('DB 6 Word 20 (not present in 200): ');
	    res:=daveUseResult(dc, @rs, 2); // 3rd result
	    if (res=0) then begin
		a:=daveGetS16(dc);
        	writeln(a);
	    end else
		writeln('*** Error: ',daveStrerror(res));

	    write('System Information: ');
	    res:=daveUseResult(dc, @rs, 3); // 4th result
	    if (res=0) then begin
		for i:=0 to 39 do begin
		a:=daveGetU8(dc);
        	write(char(a));
		end;
        	writeln('');
	    end else
		writeln('*** Error: ',daveStrerror(res));

	    write('Flag Word 12: ');
	    res:=daveUseResult(dc, @rs, 4); // 5th result
	    if (res=0)then begin
		a:=daveGetU16(dc);
        	writeln(a);
	    end else
		writeln('*** Error: ',daveStrerror(res));

	    write('non existing result (we try to use 1 more than the number of items): ');
	    res:=daveUseResult(dc, @rs, 4); // 5th result
	    if (res=0)then begin
		a:=daveGetU16(dc);
        	writeln(a);
	    end else
		writeln('*** Error: %s',daveStrerror(res));

	    write('Analog Input Word 0:');
	    res:=daveUseResult(dc, @rs, 5); // 6th result
	    if (res=0)then begin
		a:=daveGetU16(dc);
        	writeln(a);
	    end else
		writeln('*** Error: ',daveStrerror(res));

	    write('Analog Output Word 0:');
	    res:=daveUseResult(dc, @rs, 6); // 7th result
	    if (res=0)then begin
		a:=daveGetU16(dc);
        	writeln(a);
	    end else
		writeln('*** Error: ',daveStrerror(res));
	    daveFreeResults(@rs);
(*
	    for (i:=0; i<rs.numResults;i++) begin
		r2:=@(rs.results[i]);
		writeln('result: %s length:%d',daveStrerror(r2->error), r2->length);
		res:=daveUseResult(dc, @rs, i);
		if (r2->length>0) _daveDump('bytes',r2->bytes,r2->length);
		if (r2->bytes!:=nil) begin
	    	    _daveDump('bytes',r2->bytes,r2->length);
	            d:=daveGetFloat(dc);
	            writeln('FD12: %f',d);
		end
	    end
*)
	end;

	if(doWrite>0) then begin
    	    writeln('Now we write back these data after incrementing the first to by 1,2 and 3 and the first two floats by 1.1.');
    	    wait;
(*
    Attention! you need to daveSwapIed little endian variables before using them as a buffer for
    daveWriteBytes() or before copying them into a buffer for daveWriteBytes()!
*)
    	    a:=daveSwapIed_32(a+1);
    	    daveWriteBytes(dc,daveFlags,0,0,4,@a);
    	    b:=daveSwapIed_32(b+2);
    	    daveWriteBytes(dc,daveFlags,0,4,4,@b);
    	    c:=daveSwapIed_32(c+3);
	    daveWriteBytes(dc,daveFlags,0,8,4,@c);
    	    d:=toPLCfloat(d+1.1);
    	    daveWriteBytes(dc,daveFlags,0,12,4,@d);
    	    daveReadBytes(dc,daveFlags,0,0,16,nil);
    	    a:=daveGetU32(dc);
    	    b:=daveGetU32(dc);
    	    c:=daveGetU32(dc);
    	    d:=daveGetFloat(dc);
	    writeln('FD0: ',a);
	    writeln('FD4: ',b);
	    writeln('FD8: ',c);
	    writeln('FD12:',d);
	end; {doWrite}
	if(doClear>0) then begin
    	    writeln('Now writing 0 to the bytes FB0...FB15.');
    	    wait();
	    a:=0;
    	    daveWriteBytes(dc,daveFlags,0,0,4,@a);
    	    daveWriteBytes(dc,daveFlags,0,4,4,@a);
	    daveWriteBytes(dc,daveFlags,0,8,4,@a);
    	    daveWriteBytes(dc,daveFlags,0,12,4,@a);
	    daveReadBytes(dc,daveFlags,0,0,16,nil);
    	    a:=daveGetU32(dc);
    	    b:=daveGetU32(dc);
    	    c:=daveGetU32(dc);
    	    d:=daveGetFloat(dc);
	    writeln('FD0: %d',a);
	    writeln('FD4: %d',b);
	    writeln('FD8: %d',c);
	    writeln('FD12: %f',d);
	end; { doClear}

  	if(doBenchmark>0) then begin
	    readBench(dc);
	    if(doWrite>0)then begin
		writeBench(dc);
	    end; {// doWrite}
	end; { // doBenchmark}

	halt(0);
    end else begin
	writeln('Couldn''t open serial port ',paramstr(adrPos));
	halt(2);
    end;
end.

(*
    Changes:
    07/19/04 added return values in main().
    09/09/04 applied patch for variable Profibus speed from Andrew Rostovtsew.
    09/09/04 removed unused include byteswap.h
    09/10/04 removed SZL read, it doesn?t work on 200 family.
    09/11/04 added multiple variable read example code.
*)
