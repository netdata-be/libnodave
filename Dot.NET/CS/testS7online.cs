using System;
using System.Runtime.InteropServices;


class test {
    static void wait() {
    }
    
    static void usage() {
    Console.WriteLine("Usage: testS7online [-d] [-w] access point");
    Console.WriteLine("-w will try to write to Flag words. It will overwrite FB0 to FB15 (MB0 to MB15) !");
    Console.WriteLine("-d will produce a lot of debug messages.");
    Console.WriteLine("-b will run benchmarks. Specify -b and -w to run write benchmarks.");
    Console.WriteLine("-z will read some SZL list items (diagnostic information).");
    Console.WriteLine("-2 uses a slightly different version of the MPI protocol. Try it, if your Adapter doesn't work.");
    Console.WriteLine("-m will run a test for multiple variable reads.");
    Console.WriteLine("-c will write 0 to the PLC memory used in write tests.");
    Console.WriteLine("-n will test newly added functions.");
    Console.WriteLine("-a will read out everything from system state lists(SZLs).");
    Console.WriteLine("-s stops the PLC.");
    Console.WriteLine("-r tries to put the PLC in run mode.");
    Console.WriteLine("--readout read program and data blocks from PLC.");
    Console.WriteLine("--readoutall read all program and data blocks from PLC. Includes SFBs and SFCs.");
    Console.WriteLine("-<number> will set the speed of MPI/PROFIBUS network to this value (in kBaud).  Default is 187.  Supported values are 9, 19, 45, 93, 187, 500 and 1500.");
    Console.WriteLine("--mpi=<number> will use number as the MPI adddres of the PLC. Default is 2.");
    Console.WriteLine("--mpi2=<number> Use this option to test simultaneous connections to 2 PLCs."); 
    Console.WriteLine("  It will use number as the MPI adddres of the 2nd PLC. Default is no 2nd PLC.");
    Console.WriteLine("  Most tests are executed with the first PLC. The first read test is also done with");
    Console.WriteLine("  with the 2nd one to demonstrate that this works.");
    Console.WriteLine("--local=<number> will set the local MPI adddres to number. Default is 0.");
    Console.WriteLine("--debug=<number> will set daveDebug to number.");
    Console.WriteLine("Example: testS7online -w /S7ONLINE");
    }

    static int initSuccess=0;
    static int localMPI=0;
    static int plcMPI=2;
    static int plc2MPI=-1;
    static int adrPos=0;	
    static int useProto=libnodave.daveProtoS7online;
    static int speed=libnodave.daveSpeed187k;
    static libnodave.daveOSserialType fds;
    static libnodave.daveInterface di;
    static libnodave.daveConnection dc;
    static bool doWrite=false;
    static bool doClear=false;
    static bool doRun=false;
    static bool doStop=false;
    static bool doWbit=false;
    static int wbit;
    static bool doSZLread=false;
    static bool doSZLreadAll=false;
    static bool doBenchmark=false;
    static bool doReadout=false;
    static bool doSFBandSFC=false;
    static bool doExperimental=false;
    static bool doMultiple=false;
    static bool doNewfunctions=false;
    
    static void readSZL(libnodave.daveConnection dc, int id, int index) {
	int res, SZLid, indx, SZcount, SZlen,i,j,len;
	byte[] ddd=new byte[3000];
        Console.WriteLine(String.Format("Trying to read SZL-ID {0:X04}, index {1:X02}",id,index));
	res=dc.readSZL(id,index, ddd,3000);
        Console.WriteLine("Function result: "+res+" "+libnodave.daveStrerror(res)+" len:"+dc.getAnswLen());
    
        if (dc.getAnswLen()>=4) {
	    len=dc.getAnswLen()-8;
	    SZLid=libnodave.getU16from(ddd,0); 
	    indx=libnodave.getU16from(ddd,2);
	    Console.WriteLine(String.Format("result SZL ID {0:X04}, index {1:X02}",SZLid,indx));
	    int d=8;
	    if (dc.getAnswLen()>=8) {
    		SZlen=libnodave.getU16from(ddd,4);
    		SZcount=libnodave.getU16from(ddd,6);
		Console.WriteLine(" "+SZcount+" elements of "+SZlen+" bytes");
		if(len>0){
		    for (i=0;i<SZcount;i++){
			if(len>0){
			    for (j=0; j<SZlen; j++){
				if(len>0){
				    Console.Write(String.Format("{0:X02},",ddd[d]));
				    d++;
				}
				len--;
			    }
			    Console.WriteLine(" ");
			}
		    }
		}
	    }
	}
	Console.WriteLine(" ");
    }    

