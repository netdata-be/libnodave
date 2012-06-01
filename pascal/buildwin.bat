rem
rem Insert your path to freepascal here:
rem
set path=%path%;E:\pp\bin\win32

fpc -B testPPI.pas
fpc -B testMPI.pas
fpc -B testISO_TCP.pas
fpc -B testIBH.pas
fpc -B testPPI_IBH.pas
