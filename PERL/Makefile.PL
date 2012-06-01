use 5.008004;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Nodave',
    VERSION_FROM      => 'lib/Nodave.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Nodave.pm', # retrieve abstract from module
       AUTHOR         => 'Thomas Hergenhahn <thomas.hergenhahn@web,de>') : ()),
    LIBS              => ['-lnodave'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw(DLE ETX NAK STX SYN _davePtEmpty
		 _davePtMPIAck _davePtReadResponse _davePtUnknownMPIFunc
		 _davePtUnknownPDUFunc _davePtWriteResponse
		 daveAddressOutOfRange daveAnaIn daveAnaOut daveBlockType_DB
		 daveBlockType_FB daveBlockType_FC daveBlockType_OB
		 daveBlockType_SDB daveBlockType_SFB daveBlockType_SFC
		 daveCounter daveCounter200 daveDB daveDI daveDebugAll
		 daveDebugByte daveDebugCompare daveDebugConnect
		 daveDebugErrorReporting daveDebugExchange daveDebugInitAdapter
		 daveDebugListReachables daveDebugMPI daveDebugOpen
		 daveDebugPDU daveDebugPacket daveDebugPassive
		 daveDebugPrintErrors daveDebugRawRead daveDebugRawWrite
		 daveDebugSpecialChars daveDebugUpload daveEmptyResultError
		 daveEmptyResultSetError daveFlags daveFuncDownloadBlock
		 daveFuncDownloadEnded daveFuncEndUpload daveFuncInsertBlock
		 daveFuncOpenS7Connection daveFuncRead daveFuncRequestDownload
		 daveFuncStartUpload daveFuncUpload daveFuncWrite daveInputs
		 daveLocal daveMPIReachable daveMPIunused daveMaxRawLen
		 daveOrderCodeSize daveOutputs daveP davePartnerListSize
		 daveProtoISOTCP daveProtoISOTCP243 daveProtoMPI daveProtoMPI2
		 daveProtoMPI3 daveProtoMPI_IBH daveProtoPPI daveProtoPPI_IBH
		 daveProtoUserTransport daveResCPUNoData
		 daveResCannotEvaluatePDU daveResItemNotAvailable
		 daveResItemNotAvailable200 daveResMultipleBitsNotSupported
		 daveResNoPeripheralAtAddress daveResOK daveResShortPacket
		 daveResTimeout daveResUnexpectedFunc
		 daveResUnknownDataUnitSize daveSpeed1500k daveSpeed187k
		 daveSpeed19k daveSpeed45k daveSpeed500k daveSpeed93k
		 daveSpeed9k daveSysFlags daveSysInfo daveTimer daveTimer200
		 daveUnknownError daveV daveWriteDataSizeMismatch));
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Nodave',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}