    static void readSZLAll(libnodave.daveConnection dc) {
	byte[] d=new byte[1000];
	int res, SZLid, indx, SZcount, SZlen,i,j, rid, rind;
        
	res=dc.readSZL(0,0, d, 1000);
        Console.WriteLine(" "+res+" "+dc.getAnswLen());
	if ((dc.getAnswLen())>=4) {
	    SZLid=dc.getU16();
	    indx=dc.getU16();
	    Console.WriteLine(String.Format("result SZL ID {0:X04} index {1:X02}",SZLid,indx));
	    if ((dc.getAnswLen())>=8) {
    	        SZlen=0x100*d[4]+d[5]; 
	        SZcount=0x100*d[6]+d[7]; 
		Console.WriteLine("%d elements of %d bytes\n",SZcount,SZlen);
		for (i=0;i<SZcount;i++){
		    rid=libnodave.getU16from(d,i*SZlen+8);
		    rind=0;
		    Console.WriteLine(String.Format("\nID:{0:X04} index {1:X02}",rid,rind));
		    readSZL(dc, rid, rind);
		}
	    }
	}
	Console.WriteLine("\n");
    }


    static void rBenchmark(libnodave.daveConnection dc, int bmArea) {
	int i,res,maxReadLen,areaNumber;
	double usec;
	long t1, t2;
	libnodave.resultSet rs=new libnodave.resultSet();
	maxReadLen=dc.getMaxPDULen()-46;
	areaNumber=0; 
	if(bmArea==libnodave.daveDB) areaNumber=1;
    	Console.WriteLine("Now going to do read benchmark with minimum block length of 1.\n");
	t1=Environment.TickCount;
	for (i=1;i<101;i++) {
    	    dc.readBytes(bmArea, areaNumber,0, 1, null);
	    if (i%10==0) {
	        Console.Write("..."+i);
	    }
	}	
	t2=Environment.TickCount;
	usec = 0.001 * (t2 - t1);
        Console.WriteLine(" 100 reads took "+usec+" secs.");
        Console.WriteLine("Now going to do read benchmark with shurely supported block length "+maxReadLen);
	t1=Environment.TickCount;
        for (i=1;i<101;i++) {
	    dc.readBytes(bmArea, areaNumber, 0, maxReadLen, null);
	    if (i%10==0) {
	        Console.Write("..."+i);
	    }
	}	
	t2=Environment.TickCount;
	usec = 0.001 * (t2 - t1);
	Console.WriteLine(" 100 reads took "+usec+" secs. ");
	    
	Console.WriteLine("Now going to do read benchmark with 5 variables in a single request.");
	Console.WriteLine("running...");

	t1=Environment.TickCount;
	
	for (i=1;i<101;i++) {
	    libnodave.PDU p=dc.prepareReadRequest();
	    p.addVarToReadRequest(libnodave.daveInputs,0,0,6);
	    p.addVarToReadRequest(libnodave.daveFlags,0,0,6);
	    p.addVarToReadRequest(libnodave.daveFlags,0,6,6);
	    p.addVarToReadRequest(bmArea,areaNumber,4,54);
	    p.addVarToReadRequest(bmArea,areaNumber,4,4);
	    res=dc.execReadRequest(p, rs);
	    if (res!=0) Console.WriteLine("\nerror "+res+" = "+libnodave.daveStrerror(res));
	    if (i%10==0) {
	        Console.Write("..."+i);		
	    }
	}	
	t2=Environment.TickCount;
	usec = 0.001 * (t2 - t1);
	Console.WriteLine(" 100 reads took "+usec+" secs.");
}

