#PBFORMS CREATED V1.51
'--------------------------------------------------------------------------------
' Dave.bas     4/08/06
' Test of LibNoDave Step7 MPI communication with PBWin 8.01
' credit for all the great code goes to:
' (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2005 '
'
' PBWin version writen by Bob Clarke RT Engineering Larvik Norway (rtc@rte.no)
' some variable and function names have been changed to avoid conflicts with PBW keywords
' all the errors in the translation are surely mine.
'--------------------------------------------------------------------------------

#COMPILE EXE            ' make an exe file
#DIM ALL                ' check all variables and parameters
#COMPILER PBWIN 8.01    ' version used for test
                        ' PBForms 1.51

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
#RESOURCE "Dave.pbr"
#IF NOT %DEF(%WINAPI)
    #INCLUDE "WIN32API.INC"
#ENDIF
#PBFORMS END INCLUDES
#IF NOT %DEF(%DAVE_INC)
    #INCLUDE "DAVE.INC"
#ENDIF

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDC_QUIT     =    2
%IDB_READ     =  501
%IDB_ADD      =  502
%IDB_Write    =  503
%IDC_Status   =  601
%IDC_TEXTBOX1 =  701
%IDC_TEXTBOX2 =  702
%IDC_TEXTBOX3 =  703
%IDC_TEXTBOX4 =  704
%IDD_DIALOG1  = 1001
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------
'   ** GLOBALS **
'--------------------------------------------------------------------------------
GLOBAL sDato    AS STRING           ' PC date
GLOBAL sTid     AS STRING           ' PC time
GLOBAL gMhDlg   AS LONG             ' window handle

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION MainCallBackProc()
DECLARE FUNCTION ShowMainDialog(BYVAL hParent AS DWORD) AS LONG
DECLARE FUNCTION Init1() AS LONG
DECLARE FUNCTION Init2() AS LONG
DECLARE FUNCTION Initialize(BYREF ph AS LONG, BYREF di AS LONG, BYREF DC AS LONG) AS LONG
DECLARE SUB GameOver(BYREF ph AS LONG, BYREF di AS LONG, BYREF DC AS LONG)
DECLARE SUB ReadScreen()
DECLARE SUB WriteScreen()
DECLARE SUB ReadFromPLC()
DECLARE SUB addvalue()
DECLARE SUB writeToPLC()

#PBFORMS DECLARATIONS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()
    DIM lRslt   AS LOCAL LONG

    Init1()
    ShowMainDialog %HWND_DESKTOP
    Init2()
    DIALOG SHOW MODAL gMhDlg, CALL MainCallBackProc TO lRslt

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION Init1() AS LONG
' before show dialog

    DIM localMPI        AS GLOBAL INTEGER
    DIM plcMPI          AS GLOBAL INTEGER
    DIM Rack            AS GLOBAL INTEGER
    DIM Slot            AS GLOBAL INTEGER

    DIM ph              AS GLOBAL LONG      ' port handle
    DIM di              AS GLOBAL LONG      ' dave interface handle
    DIM DC              AS GLOBAL LONG      ' dave connection handle

    DIM sBaud           AS GLOBAL STRING
    DIM sPort           AS GLOBAL STRING
    DIM sParity         AS GLOBAL STRING
    DIM sPeer           AS GLOBAL STRING
    DIM sAcspnt         AS GLOBAL STRING

    DIM sT              AS GLOBAL STRING
    DIM ok              AS GLOBAL LONG
    DIM v1              AS GLOBAL LONG
    DIM v2              AS GLOBAL LONG
    DIM v3              AS GLOBAL LONG
    DIM v4              AS GLOBAL SINGLE
    DIM v5              AS GLOBAL SINGLE

    localMPI     = 0
    plcMPI       = 2
    sPort        = "COM1"
    sBaud        = "38400"
    sParity      = "O"
    sPeer        = "192.168.1.1"
    sAcspnt      = "/S7ONLINE"

    FUNCTION = 0
