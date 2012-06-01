#
# compile with Freepascal, TP/BP compatibiliy mode.
#
wine c:/pp/bin/win32/fpc -B -So testPPI.pas
wine c:/pp/bin/win32/fpc -B -So testMPI.pas
wine c:/pp/bin/win32/fpc -B -So testISO_TCP.pas
wine c:/pp/bin/win32/fpc -B -So testIBH.pas
wine c:/pp/bin/win32/fpc -B -So testPPI_IBH.pas
