# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Nodave.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN { use_ok('Nodave') };


my $fail = 0;
foreach my $constname (qw(
	DECL2 DLE ETX EXPORTSPEC NAK STX SYN _davePtEmpty _davePtMPIAck
	_davePtReadResponse _davePtUnknownMPIFunc _davePtUnknownPDUFunc
	_davePtWriteResponse daveAddressOutOfRange daveAnaIn daveAnaOut
	daveBlockType_DB daveBlockType_FB daveBlockType_FC daveBlockType_OB
	daveBlockType_SDB daveBlockType_SFB daveBlockType_SFC daveCounter
	daveCounter200 daveDB daveDI daveDebugAll daveDebugByte
	daveDebugCompare daveDebugConnect daveDebugErrorReporting
	daveDebugExchange daveDebugInitAdapter daveDebugListReachables
	daveDebugMPI daveDebugOpen daveDebugPDU daveDebugPacket
	daveDebugPassive daveDebugPrintErrors daveDebugRawRead
	daveDebugRawWrite daveDebugSpecialChars daveDebugUpload
	daveEmptyResultError daveEmptyResultSetError daveFlags
	daveFuncDownloadBlock daveFuncDownloadEnded daveFuncEndUpload
	daveFuncInsertBlock daveFuncOpenS7Connection daveFuncRead
	daveFuncRequestDownload daveFuncStartUpload daveFuncUpload
	daveFuncWrite daveInputs daveLocal daveMPIReachable daveMPIunused
	daveMaxRawLen daveOrderCodeSize daveOutputs daveP davePartnerListSize
	daveProtoISOTCP daveProtoISOTCP243 daveProtoMPI daveProtoMPI2
	daveProtoMPI3 daveProtoMPI_IBH daveProtoPPI daveProtoPPI_IBH
	daveProtoUserTransport daveResCPUNoData daveResCannotEvaluatePDU
	daveResItemNotAvailable daveResItemNotAvailable200
	daveResMultipleBitsNotSupported daveResNoPeripheralAtAddress daveResOK
	daveResShortPacket daveResTimeout daveResUnexpectedFunc
	daveResUnknownDataUnitSize daveSpeed1500k daveSpeed187k daveSpeed19k
	daveSpeed45k daveSpeed500k daveSpeed93k daveSpeed9k daveSysFlags
	daveSysInfo daveTimer daveTimer200 daveUnknownError daveV
	daveWriteDataSizeMismatch)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Nodave macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

#Nodave::daveSetDebug(1234);
#print "here\n";
#if (Nodave::daveGetDebug()==1234) {
#    print "# pass: $@";
#  } else {
#    print "# fail: $@";
#    $fail = 1;
# }
#ok( $fail == 0 , 'Set Debug' );