END FUNCTION 'Init1
'-----------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION MainCallBackProc()

    SELECT CASE AS LONG CBMSG
        CASE %WM_INITDIALOG
            ' Initialization handler
        CASE %WM_NCACTIVATE
            STATIC hWndSaveFocus AS DWORD
            IF ISFALSE CBWPARAM THEN
                ' Save control focus
                hWndSaveFocus = GetFocus()
            ELSEIF hWndSaveFocus THEN
                ' Restore control focus
                SetFocus(hWndSaveFocus)
                hWndSaveFocus = 0
            END IF
        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CBCTL
                CASE %IDC_TEXTBOX1  ' MD0 field
                    IF CBCTLMSG = %EN_KILLFOCUS  THEN
                        SELECT CASE CBCTL
                            CASE %IDC_TEXTBOX1
                                ' read display
                        END SELECT 'CBCTL
                     END IF 'CBCTLMSG = %EN_KILLFOCUS
                CASE %IDC_TEXTBOX2  ' MD4 field
                    IF CBCTLMSG = %EN_KILLFOCUS  THEN
                        SELECT CASE CBCTL
                            CASE %IDC_TEXTBOX2
                                ' read display
                        END SELECT 'CBCTL
                     END IF 'CBCTLMSG = %EN_KILLFOCUS
                CASE %IDC_TEXTBOX3  ' MD8 field
                    IF CBCTLMSG = %EN_KILLFOCUS  THEN
                        SELECT CASE CBCTL
                            CASE %IDC_TEXTBOX3
                                ' read display
                        END SELECT 'CBCTL
                     END IF 'CBCTLMSG = %EN_KILLFOCUS
                CASE %IDC_TEXTBOX4  ' MD12 field
                    IF CBCTLMSG = %EN_KILLFOCUS  THEN
                        SELECT CASE CBCTL
                            CASE %IDC_TEXTBOX4
                                ' read display
                        END SELECT 'CBCTL
                     END IF 'CBCTLMSG = %EN_KILLFOCUS
                CASE %IDB_READ      ' Read button
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                       readFromPLC()
                    END IF
                CASE %IDB_ADD       ' Add button
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                       addvalue()
                    END IF
                CASE %IDB_WRITE     ' Write button
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                       writeToPLC()
                    END IF
                CASE %IDC_QUIT      ' Quit button
                    IF CBCTLMSG = %BN_CLICKED OR CBCTLMSG = 1 THEN
                        CONTROL DISABLE gMhDlg, %IDC_QUIT
                        CALL GameOver(ph, di, DC)
                        DIALOG END CBHNDL
                    END IF
            END SELECT
    END SELECT

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowMainDialog(BYVAL hParent AS DWORD) AS LONG
    DIM lRslt  AS LOCAL LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG1->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW hParent, "LibNoDave", 70, 70, 261, 130, %WS_POPUP OR _
        %WS_BORDER OR %WS_DLGFRAME OR %WS_SYSMENU OR %WS_CLIPSIBLINGS OR _
        %WS_VISIBLE OR %DS_MODALFRAME OR %DS_3DLOOK OR %DS_NOFAILCREATE OR _
        %DS_SETFONT, %WS_EX_WINDOWEDGE OR %WS_EX_CONTROLPARENT OR _
        %WS_EX_LEFT OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR, TO hDlg
    CONTROL ADD BUTTON,  hDlg, %IDC_QUIT, "QUIT", 200, 95, 30, 15
    CONTROL ADD BUTTON,  hDlg, %IDB_READ, "Read Flags", 55, 70, 40, 15
    CONTROL ADD BUTTON,  hDlg, %IDB_ADD, "Add 1", 110, 70, 40, 15
    CONTROL ADD BUTTON,  hDlg, %IDB_Write, "Write Flags", 165, 70, 40, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX1, "FD 0", 25, 40, 40, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX2, "FD 4", 80, 40, 40, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX3, "FD 8", 135, 40, 40, 15
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX4, "FD 12", 190, 40, 40, 15
    CONTROL ADD LABEL,   hDlg, %IDC_Status, "Status", 25, 10, 205, 10, _
        %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL SET COLOR    hDlg, %IDC_Status, %BLUE, -1
#PBFORMS END DIALOG


#PBFORMS BEGIN CLEANUP %IDD_DIALOG1
#PBFORMS END CLEANUP
    ' Save the handle for global access
    gMhDlg = hDlg

    FUNCTION = lRslt
