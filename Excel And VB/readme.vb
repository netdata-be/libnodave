The file Modul12.bas was created and tested with MS Excel 97, a CPU 315-2DP and an MPI adapter.
I do not include the spreadsheet contents. 
To work with Excel:
- Copy libnodave.dll into your work directory or your system directory.
- Open a blank sheet. 
- Open the VBA editor and import Modul12.bas. 
- Execute Macro initTable. This will put some values into the spreadsheet.
- Adjust these values to your needs.
- If you want to use a communication protocol other than MPI, adjust some lines in sub initialize
  as explained there.
- Now use any of the other macros

The first part of Modull12.bas contains all the declarations to interface with libnodave.dll. Copy
this into your own VB(A) programs.

The first part ends here:
'*****************************************************
' End of interface declarations and helper functions.
'*****************************************************


Have fun!

 