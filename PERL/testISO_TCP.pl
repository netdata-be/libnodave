use Nodave;
use strict;
my ($plcMPI, $localMPI, $ip_address, $rack, $slot, $ip_port, $useProto);
#
# Adjust these variables to your needs:
#
# MPI address for MPI/PPI connections:
#
$plcMPI=2;	# MPI address of PLC
$localMPI=0;	# MPI address of Adapter  (for IBH/MHJ NetLink it MUST be 0)
#
# IP address for TCP connections (CP x43 or NetLink)
#
$ip_address='192.168.0.80';
$rack=0;	# rack the CPU is in (ISO over TCP only)
$slot=2;	# slot the CPU is in (ISO over TCP only, 3 for some S7-400)
#
# IP port for TCP connections (CP x43 or NetLink)
#
$ip_port=102;	# ISO over TCP for S7 CPx43, VIPA Speed 7, SAIA Burgess
#$ip_port=1099;	# MPI/PPI over IBH/MHJ NetLink MPI to Ethernet Gateways
#
# The protocol to be used on your interface:
#
#$useProto=daveProtoMPI;		# MPI with MPI or TS adapter
#$useProto=daveProtoMPI2;	# MPI with MPI (or TS?) adapter. Try if daveProtoMPI does not work.
#$useProto=daveProtoPPI;	# PPI (S7-200) with PPI cable
$useProto=daveProtoISOTCP;	# ISO over TCP for 300/400 family, VIPA Speed 7, SAIA Burgess
#$useProto=daveProtoISOTCP243;	# ISO over TCP for CP 243
#$useProto=daveProtoMPI_IBH;	# IBH/MHJ NetLink MPI to Ethernet Gateways on MPI/Profibus
#$useProto=daveProtoPPI_IBH;	# IBH/MHJ NetLink MPI to Ethernet Gateways on PPI
#
# Shall the library print out debug information?
# Use daveDebugAll and save the output if you want to report problems.
#
# for TCP/IP connections uncomment openSocket, comment out setPort below.
#
print "set debug level\n";
#Nodave::daveSetDebug(Nodave::daveDebugAll);
Nodave::daveSetDebug(0);

$a=Nodave::daveGetDebug();
print "debug level is: $a\n";
my $ph;
#
# open a serial port or a TCP/IP connection:
#
#$ph=Nodave::setPort("/dev/ttyS0","9600",'E');  # for PPI
#$ph=Nodave::setPort("/dev/ttyS0","38400",'O');
$ph=Nodave::openSocket($ip_port, $ip_address);	# for ISO over TCP or MPI or PPI over IBH NetLink
print "port handle: $ph\n";

my ($a, $res, $di, $dc, $i, @partnerBuf, $partnerList, $by, $el, $SZlen, $row, $SZcount);
my ($answLen, $index, $id, $szl, $orderCode, $x, $pdu, $resultSet, $wbuf, @testbuf2, @values);
my ($asd, @abuf2, $aaa, $buf2);

$di=Nodave::daveNewInterface($ph,$ph,"asdf", $localMPI, $useProto, daveSpeed187k);
print "di: $di ok 5\n";

$res=Nodave::daveInitAdapter($di);
print "res: $res ok 6\n";

$dc=Nodave::daveNewConnection($di, $plcMPI ,0, 2);
print "dc: $dc ok 7\n";

$res=Nodave::daveConnectPLC($dc);
print "connect to PLC. function result: $res\n";
#
# Simplest usage of readBytes: result goes into an internal buffer.
#
#Nodave::daveSetDebug(65535);
#
$res=Nodave::daveReadBytes($dc,daveFlags,0,0,16);
print "read from PLC. function result: $res\n";
#
# Now you can read values from the inernal buffer. Buffer read position is auto-incremented
# according to size.
#
$res=Nodave::daveGetU8($dc);
print "res: $res\n";
$res=Nodave::daveGetU8($dc);
print "res: $res\n";
$res=Nodave::daveGetU8($dc);
print "res: $res\n";
$res=Nodave::daveGetU8($dc);
print "res: $res\n";
$res=Nodave::daveGetU16($dc);
print "res: $res\n";
$res=Nodave::daveGetU16($dc);
print "res: $res\n";
$res=Nodave::daveGetU32($dc);
print "res: $res\n";
$res=Nodave::daveGetFloat($dc);
print "res: $res ok 10.0\n";
#
# List usage of readBytes: result goes into an internal buffer, but you also get a scalar value
# that contains the result bytes as a string:
#
($buf2,$res)=Nodave::daveReadBytes($dc,daveInputs,0,0,4); # valid, may be called with or without a buffer
#
# Unpacking and showing the result string:
#
@abuf2=unpack("C*",$buf2);
#
print "res: $res ok 9\n";
for ($i=0; $i<@abuf2; $i++) {
    printf "position %d = %d \n", $i,$abuf2[$i];
}

printf("Trying to read a bit from I0.2\n");
#
#Nodave::daveSetDebug(65535);
#
($aaa,$res)=Nodave::daveReadBits($dc, daveInputs, 0, 2);
@abuf2=unpack("C*",$aaa);
print "res: $res ok 9\n";
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));
if ($res==0) {	
for ($i=0; $i<@abuf2; $i++) {
    printf "position %d = %d \n", $i,$abuf2[$i];
}
}