END FUNCTION
'------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
FUNCTION Init2() AS LONG
' after show dialog

    Initialize(ph, di, DC)
    IF ok = %False THEN
       CONTROL DISABLE gMhDlg, %IDB_READ
       CONTROL DISABLE gMhDlg, %IDB_WRITE
    END IF 'ok
    FUNCTION = ok

END FUNCTION

'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
' This initialization is used in all test programs. In a real program, where you would
' want to read again and again, keep the dc and di until your program terminates.
'
FUNCTION Initialize(BYREF ph AS LONG, BYREF di AS LONG, BYREF DC AS LONG) AS LONG
    DIM lvar    AS LOCAL LONG
    DIM lRslt   AS LOCAL LONG

    ok = %False ' no connection
    ph = 0      ' port handle
    di = 0      ' dave interface handle
    DC = 0      ' dave connection handle
REM uncomment the daveSetDebug... LINE, SAVE your sheet
REM run excel FROM dos BOX WITH: excel yoursheet >debugout.txt
REM SEND me the file debugout.txt IF you have trouble.
REM CALL daveSetDebug(daveDebugAll)
    ph = openPort(sPort, sBaud$, ASC(LEFT$(sParity$, 1)))
' Alternatives:
REM ph = openSocket(102, peer$)    ' for ISO over TCP
REM ph = openSocket(1099, peer$)' for IBH NetLink
REM ph = openS7online(acspnt$) ' to use Siemes libraries for transport (s7online)
    IF (ph > 0) THEN
        sT =  "port handle ok: " + STR$(ph)
        CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
        di = daveNewInterface(ph, ph, "IF1", 0, %daveProtoMPI, %daveSpeed187k)
' Alternatives:
REM di = daveNewInterface(ph, ph, "IF1", 0, daveProtoPPI, daveSpeed187k)
REM di = daveNewInterface(ph, ph, "IF1", 0, daveProtoMPI_IBH, daveSpeed187k)
REM di = daveNewInterface(ph, ph, "IF1", 0, daveProtoISOTCP, daveSpeed187k)
REM di = daveNewInterface(ph, ph, "IF1", 0, daveProtoS7online, daveSpeed187k)
'
'You can set longer timeout here, if you have  a slow connection
'    Call daveSetTimeout(di, 500000)
        lRslt = daveInitAdapter(di)
        IF lRslt = 0 THEN
            sT =  "result from initAdapter ok: " + STR$(lRslt)
            CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
'
' with ISO over TCP, set correct values for rack and slot of the CPU
'
            DC = daveNewConnection(di, plcMPI, Rack, Slot)
            lRslt = daveConnectPLC(DC)
            IF lRslt = 0 THEN
                sT =  "PLC connection ok: "
                CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
                ok = %True
            ELSE
                ok = %False
                sT =  "Error No PLC connection: " + STR$(lRslt)
                CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
                EXIT FUNCTION
            END IF 'lRslt = daveConnectPLC
        ELSE
            sT =  "Error initAdapter: " + STR$(lRslt)
            CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
            EXIT FUNCTION
        END IF 'lRslt = daveInitAdapter
    ELSE
        ok = %False
        sT =  "Error port handle: " + STR$(ph)
        CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
    END IF '(ph > 0)
    FUNCTION = ok
END FUNCTION 'Initialize
'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
' Disconnect from PLC, disconnect from Adapter, close the serial interface or TCP/IP socket
SUB GameOver(BYREF ph AS LONG, BYREF di AS LONG, BYREF DC AS LONG)
    DIM lvar    AS LOCAL LONG
    DIM lRslt   AS LOCAL LONG

    sT =  "disconnecting from PLC"
    CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
    IF DC <> 0 THEN
        lRslt = daveDisconnectPLC(DC)
        CALL daveFree(DC)
        DC = 0
    END IF
    IF di <> 0 THEN
        lRslt = daveDisconnectAdapter(di)
        CALL daveFree(di)
        di = 0
    END IF
    IF ph <> 0 THEN
        lRslt = closePort(ph)
        ph = 0
    END IF
    ok = %False

