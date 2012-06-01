unit tests;

interface
uses nodave
{$ifdef WIN32}
, windows
{$endif}
{$ifdef LINUX}
,oldlinux
{$define UNIX_STYLE}
{$endif}
;


procedure readBench(dc:pdaveConnection);
procedure writeBench(dc:pdaveConnection);
procedure wait;

implementation

procedure wait;
begin
    writeln('Press return to continue.');
	readln;
end;

var
{$ifdef UNIX_STYLE}
    t1,t2:timeval;
{$endif}
{$ifdef WIN32}
    t1, t2:longint;
{$endif}
    usec:double;


procedure readBench(dc:pdaveConnection);
var seconds, thirds, res: longint;
    i:integer;
    p:PDU;
begin 
    seconds:=0;thirds:=0;
    writeln('Now going to do read benchmark with minimum block length of 1.');
    wait;
    writeln('running...');
{$ifdef UNIX_STYLE}
    gettimeofday(t1);
{$endif}
{$ifdef WIN32}
    t1:=getTickCount();
{$endif}
    for i:=0 to 99 do begin
	daveReadBytes(dc,daveFlags,0,0,1,nil);
	if (i mod 10)=0 then begin
	    write('...',i);
	    (* fflush(stdout); *)
	end;
    end;
    writeln;
{$ifdef UNIX_STYLE}
    gettimeofday(t2);
    usec := 1e6 * (t2.sec - t1.sec) + t2.usec - t1.usec;
    usec:=usec/1e6;
{$endif}
{$ifdef WIN32 }
    t2:=getTickCount();
    usec := 0.001*(t2 - t1);
{$endif}
        writeln('100 reads ',usec,' seconds. tried repeats: 2nd:',seconds,' 3rds:',thirds);

    seconds:=0;thirds:=0;
    writeln('Now going to do read benchmark with shurely supported block length 16.');
    wait();
    writeln('running...');
{$ifdef UNIX_STYLE}
    gettimeofday(t1);
{$endif}
{$ifdef WIN32}
    t1:=getTickCount();
{$endif}
    for i:=0 to 99 do begin
	daveReadBytes(dc,daveFlags,0,0,16,nil);
	if (i mod 10)=0 then begin
	    write('...',i);
	 {   fflush(stdout);}
	end;
	    end;
	    writeln('');
{$ifdef UNIX_STYLE }
	    gettimeofday(t2);
	    usec := 1e6 * (t2.sec - t1.sec) + t2.usec - t1.usec;
	    usec :=usec/1e6;
{$endif}
{$ifdef WIN32 }
	    t2:=getTickCount();
    usec := 0.001*(t2 - t1);
{$endif}
    writeln('100 reads ',usec,' seconds. tried repeats: 2nd:',seconds,' 3rds:',thirds);

    seconds:=0;thirds:=0;
    writeln('Now going to do read benchmark with 4 variables in a single request.');
    wait;
    writeln('running...');
{$ifdef UNIX_STYLE}
    gettimeofday(t1);
{$endif}
{$ifdef WIN32}
    t1:=getTickCount();
{$endif}
    for i:=0 to 99 do begin
	davePrepareReadRequest(dc, @p);
	daveAddVarToReadRequest(@p,daveInputs,0,0,1);
	daveAddVarToReadRequest(@p,daveFlags,0,0,1);
	daveAddVarToReadRequest(@p,daveFlags,0,10,1);
	daveAddVarToReadRequest(@p,daveFlags,0,20,1);
	res:=daveExecReadRequest(dc, @p, nil);
	if (i mod 10)=0 then begin
	    writeln('...',i);
	    { fflush(stdout); }
	end;
    end;
    writeln('');
{$ifdef UNIX_STYLE}
    gettimeofday(t2);
    usec := 1e6 * (t2.sec - t1.sec) + t2.usec - t1.usec;
    usec :=usec/1e6;
{$endif}
{$ifdef WIN32  }
    t2:=getTickCount();
    usec := 0.001*(t2 - t1);
{$endif}
    writeln('100 reads took %g secs. tried repeats: 2nd:%d 3rd%d',usec,seconds,thirds);

end;

procedure writeBench(dc:pdaveConnection);
var seconds, thirds, res, c: longint;
    i:integer;
    p:PDU;
begin 
    seconds:=0;thirds:=0;
    writeln('Now going to do write benchmark with minimum block length of 1.');
    wait();
    writeln('running...');
{$ifdef UNIX_STYLE }
    gettimeofday(t1);
{$endif}
{$ifdef WIN32 }
    t1:=getTickCount();
{$endif}
    for i:=0 to 99 do begin
        daveWriteBytes(dc,daveFlags,0,0,1,@c);
        if (i mod 10)=0 then begin
	    writeln('...',i);
	    {fflush(stdout); }
	end;
    end;
    writeln('');
{$ifdef UNIX_STYLE  }
    gettimeofday(t2);
    usec := 1e6 * (t2.sec - t1.sec) + t2.usec - t1.usec;
    usec :=usec/1e6;
{$endif}
{$ifdef WIN32 }
    t2:=getTickCount();
    usec := 0.001*(t2 - t1);
{$endif}
    writeln('100 writes took ',usec,' seconds. tried repeats: 2nd:',seconds,' 3rds:',thirds);

    seconds:=0;thirds:=0;
    writeln('Now going to do write benchmark with always supported block length 16.');
    wait;
    writeln('running...');
{$ifdef UNIX_STYLE }
    gettimeofday(t1);
{$endif}
{$ifdef WIN32}
    t1:=getTickCount();
{$endif}
    for i:=0 to 99 do begin
        daveWriteBytes(dc,daveFlags,0,0,16,@c);
        if (i mod 10)=0 then begin
	    writeln('...',i);
	{	fflush(stdout); }
	end;
    end;
    writeln('');
{$ifdef UNIX_STYLE }
    gettimeofday(t2);
    usec := 1e6 * (t2.sec - t1.sec) + t2.usec - t1.usec;
    usec :=usec/1e6;
{$endif}
{$ifdef WIN32 }
    t2:=getTickCount();
    usec := 0.001*(t2 - t1);
{$endif}
    writeln('100 writes took ',usec,' seconds. tried repeats: 2nd:',seconds,' 3rds:',thirds);
    wait;
end;

end.