if ($res==0) {	
    print $dc,"\n";
    $asd=Nodave::daveGetU8($dc);
    printf("Bit: %d\n",$asd);
}	


printf("Trying to stop the PLC\n");
$res=Nodave::daveStop($dc);
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));

printf("Trying to start the PLC\n");
$res=Nodave::daveStart($dc);
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));


printf("Testing write to PLC\n");
@values=(1,2,3,4.55);

for ($i=0; $i<4; $i++) {
    print "value: ",$i," = ",$values[$i], "\n";
}

$wbuf=pack("L*",@values);

@testbuf2=unpack("C*",$wbuf);

for ($i=0; $i<@testbuf2; $i++) {
    printf "position %d = %d \n", $i,$testbuf2[$i];
}

for ($i=0; $i<4; $i++) {
    print "value: ",$i," = ",$values[$i], "\n";
}


$values[0]=Nodave::daveSwapIed_32($values[0]);
$values[1]=Nodave::daveSwapIed_32($values[1]);
$values[2]=Nodave::daveSwapIed_32($values[2]);
$values[3]=Nodave::daveToPLCfloat($values[3]);

for ($i=0; $i<4; $i++) {
    print "value: ",$i," = ",$values[$i], "\n";
}

$wbuf=pack("L*",@values);

@testbuf2=unpack("C*",$wbuf);

for ($i=0; $i<@testbuf2; $i++) {
    printf "position %d = %d \n", $i,$testbuf2[$i];
}

$res=Nodave::daveWriteBytes($dc,daveFlags,0,0,16, $wbuf);
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));

$pdu=Nodave::daveNewPDU;
$resultSet=Nodave::daveNewResultSet;

printf("Testing multiple item read\n");
#Nodave::daveAddVarToReadRequest($dc,daveInputs,0,0,4); 
Nodave::davePrepareReadRequest($dc,$pdu); 
Nodave::daveAddVarToReadRequest($pdu,daveInputs,0,0,4); 
Nodave::daveAddVarToReadRequest($pdu,daveFlags,0,0,16); 
Nodave::daveAddVarToReadRequest($pdu,daveFlags,0,10,16); 
$res=Nodave::daveExecReadRequest($dc,$pdu,$resultSet); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));
$res=Nodave::daveUseResult($dc,$resultSet,1); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));

$res=Nodave::daveGetU8($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetU8($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetU8($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetU8($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetU16($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetU16($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetU32($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetFloat($dc);
print "res: $res ok 10.0\n";
$res=Nodave::daveGetFloatAt($dc,12);
print "daveGetFloatAt res: $res ok 10.0\n";




$res=Nodave::daveUseResult($dc,$resultSet,2); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));

$res=Nodave::daveFreeResults($resultSet); 
$res=Nodave::daveExecReadRequest($dc,$pdu,$resultSet); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));
$res=Nodave::daveUseResult($dc,$resultSet,1); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));



$res=Nodave::daveExecReadRequest($dc,$pdu,$resultSet); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));
$res=Nodave::daveUseResult($dc,$resultSet,1); 
printf("function result:%d=%s\n", $res, Nodave::daveStrerror($res));

Nodave::daveDump("Hello World ","asdf",4);
Nodave::daveDumpPDU($pdu);

$x = Nodave::daveSwapIed_16(42);
print $x," ",42*256,"\n";
$x = Nodave::daveSwapIed_16($x);
print $x,"\n";

($orderCode,$res)=Nodave::daveGetOrderCode($dc); 
print "orderCode: $orderCode \n";

($szl,$res)=Nodave::daveReadSZL($dc,0xA0,0); 
$answLen=Nodave::daveGetAnswLen($dc);
print "SZL: $szl  answLen: $answLen \n";
if ($answLen>4) {
    $id=Nodave::daveGetU16($dc);
    $index=Nodave::daveGetU16($dc);
    print "ID: $id  index: $index\n";
    if ($answLen>=8) {
	$SZlen=Nodave::daveGetU16($dc);
	$SZcount=Nodave::daveGetU16($dc);
        print "$SZcount elements of $SZlen bytes\n";
	for ($row=0;$row<$SZcount;$row++) {
	    for ($el=0;$el<$SZlen;$el++) {
		$by=Nodave::daveGetU8($dc);
		printf "%02x",$by;
	    }
	    print "\n";
	}
    }
}

Nodave::daveSetTimeout($di,2000000); 

($partnerList,$res)=Nodave::daveListReachablePartners($di); 
print "res: $res\n";
if ($res==davePartnerListSize) {
    @partnerBuf=unpack("C126",$partnerList);
    for ($i=0;$i<davePartnerListSize;$i++) {
#	printf "%02x\n",$partnerBuf[$i];
	if ($partnerBuf[$i]==0x30) {printf "device at $i\n";}
    }
}
$res=Nodave::daveDisconnectPLC($dc);
$res=Nodave::daveDisconnectAdapter($di);
$res=Nodave::closeSocket($ph);
