(*
 Test and demo program for Libnodave, a free communication libray for Siemens S7.
 
 **********************************************************************
 * WARNING: This and other test programs overwrite data in your PLC.  *
 * DO NOT use it on PLC's when anything is connected to their outputs.*
 * This is alpha software. Use entirely on your own risk.             * 
 **********************************************************************
 
 (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2002, 2003.

 This is free software; you can redistribute it and/or modify
 it under the terms of the GNU Library General Public License as published by
 the Free Software Foundation; either version 2, or (at your option)
 any later version.

 This is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU Library General Public License
 along with Libnodave; see the file COPYING.  If not, write to
 the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*)
uses nodave, tests
{$ifdef WIN32}
, windows
{$endif}
{$ifdef LINUX}
{$ifdef OLDFPC}
,linux
{$lse}
,oldlinux
{$endif}
{$define UNIX_STYLE}
{$endif}
;



{$ifdef CYGWIN}
{$define UNIX_STYLE}
{$endif}


procedure usage;
begin
    writeln('Usage: testPII_IBH [-d] [-w] serial port.');
    writeln('-w will try to write to Flag words. It will overwrite FB0 to FB15 (MB0 to MB15) !');
    writeln('-d will produce a lot of debug messages.');
    writeln('-b will run benchmarks. Specify -b and -w to run write benchmarks.');
    writeln('-m will run a test for multiple variable reads.');
    writeln('-c will write 0 to the PLC memory used in write tests.');
    writeln('-n will test newly added functions.');
    writeln('-s will put the CPU in STOP mode.');
    writeln('-r will put the CPU in RUN mode.');
    writeln('-<number> will set the speed of MPI/PROFIBUS network to this value (in kBaud).\n  Default is 187.\n  Supported values are 9, 19, 45, 93, 187, 500 and 1500.');
    writeln('--mpi=<number> will use number as the PPI adddres of the PLC. Default is 2.');
    writeln('--ppi=<number> will use number as the PPI adddres of the PLC. Default is 2.');
    writeln('Example: testPPI_IBH -w 192.168.19.4');
end;

procedure wait;
begin
    writeln('Press return to continue.');
	readln;
end;



    var i, a,b,c,adrPos, doWrite, doBenchmark, doMultiple, doClear, doNewfunctions,
	doRun,doStop,
	res, saveDebug, plcMPI: longint;
    d: single;
    di:pdaveInterface;
    dc:pdaveConnection;
    rs:daveResultSet;
    fds: _daveOSserialType;
    p:PDU;
    pms: string;
    COMname: array[0..20] of char;
begin

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
	writeln('parameter '+paramstr(adrpos));
	if paramstr(adrPos)='-d' then begin
	    daveSetDebug(daveDebugAll);
            writeln('turning debug on');
	end
	else if paramstr(adrPos)='-w' then begin
	    doWrite:=1;
	end 
	else if copy(paramstr(adrPos),1,6)='--mpi=' then begin
	    val(copy(paramstr(adrPos),7,255),plcMPI,res);
	    writeln('set PLC PPI adress to: ',plcMPI);
	end 
	else if copy(paramstr(adrPos),1,6)='--ppi=' then begin
	    val(copy(paramstr(adrPos),7,255),plcMPI,res);
	    writeln('set PLC PPI adress to: ',plcMPI);
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
    fds.rfd:=openSocket(1099,COMname);
    fds.wfd:=fds.rfd;
    writeln('fds.rfd ',longint(fds.rfd));
    writeln('fds.wfd ',longint(fds.wfd));

    if (fds.rfd>0) then begin

	di :=daveNewInterface(fds, 'IF1',0,daveProtoPPI_IBH, daveSpeed187k);
	if (daveInitAdapter(di)=0) then begin
	dc :=daveNewConnection(di,plcMPI,0,0);  // insert your PPI address here
	if (daveConnectPLC(dc)=0) then begin

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
	    writeln('function result:', res, daveStrerror(res));
(*	    daveDebug:=0;*)
	    res:=daveReadBits(dc, daveDB, 1, 1, 2,nil);
	    writeln('function result:', res, daveStrerror(res));
	    res:=daveReadBits(dc, daveDB, 1, 1, 0,nil);
	    writeln('function result:', res, daveStrerror(res));
	    res:=daveReadBits(dc, daveDB, 1, 1, 1,nil);
	    writeln('function result:', res, daveStrerror(res));

	    a:=0;
	    res:=daveWriteBytes(dc, daveOutputs, 0, 0, 1, @a);
(*	    daveDebug:=daveDebugAll;*)
	    a:=1;
	    res:=daveWriteBits(dc, daveOutputs, 0, 5, 1, @a);
	    writeln('function result:', res,' = ', daveStrerror(res));


	    res:=daveReadBytes(dc, daveAnaOut, 0, 0, 1,nil);
	    writeln('function result:', res, daveStrerror(res));
	    a:=2341;
	    res:=daveWriteBytes(dc, daveAnaOut, 0, 0, 2,@a);
	    writeln('function result:', res, daveStrerror(res));

(*	    daveDebug:=saveDebug;*)
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
	    if (doWrite<>0) then begin
		writeln('Now testing write multiple variables:',
		    'IB0, FW0, QB0, DB6:DBW20 and DB20:DBD24 in a single multiple write.');
		wait;
(*		daveDebug=0xffff;*)
		a:=0;
	        davePrepareWriteRequest(dc, @p);
		daveAddVarToWriteRequest(@p,daveInputs,0,0,1,@a);
		daveAddVarToWriteRequest(@p,daveFlags,0,4,2,@a);
	        daveAddVarToWriteRequest(@p,daveOutputs,0,0,2,@a);
		daveAddVarToWriteRequest(@p,daveDB,6,20,2,@a);
		daveAddVarToWriteRequest(@p,daveDB,20,24,4,@a);
		a:=1;
	    	daveAddBitVarToWriteRequest(@p, daveFlags, 0, 27 { 27 is 3.3 }, 1, @a);
		res:=daveExecWriteRequest(dc, @p, @rs);
		writeln('Result code for the entire multiple write operation: ',res,' = ', daveStrerror(res));

		writeln('Result code for writing IB0:        ',rs.results^[0].error,' = ', daveStrerror(rs.results^[0].error));
		writeln('Result code for writing FW4:        ',rs.results^[1].error,' = ', daveStrerror(rs.results^[1].error));
		writeln('Result code for writing QB0:        ',rs.results^[2].error,' = ', daveStrerror(rs.results^[2].error));
		writeln('Result code for writing DB6:DBW20:  ',rs.results^[3].error,' = ', daveStrerror(rs.results^[3].error));
		writeln('Result code for writing DB20:DBD24: ',rs.results^[4].error,' = ', daveStrerror(rs.results^[4].error));
		writeln('Result code for writing F3.3:       ',rs.results^[5].error,' = ', daveStrerror(rs.results^[5].error));
{*
 *   Read back and show the new values, so users may notice the difference:
 *}	    
	        daveReadBytes(dc,daveFlags,0,0,16, nil);
    		a:=daveGetU32(dc);
	        b:=daveGetU32(dc);
    		c:=daveGetU32(dc);
    		d:=daveGetFloat(dc);
	        writeln('FD0: ',a);
		writeln('FD4: ',b);
		writeln('FD8: ',c);
	        writeln('FD12:',d);		
	    end; { doWrite }
	    end;
	    if(doNewfunctions<>0) then begin
{		saveDebug:=daveDebug;}
{	    daveDebug:=daveDebugPDU; }
	    
		writeln('Trying to read two consecutive bits from DB11.DBX0.1');
		res:=daveReadBits(dc, daveDB, 11, 1, 2, nil);
		writeln('function result:',res,'=',daveStrerror(res));
	    
	        writeln('Trying to read no bit (length 0) from DB17.DBX0.1');
		res:=daveReadBits(dc, daveDB, 17, 1, 0, nil);
		writeln('function result:',res,'=',daveStrerror(res));

{	        daveDebug:=daveDebugPDU;}
		writeln('Trying to read a single bit from DB17.DBX0.3');
		res:=daveReadBits(dc, daveDB, 17, 3, 1, nil);
		writeln('function result:',res,'=', daveStrerror(res));
	
		writeln('Trying to read a single bit from E0.2');
		res:=daveReadBits(dc, daveInputs, 0, 2, 1, nil);
		writeln('function result:',res,'=',daveStrerror(res));
{	    daveDebug:=0;}	
	    
	        a:=0;
		writeln('Writing 0 to EB0');
		res:=daveWriteBytes(dc, daveOutputs, 0, 0, 1, @a);
{	    daveDebug=daveDebugAll; }
	        a:=1;
		writeln('Trying to set single bit E0.5');
	        res:=daveWriteBits(dc, daveOutputs, 0, 5, 1, @a);
		writeln('function result:',res,'=',daveStrerror(res));
	
		writeln('Trying to read 1 byte from AAW0');
		res:=daveReadBytes(dc, daveAnaIn, 0, 0, 2, nil);
		writeln('function result:',res,'=', daveStrerror(res));
	    
	        a:=2341;
		writeln('Trying to write 1 word (2 bytes) to AAW0');
		res:=daveWriteBytes(dc, daveAnaOut, 0, 0, 2,@a);
		writeln('function result:',res,'=', daveStrerror(res));
	
		writeln('Trying to read 4 items from Timers');
		res:=daveReadBytes(dc, daveTimer, 0, 0, 4, nil);
		writeln('function result:',res,'=', daveStrerror(res));
		d:=daveGetSeconds(dc);
		writeln('Time: ',d);
		d:=daveGetSeconds(dc);
		writeln(d);
		d:=daveGetSeconds(dc);
		writeln(d);
		d:=daveGetSeconds(dc);
		writeln(d);
	    
		d:=daveGetSecondsAt(dc,0);
		writeln('Time: ',d);
		d:=daveGetSecondsAt(dc,2);
		writeln(d);
		d:=daveGetSecondsAt(dc,4);
		writeln(d);
		d:=daveGetSecondsAt(dc,6);
		writeln(d);
	    
		writeln('Trying to read 4 items from Counters');
		res:=daveReadBytes(dc, daveCounter, 0, 0, 4, nil);
		writeln('function result:',res,'=', daveStrerror(res));
		c:=daveGetCounterValue(dc);
		writeln('Count: ',c);
		c:=daveGetCounterValue(dc);
		writeln(c);
		c:=daveGetCounterValue(dc);
		writeln(c);
	        c:=daveGetCounterValue(dc);
		writeln(c);
	    
		c:=daveGetCounterValueAt(dc,0);
		writeln('Count: ',c);
		c:=daveGetCounterValueAt(dc,2);
		writeln(c);
		c:=daveGetCounterValueAt(dc,4);
		writeln(c);
		c:=daveGetCounterValueAt(dc,6);
		writeln(c);
	    
		davePrepareReadRequest(dc, @p);
		daveAddVarToReadRequest(@p,daveInputs,0,0,1);
		daveAddVarToReadRequest(@p,daveFlags,0,0,4);
		daveAddVarToReadRequest(@p,daveDB,6,20,2);
	        daveAddVarToReadRequest(@p,daveTimer,0,0,4);
		daveAddVarToReadRequest(@p,daveTimer,0,1,4);
	        daveAddVarToReadRequest(@p,daveTimer,0,2,4);
	        daveAddVarToReadRequest(@p,daveCounter,0,0,4);
		daveAddVarToReadRequest(@p,daveCounter,0,1,4);
	        daveAddVarToReadRequest(@p,daveCounter,0,2,4);
	    
		res:=daveExecReadRequest(dc, @p, @rs);
	    
{	    daveDebug:=saveDebug;}

	end;

	if(doWrite>0) then begin
    	    writeln('Now we write back these data after incrementing the first to by 1,2 and 3 and the first two floats by 1.1.');
    	    wait;
(*
    Attention! you need to swapIed little endian variables before using them as a buffer for
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
	daveDisconnectPLC(dc);
	daveDisconnectAdapter(di);
	halt(0);
	end;
	end;
    end else begin
	writeln('Couldn''t open serial port ',paramstr(adrPos));
	halt(2);
    end;
end.

(*
    Changes:
    04/03/05  created.
    09/11/05  modifications for TP/BP/Delphi and GNU Pascal compatibility.
*)
