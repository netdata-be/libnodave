#
# Part of Libnodave, a free communication libray for Siemens S7 200/300/400 via
# the MPI adapter 6ES7 972-0CA22-0XAC
# or  MPI adapter 6ES7 972-0CA23-0XAC
# or  TS adapter 6ES7 972-0CA33-0XAC
# or  MPI adapter 6ES7 972-0CA11-0XAC,
# IBH/MHJ-NetLink or CPs 243, 343 and 443
# 
# (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2002..2005
#
# Libnodave is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# Libnodave is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Library General Public License
# along with Libnodave; see the file COPYING.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
#
package Nodave;

use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Nodave ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	DLE
	ETX
	NAK
	STX
	SYN
	_davePtEmpty
	_davePtMPIAck
	_davePtReadResponse
	_davePtUnknownMPIFunc
	_davePtUnknownPDUFunc
	_davePtWriteResponse
	daveAddressOutOfRange
	daveAnaIn
	daveAnaOut
	daveBlockType_DB
	daveBlockType_FB
	daveBlockType_FC
	daveBlockType_OB
	daveBlockType_SDB
	daveBlockType_SFB
	daveBlockType_SFC
	daveCounter
	daveCounter200
	daveDB
	daveDI
	daveDebugAll
	daveDebugByte
	daveDebugCompare
	daveDebugConnect
	daveDebugErrorReporting
	daveDebugExchange
	daveDebugInitAdapter
	daveDebugListReachables
	daveDebugMPI
	daveDebugPDU
	daveDebugPacket
	daveDebugPassive
	daveDebugPrintErrors
	daveDebugRawRead
	daveDebugRawWrite
	daveDebugSpecialChars
	daveDebugUpload
	daveEmptyResultError
	daveEmptyResultSetError
	daveFlags
	daveFuncDownloadBlock
	daveFuncDownloadEnded
	daveFuncEndUpload
	daveFuncInsertBlock
	daveFuncOpenS7Connection
	daveFuncRead
	daveFuncRequestDownload
	daveFuncStartUpload
	daveFuncUpload
	daveFuncWrite
	daveInputs
	daveLocal
	daveMPIReachable
	daveMPIunused
	daveMaxRawLen
	daveOrderCodeSize
	daveOutputs
	daveP
	davePartnerListSize
	daveProtoISOTCP
	daveProtoISOTCP243
	daveProtoMPI
	daveProtoMPI2
	daveProtoMPI3
	daveProtoMPI_IBH
	daveProtoPPI
	daveProtoPPI_IBH
	daveProtoUserTransport
	daveResCPUNoData
	daveResCannotEvaluatePDU
	daveResItemNotAvailable
	daveResItemNotAvailable200
	daveResMultipleBitsNotSupported
	daveResNoPeripheralAtAddress
	daveResOK
	daveResShortPacket
	daveResTimeout
	daveResUnexpectedFunc
	daveResUnknownDataUnitSize
	daveSpeed1500k
	daveSpeed187k
	daveSpeed19k
	daveSpeed45k
	daveSpeed500k
	daveSpeed93k
	daveSpeed9k
	daveSysFlags
	daveSysInfo
	daveTimer
	daveTimer200
	daveUnknownError
	daveV
	daveWriteDataSizeMismatch
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	DLE
	ETX
	NAK
	STX
	SYN
	_davePtEmpty
	_davePtMPIAck
	_davePtReadResponse
	_davePtUnknownMPIFunc
	_davePtUnknownPDUFunc
	_davePtWriteResponse
	daveAddressOutOfRange
	daveAnaIn
	daveAnaOut
	daveBlockType_DB
	daveBlockType_FB
	daveBlockType_FC
	daveBlockType_OB
	daveBlockType_SDB
	daveBlockType_SFB
	daveBlockType_SFC
	daveCounter
	daveCounter200
	daveDB
	daveDI
	daveDebugAll
	daveDebugByte
	daveDebugCompare
	daveDebugConnect
	daveDebugErrorReporting
	daveDebugExchange
	daveDebugInitAdapter
	daveDebugListReachables
	daveDebugMPI
	daveDebugPDU
	daveDebugPacket
	daveDebugPassive
	daveDebugPrintErrors
	daveDebugRawRead
	daveDebugRawWrite
	daveDebugSpecialChars
	daveDebugUpload
	daveEmptyResultError
	daveEmptyResultSetError
	daveFlags
	daveFuncDownloadBlock
	daveFuncDownloadEnded
	daveFuncEndUpload
	daveFuncInsertBlock
	daveFuncOpenS7Connection
	daveFuncRead
	daveFuncRequestDownload
	daveFuncStartUpload
	daveFuncUpload
	daveFuncWrite
	daveInputs
	daveLocal
	daveMPIReachable
	daveMPIunused
	daveMaxRawLen
	daveOrderCodeSize
	daveOutputs
	daveP
	davePartnerListSize
	daveProtoISOTCP
	daveProtoISOTCP243
	daveProtoMPI
	daveProtoMPI2
	daveProtoMPI3
	daveProtoMPI_IBH
	daveProtoPPI
	daveProtoPPI_IBH
	daveProtoUserTransport
	daveResCPUNoData
	daveResCannotEvaluatePDU
	daveResItemNotAvailable
	daveResItemNotAvailable200
	daveResMultipleBitsNotSupported
	daveResNoPeripheralAtAddress
	daveResOK
	daveResShortPacket
	daveResTimeout
	daveResUnexpectedFunc
	daveResUnknownDataUnitSize
	daveSpeed1500k
	daveSpeed187k
	daveSpeed19k
	daveSpeed45k
	daveSpeed500k
	daveSpeed93k
	daveSpeed9k
	daveSysFlags
	daveSysInfo
	daveTimer
	daveTimer200
	daveUnknownError
	daveV
	daveWriteDataSizeMismatch
);