END SUB 'GameOver
'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
' read values from textboxes
SUB ReadScreen
    DIM txt          AS LOCAL STRING

    ' read screen values
    CONTROL GET TEXT gMhdlg, %IDC_TEXTBOX1 TO txt$
    v1 = VAL(txt$)
    CONTROL GET TEXT gMhdlg, %IDC_TEXTBOX2 TO txt$
    v2 = VAL(txt$)
    CONTROL GET TEXT gMhdlg, %IDC_TEXTBOX3 TO txt$
    v3 = VAL(txt$)
    CONTROL GET TEXT gMhdlg, %IDC_TEXTBOX4 TO txt$
    v4 = VAL(txt$)

END SUB 'ReadScreen
'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
' write values to textboxes
SUB WriteScreen
    DIM txt          AS LOCAL STRING

    ' write values to screen
    txt$ = FORMAT$(v1,"#####")    'show MD0
    CONTROL SET TEXT gMhDlg, %IDC_TEXTBOX1, txt$
    txt$ = FORMAT$(v2,"#####")    'show MD4
    CONTROL SET TEXT gMhDlg, %IDC_TEXTBOX2, txt$
    txt$ = FORMAT$(v3,"#####")    'show MD8
    CONTROL SET TEXT gMhDlg, %IDC_TEXTBOX3, txt$
    txt$ = FORMAT$(v4,"#####.##")  'show MD12
    CONTROL SET TEXT gMhDlg, %IDC_TEXTBOX4, txt$

END SUB 'WriteScreen
'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
' read some values from FD0,FD4,FD8,FD12 (MD0,MD4,MD8,MD12 in german notation)
'  to read from data block 12, you would need to write:
'  daveReadBytes(dc, daveDB, 12, 0, 16, 0)
SUB ReadFromPLC()
    DIM lRslt   AS LOCAL LONG
    DIM e       AS LOCAL STRING

    IF ok = %True THEN
        sT =  "Testing PLC read "
        CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
        lRslt = daveReadBytes(DC, %daveFlags, 0, 0, 16, 0)
        IF lRslt = 0 THEN
            v1 = daveGetS32(DC)         'MD0(DINT)
            v2 = daveGetS32(DC)         'MD4(DINT)
            v3 = daveGetS32(DC)         'MD8(DINT)
            v4 = daveGetFloat(DC)       'MD12(REAL)
            v5 = daveGetFloatAt(DC, 12)
            WriteScreen()
        ELSE
            e$ = daveStrError(lRslt)
            sT =  " error: " + STR$(lRslt) + e$
            CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
        END IF
    END IF

END SUB 'ReadFromPLC
'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
SUB addvalue()

    sT =  " add 1 "
    CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
    ReadScreen()
    v1 = v1 +1
    v2 = v2 +2
    v3 = v3 +3
    v4 = v4 +1.1
    WriteScreen()

END SUB 'addvalue
'-----------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------
' read values from textboxes and
' write values to FD0,FD4,FD8,FD12 (MD0,MD4,MD8,MD12 in german notation)
SUB writeToPLC()
    DIM buffer(1024) AS BYTE
    DIM lRslt        AS LOCAL LONG
    DIM e            AS LOCAL STRING

    IF ok = %True THEN
        sT =  "Testing PLC write "
        CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
        ReadScreen()
' Here we put thre DINTs and a REAL into the buffer. davePutXXX does the necessary conversions.
' The resulting byte pattern in the buffer is the same you would get, when you watch the PLC
' memory (FB0 .. FB15) as bytes
'
        lRslt = davePut32(buffer(0), v1)
        lRslt = davePut32(buffer(4), v2)
        lRslt = davePut32(buffer(8), v3)
        lRslt = davePutFloat(buffer(12), v4)
        lRslt = daveWriteBytes(DC, %daveFlags, 0, 0, 16, buffer(0))
        IF lRslt <> 0 THEN
            e$ = daveStrError(lRslt)
            sT =  " error: " + STR$(lRslt) + e$
            CONTROL SET TEXT gMhDlg, %IDC_STATUS, sT
        END IF
    END IF

END SUB 'writeToPLC()
'-----------------------------------------------------------------------------------------------