    public static int Main (string[] args)
    {
	int i,a=0,j,res,b=0,c=0;
	float d=0;
	byte[] buf1=new byte[libnodave.davePartnerListSize];

	if (args.Length <1) {
	    usage();
	    return -1;
	}
		
	while (args[adrPos][0]=='-') {
	if (args[adrPos].StartsWith("--debug=")) {
	    libnodave.daveSetDebug(Convert.ToInt32(args[adrPos].Substring(8)));
	    Console.WriteLine("setting debug to: ",Convert.ToInt32(args[adrPos].Substring(8)));
	} else if (args[adrPos].StartsWith("-d")) {
	    libnodave.daveSetDebug(libnodave.daveDebugAll);
	} else if (args[adrPos].StartsWith("-s")) {
	    doStop=true;
	} else if (args[adrPos].StartsWith("-w")) {
	    doWrite=true;
	} else if (args[adrPos].StartsWith("-b")) {
	    doBenchmark=true;
	} else if (args[adrPos].StartsWith("--readoutall")) {
	    doReadout=true;
	    doSFBandSFC=true;
	} else if (args[adrPos].StartsWith("--readout")) {
	    doReadout=true;
	} else if (args[adrPos].StartsWith("-r")) {
	    doRun=true;
	} else if (args[adrPos].StartsWith("-e")) {
	    doExperimental=true;
	} else if (args[adrPos].StartsWith("--local=")) {
	    localMPI=Convert.ToInt32(args[adrPos].Substring(8));
	    Console.WriteLine("setting local MPI address to: "+localMPI);
	} else if (args[adrPos].StartsWith("--mpi=")) {
	    plcMPI=Convert.ToInt32(args[adrPos].Substring(6));
	    Console.WriteLine("setting MPI address of PLC to: "+plcMPI);
	} else if (args[adrPos].StartsWith("--mpi2=")) {
	    plc2MPI=Convert.ToInt32(args[adrPos].Substring(7));
	    Console.WriteLine("setting MPI address of 2md PLC to: "+plc2MPI);
	} else if (args[adrPos].StartsWith("--wbit=")) {
	    wbit=Convert.ToInt32(args[adrPos].Substring(7));
	    Console.WriteLine("setting bit number: "+wbit);
	    doWbit=true;
	} else if (args[adrPos].StartsWith("-z")) {
	    doSZLread=true;
	} else if (args[adrPos].StartsWith("-a")) {
	    doSZLreadAll=true;
	} else if (args[adrPos].StartsWith("-m")) {
	    doMultiple=true;
	} else if (args[adrPos].StartsWith("-c")) {
	    doClear=true;
	} else if (args[adrPos].StartsWith("-n")) {
	    doNewfunctions=true;
	} else if (args[adrPos].StartsWith("-9")) {
 	    speed=libnodave.daveSpeed9k;
 	} else if (args[adrPos].StartsWith("-19")) {
 	    speed=libnodave.daveSpeed19k;
 	} else if (args[adrPos].StartsWith("-45")) {
 	    speed=libnodave.daveSpeed45k;
 	} else if (args[adrPos].StartsWith("-93")) {
 	    speed=libnodave.daveSpeed93k;
 	} else if (args[adrPos].StartsWith("-500")) {
 	    speed=libnodave.daveSpeed500k;
 	} else if (args[adrPos].StartsWith("-1500")) {
 	    speed=libnodave.daveSpeed1500k;
 	} 
 	
	adrPos++;
	if (args.Length<=adrPos) {
	    usage();
	    return -1;
	}	
	}    
	
        fds.rfd=libnodave.openS7online(args[adrPos]);
	fds.wfd=fds.rfd;
        if (fds.rfd>=0) { 
	    di =new libnodave.daveInterface(fds, "IF1", localMPI, useProto, speed);
    	    di.setTimeout(5000000);
            for (i=0; i<3; i++) {
		if (0==di.initAdapter()) {
		    initSuccess=1;	
		    a= di.listReachablePartners(buf1);
		    Console.WriteLine("daveListReachablePartners List length: "+a);
		    if (a>0) {
			for (j=0;j<a;j++) {
			    if (buf1[j]==libnodave.daveMPIReachable) 
				Console.WriteLine("Device at address: "+j);
			}	
		    }
		    break;	
		} else di.disconnectAdapter();
	    }
	    if (initSuccess==0) {
	        Console.WriteLine("Couldn't connect to Adapter!.\n Please try again. You may also try the option -2 for some adapters.");	
	        return -3;
	    }
	    
	    dc = new libnodave.daveConnection(di,plcMPI,0,0);
	    
	    if (0==dc.connectPLC()) {;
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
		
		if(doExperimental) {
		    Console.WriteLine("Trying to read outputs");
		    res=dc.readBytes(libnodave.daveOutputs, 0, 0, 2, null);
		    Console.WriteLine("function result: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    if (res==0) {	
	    		Console.Write("Bytes:");
			for (b=0; b<dc.getAnswLen(); b++) {
			    c=dc.getU8();
			    Console.Write(String.Format(" {0:X0}, ",c));
			}
			Console.WriteLine("");
		    }    
		    a=0x01;
		    Console.WriteLine("Trying to write outputs");
		    res=dc.writeBytes(libnodave.daveOutputs, 0, 0, 1, BitConverter.GetBytes(a));
		    Console.WriteLine("function result: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    libnodave.daveSetDebug(libnodave.daveDebugAll);
		    res=dc.force200(libnodave.daveOutputs,0,0);
		    Console.WriteLine("function result: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    libnodave.daveSetDebug(0);
		    res=dc.force200(libnodave.daveOutputs,0,1);
		    Console.WriteLine("function result of force: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    wait();
	    
		    res=dc.force200(libnodave.daveOutputs,0,2);
		    Console.WriteLine("function result of force: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    wait();
		    res=dc.force200(libnodave.daveOutputs,0,3);
		    Console.WriteLine("function result of force: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    wait();
		    res=dc.force200(libnodave.daveOutputs,1,4);
		    Console.WriteLine("function result of force: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    wait();
		    res=dc.force200(libnodave.daveOutputs,2,5);
		    Console.WriteLine("function result of force: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    wait();
		    res=dc.force200(libnodave.daveOutputs,3,7);
		    Console.WriteLine("function result of force: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    wait();
		    Console.WriteLine("Trying to read outputs again\n");
		    res=dc.readBytes(libnodave.daveOutputs, 0, 0, 4, null);
		    Console.WriteLine("function result: "+res+"="+libnodave.daveStrerror(res)+" "+dc.getAnswLen());
		    if (res==0) {	
	    		Console.Write("Bytes:");
			for (b=0; b<dc.getAnswLen(); b++) {
			    c=dc.getU8();
			    Console.Write(String.Format(" {0:X0}, ",c));
			}
			Console.WriteLine("");
		    }    
		}
    
		    
		if(doWrite) {
    		    Console.WriteLine("Now we write back these data after incrementing the integers by 1,2 and 3 and the float by 1.1.\n");
    		    wait();
/*
    Attention! you need to daveSwapIed little endian variables before using them as a buffer for
    daveWriteBytes() or before copying them into a buffer for daveWriteBytes()!
*/	    
        	    a=libnodave.daveSwapIed_32(a+1);
		    dc.writeBytes(libnodave.daveFlags,0,0,4,BitConverter.GetBytes(a));
    	    	    b=libnodave.daveSwapIed_32(b+2);
		    dc.writeBytes(libnodave.daveFlags,0,4,4,BitConverter.GetBytes(b));
        	    c=libnodave.daveSwapIed_32(c+3);
		    dc.writeBytes(libnodave.daveFlags,0,8,4,BitConverter.GetBytes(c));
    	    	    d=libnodave.toPLCfloat(d+1.1f);
    		    dc.writeBytes(libnodave.daveFlags,0,12,4,BitConverter.GetBytes(d));
/*
 *   Read back and show the new values, so users may notice the difference:
 */	    
        	    dc.readBytes(libnodave.daveFlags,0,0,16, null);
		    a=dc.getU32();
    	    	    b=dc.getU32();
		    c=dc.getU32();
        	    d=dc.getFloat();
		    Console.WriteLine("FD0: "+a);
		    Console.WriteLine("FD4: "+b);
		    Console.WriteLine("FD8: "+c);
		    Console.WriteLine("FD12: "+d);
		} // doWrite
		
		if(doClear) {
	    	    Console.WriteLine("Now writing 0 to the bytes FB0...FB15.\n");
//    		    wait();
		    byte[] aa={0,0,0,0};
    		    dc.writeBytes(libnodave.daveFlags,0,0,4,aa);
        	    dc.writeBytes(libnodave.daveFlags,0,4,4,aa);
		    dc.writeBytes(libnodave.daveFlags,0,8,4,aa);
    		    dc.writeBytes(libnodave.daveFlags,0,12,4,aa);
		    dc.readBytes(libnodave.daveFlags,0,0,16, null);
    		    a=dc.getU32();
	    	    b=dc.getU32();
    		    c=dc.getU32();
	    	    d=dc.getFloat();
		    Console.WriteLine("FD0: "+a);
		    Console.WriteLine("FD4: "+b);
		    Console.WriteLine("FD8: "+c);
		    Console.WriteLine("FD12: "+d);
		} // doClear
    
		if(doSZLread) {
		    readSZL(dc,0x92,0x0);
	    	    readSZL(dc,0xB4,0x1024);
		    readSZL(dc,0x111,0x1);
		    readSZL(dc,0xD91,0x0);
		    readSZL(dc,0x232,0x4);
		    readSZL(dc,0x1A0,0x0);
		    readSZL(dc,0x0A0,0x0);
		}
		
		if(doSZLreadAll) {
		    readSZLAll(dc);
		}
		
		if(doStop) {
		    dc.stop();
		}
		if(doRun) {
		    dc.start();
		}
		if(doBenchmark) {
		    rBenchmark(dc,libnodave.daveFlags);
		}

		
		if(doNewfunctions) {
		    int saveDebug=libnodave.daveGetDebug();
	    
		    Console.WriteLine("Trying to read two consecutive bits from DB11.DBX0.1");;
		    res=dc.readBits(libnodave.daveDB, 11, 1, 2, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
	    
		    Console.WriteLine("Trying to read no bit (length 0) from DB17.DBX0.1");
		    res=dc.readBits(libnodave.daveDB, 17, 1, 0, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));

		    libnodave.daveSetDebug(libnodave.daveGetDebug()|libnodave.daveDebugPDU);	
		    Console.WriteLine("Trying to read a single bit from DB17.DBX0.3\n");
		    res=dc.readBits(libnodave.daveDB, 17, 3, 1, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
	
		    Console.WriteLine("Trying to read a single bit from E0.2\n");
		    res=dc.readBits(libnodave.daveInputs, 0, 2, 1, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
	    
		    a=0;
		    Console.WriteLine("Writing 0 to EB0\n");
		    res=dc.writeBytes(libnodave.daveOutputs, 0, 0, 1, BitConverter.GetBytes(libnodave.daveSwapIed_32(a)));
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));

		    a=1;
		    Console.WriteLine("Trying to set single bit E0.5\n");
		    res=dc.writeBits(libnodave.daveOutputs, 0, 5, 1, BitConverter.GetBytes(libnodave.daveSwapIed_32(a)));
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
	
		    Console.WriteLine("Trying to read 1 byte from AAW0\n");
		    res=dc.readBytes(libnodave.daveAnaIn, 0, 0, 2, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
	    
		    a=2341;
		    Console.WriteLine("Trying to write 1 word (2 bytes) to AAW0\n");
		    res=dc.writeBytes(libnodave.daveAnaOut, 0, 0, 2, BitConverter.GetBytes(libnodave.daveSwapIed_32(a)));
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
	
		    Console.WriteLine("Trying to read 4 items from Timers\n");
		    res=dc.readBytes(libnodave.daveTimer, 0, 0, 4, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
		    if(res==0) {
			d=dc.getSeconds();
			Console.WriteLine("Time: %0.3f, ",d);
		        d=dc.getSeconds();
			Console.WriteLine("%0.3f, ",d);
			d=dc.getSeconds();
			Console.WriteLine("%0.3f, ",d);
			d=dc.getSeconds();
			Console.WriteLine(" %0.3f\n",d);
	    
		        d=dc.getSecondsAt(0);
		        Console.WriteLine("Time: %0.3f, ",d);
		        d=dc.getSecondsAt(2);
			Console.WriteLine("%0.3f, ",d);
		        d=dc.getSecondsAt(4);
		        Console.WriteLine("%0.3f, ",d);
		        d=dc.getSecondsAt(6);
		        Console.WriteLine(" %0.3f\n",d);
		    }
		    
		    Console.WriteLine("Trying to read 4 items from Counters\n");
		    res=dc.readBytes(libnodave.daveCounter, 0, 0, 4, null);
		    Console.WriteLine("function result:" + res+ "="+libnodave.daveStrerror(res));
		    if(res==0) {
		        c=dc.getCounterValue();
		        Console.WriteLine("Count: %d, ",c);
			c=dc.getCounterValue();
		        Console.WriteLine("%d, ",c);
			c=dc.getCounterValue();
			Console.WriteLine("%d, ",c);
			c=dc.getCounterValue();
	    		Console.WriteLine(" %d\n",c);
	    
			c=dc.getCounterValueAt(0);
		        Console.WriteLine("Count: %d, ",c);
		        c=dc.getCounterValueAt(2);
		        Console.WriteLine("%d, ",c);
		        c=dc.getCounterValueAt(4);
		        Console.WriteLine("%d, ",c);
		        c=dc.getCounterValueAt(6);
		        Console.WriteLine(" %d\n",c);
		    }	
	    
		    libnodave.PDU p=dc.prepareReadRequest();
		    p.addVarToReadRequest(libnodave.daveInputs,0,0,1);
		    p.addVarToReadRequest(libnodave.daveFlags,0,0,4);
		    p.addVarToReadRequest(libnodave.daveDB,6,20,2);
		    p.addVarToReadRequest(libnodave.daveTimer,0,0,4);
		    p.addVarToReadRequest(libnodave.daveTimer,0,1,4);
		    p.addVarToReadRequest(libnodave.daveTimer,0,2,4);
		    p.addVarToReadRequest(libnodave.daveCounter,0,0,4);
		    p.addVarToReadRequest(libnodave.daveCounter,0,1,4);
		    p.addVarToReadRequest(libnodave.daveCounter,0,2,4);
		    libnodave.resultSet rs=new libnodave.resultSet();
	    	    res=dc.execReadRequest(p, rs);
		    libnodave.daveSetDebug(saveDebug);
		}
		
//		System.GarbageCollect();
				
		if(doMultiple) {
    		    Console.WriteLine("Now testing read multiple variables.\n"
				    +"This will read 1 Byte from inputs,\n"
				    +"4 bytes from flags, 2 bytes from DB6,\n"
				    +"and other 2 bytes from flags");
    		    wait();
		    libnodave.PDU p=dc.prepareReadRequest();
		    p.addVarToReadRequest(libnodave.daveInputs,0,0,1);
		    p.addVarToReadRequest(libnodave.daveFlags,0,0,4);
		    p.addVarToReadRequest(libnodave.daveDB,6,20,2);
		    p.addVarToReadRequest(libnodave.daveFlags,0,12,2);
		    p.addBitVarToReadRequest(libnodave.daveFlags, 0, 25 /* 25 is 3.1*/, 1);
		    libnodave.resultSet rs=new libnodave.resultSet();
		    res=dc.execReadRequest(p, rs);
	    
		    Console.Write("Input Byte 0: ");
		    res=dc.useResult(rs, 0); // first result
		    if (res==0) {
			a=dc.getU8();
        		Console.WriteLine(a);
		    } else 
			Console.WriteLine("*** Error: "+libnodave.daveStrerror(res));
		
		    Console.Write("Flag DWord 0: ");	
		    res=dc.useResult(rs, 1); // 2nd result
		    if (res==0) {
			a=dc.getS16();
        		Console.WriteLine(a);
		    } else 
			Console.WriteLine("*** Error: "+libnodave.daveStrerror(res));
		
		    Console.Write("DB 6 Word 20: ");	
		    res=dc.useResult(rs, 2); // 3rd result
		    if (res==0) {
			a=dc.getS16();
	        	Console.WriteLine(a);
		    } else 
			Console.WriteLine("*** Error: "+libnodave.daveStrerror(res));
		
		    Console.Write("Flag Word 12: ");		
		    res=dc.useResult(rs, 3); // 4th result
		    if (res==0) {
			a=dc.getU16();
        		Console.WriteLine(a);
	    	    } else 
		    	Console.WriteLine("*** Error: "+libnodave.daveStrerror(res));	
	    
		    Console.Write("Flag F3.1: ");		
		    res=dc.useResult(rs, 4); // 4th result
		    if (res==0) {
			a=dc.getU8();
	        	Console.WriteLine(a);
		    } else 
			Console.WriteLine("*** Error: "+libnodave.daveStrerror(res));		
		
		    Console.Write("non existing result (we read 5 items, but try to use a 6th one): ");
		    res=dc.useResult(rs, 5); // 5th result
		    if (res==0) {
			a=dc.getU16();
        		Console.WriteLine(a);
		    } else 
			Console.WriteLine("*** Error: "+libnodave.daveStrerror(res));		
	    
		    if (doWrite){
			Console.WriteLine("Now testing write multiple variables:\n"
			    +"IB0, FW0, QB0, DB6:DBW20 and DB20:DBD24 in a single multiple write.");
			wait();
//			libnodave.daveSetDebug(0xffff);
			byte[] aa={0};
	        	libnodave.PDU p2=dc.prepareWriteRequest();
			p2.addVarToWriteRequest(libnodave.daveInputs,0,0,1, aa);
			p2.addVarToWriteRequest(libnodave.daveFlags,0,4,2, aa);
	    		p2.addVarToWriteRequest(libnodave.daveOutputs,0,0,2, aa);
			p2.addVarToWriteRequest(libnodave.daveDB,6,20,2, aa);
			p2.addVarToWriteRequest(libnodave.daveDB,20,24,4, aa);
			aa[0]=1;
			p2.addBitVarToWriteRequest(libnodave.daveFlags, 0, 27 /* 27 is 3.3*/, 1, aa);
			rs =new libnodave.resultSet();
			res=dc.execWriteRequest(p2, rs);
			Console.WriteLine("Result code for the entire multiple write operation: "+res+"="+libnodave.daveStrerror(res));
/*
//	I could list the single result codes like this, but I want to tell
//	which item should have been written, so I do it in 5 individual lines:
	
			for (i=0;i<rs.numResults;i++){
			    res=rs.results[i].error;
			    Console.WriteLine("result code from writing item %d: %d=%s\n",i,res,libnodave.libnodave.daveStrerror(res));
			}
*/		
			int err=rs.getErrorOfResult(0);
			Console.WriteLine("Result code for writing IB0:       "+err+"="+libnodave.daveStrerror(err));
			err=rs.getErrorOfResult(1);
			Console.WriteLine("Result code for writing FW4:       "+err+"="+libnodave.daveStrerror(err));
			err=rs.getErrorOfResult(2);
			Console.WriteLine("Result code for writing QB0:       "+err+"="+libnodave.daveStrerror(err));
			err=rs.getErrorOfResult(3);
			Console.WriteLine("Result code for writing DB6:DBW20: "+err+"="+libnodave.daveStrerror(err));
			err=rs.getErrorOfResult(4);
			Console.WriteLine("Result code for writing DB20:DBD24:"+err+"="+libnodave.daveStrerror(err));
			err=rs.getErrorOfResult(5);
			Console.WriteLine("Result code for writing F3.3:      "+err+"="+libnodave.daveStrerror(err));
/*
 *   Read back and show the new values, so users may notice the difference:
 */	    
	    		dc.readBytes(libnodave.daveFlags,0,0,16, null);
    			a=dc.getU32();
	    		b=dc.getU32();
    			c=dc.getU32();
    			d=dc.getFloat();
	    		Console.WriteLine("FD0: %d\n",a);
			Console.WriteLine("FD4: %d\n",b);
			Console.WriteLine("FD8: %d\n",c);
	    		Console.WriteLine("FD12: %f\n",d);		
		    } // doWrite
		}	    

		dc.disconnectPLC();
	    }	    
	    di.disconnectAdapter();
	    libnodave.closeS7online(fds.rfd);
	    GC.Collect();
	    GC.WaitForPendingFinalizers();
	    
	    Console.WriteLine("Here we are");
	} else {
	    Console.WriteLine("Couldn't open s7 online "+args[adrPos]);
	    return -1;
	}	
	return 0;
    }
}