our $VERSION = '0.02';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Nodave::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Nodave', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Nodave - Perl extension for Communication with Siemens PLCs.

=head1 SYNOPSIS

  use Nodave;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Nodave, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.

=head2 Exportable constants

  DLE
  ETX
  NAK
  STX
  SYN
  _davePtEmpty
  _davePtMPIAck
  _davePtReadResponse
  _davePtUnknownMPIFunc
  _davePtUnknownPDUFunc
  _davePtWriteResponse
  daveAddressOutOfRange
  daveAnaIn
  daveAnaOut
  daveBlockType_DB
  daveBlockType_FB
  daveBlockType_FC
  daveBlockType_OB
  daveBlockType_SDB
  daveBlockType_SFB
  daveBlockType_SFC
  daveCounter
  daveCounter200
  daveDB
  daveDI
  daveDebugAll
  daveDebugByte
  daveDebugCompare
  daveDebugConnect
  daveDebugErrorReporting
  daveDebugExchange
  daveDebugInitAdapter
  daveDebugListReachables
  daveDebugMPI
  daveDebugPDU
  daveDebugPacket
  daveDebugPassive
  daveDebugPrintErrors
  daveDebugRawRead
  daveDebugRawWrite
  daveDebugSpecialChars
  daveDebugUpload
  daveEmptyResultError
  daveEmptyResultSetError
  daveFlags
  daveFuncDownloadBlock
  daveFuncDownloadEnded
  daveFuncEndUpload
  daveFuncInsertBlock
  daveFuncOpenS7Connection
  daveFuncRead
  daveFuncRequestDownload
  daveFuncStartUpload
  daveFuncUpload
  daveFuncWrite
  daveInputs
  daveLocal
  daveMPIReachable
  daveMPIunused
  daveMaxRawLen
  daveOrderCodeSize
  daveOutputs
  daveP
  davePartnerListSize
  daveProtoISOTCP
  daveProtoISOTCP243
  daveProtoMPI
  daveProtoMPI2
  daveProtoMPI3
  daveProtoMPI_IBH
  daveProtoPPI
  daveProtoPPI_IBH
  daveProtoUserTransport
  daveResCPUNoData
  daveResCannotEvaluatePDU
  daveResItemNotAvailable
  daveResItemNotAvailable200
  daveResMultipleBitsNotSupported
  daveResNoPeripheralAtAddress
  daveResOK
  daveResShortPacket
  daveResTimeout
  daveResUnexpectedFunc
  daveResUnknownDataUnitSize
  daveSpeed1500k
  daveSpeed187k
  daveSpeed19k
  daveSpeed45k
  daveSpeed500k
  daveSpeed93k
  daveSpeed9k
  daveSysFlags
  daveSysInfo
  daveTimer
  daveTimer200
  daveUnknownError
  daveV
  daveWriteDataSizeMismatch



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Thomas Hergenhahn, E<lt>thomas@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Thomas Hergenhahn

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.


=cut
