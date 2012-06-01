#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_3 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DLE ETX NAK STX SYN */
  /* Offset 0 gives the best switch position.  */
  switch (*name++) {
  case 'D':
    if (name[0] == 'L' && name[1] == 'E') {
#ifdef DLE
      *iv_return = DLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (name[0] == 'T' && name[1] == 'X') {
#ifdef ETX
      *iv_return = ETX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (name[0] == 'A' && name[1] == 'K') {
#ifdef NAK
      *iv_return = NAK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (name[0] == 'T' && name[1] == 'X') {
#ifdef STX
      *iv_return = STX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (name[0] == 'Y' && name[1] == 'N') {
#ifdef SYN
      *iv_return = SYN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_9 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveAnaIn daveFlags daveLocal daveResOK daveTimer */
  /* Offset 5 gives the best switch position.  */
  switch (name[5]) {
  case 'e':
    if (memEQ(name, "daveResOK", 9)) {
    /*                    ^         */
#ifdef daveResOK
      *iv_return = daveResOK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'i':
    if (memEQ(name, "daveTimer", 9)) {
    /*                    ^         */
#ifdef daveTimer
      *iv_return = daveTimer;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "daveFlags", 9)) {
    /*                    ^         */
#ifdef daveFlags
      *iv_return = daveFlags;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'n':
    if (memEQ(name, "daveAnaIn", 9)) {
    /*                    ^         */
#ifdef daveAnaIn
      *iv_return = daveAnaIn;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "daveLocal", 9)) {
    /*                    ^         */
#ifdef daveLocal
      *iv_return = daveLocal;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_11 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveCounter daveOutputs daveSpeed9k daveSysInfo */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case 'k':
    if (memEQ(name, "daveSpeed9", 10)) {
    /*                         k      */
#ifdef daveSpeed9k
      *iv_return = daveSpeed9k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "daveSysInf", 10)) {
    /*                         o      */
#ifdef daveSysInfo
      *iv_return = daveSysInfo;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "daveCounte", 10)) {
    /*                         r      */
#ifdef daveCounter
      *iv_return = daveCounter;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 's':
    if (memEQ(name, "daveOutput", 10)) {
    /*                         s      */
#ifdef daveOutputs
      *iv_return = daveOutputs;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_12 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     _davePtEmpty daveDebugAll daveDebugMPI daveDebugPDU daveFuncRead
     daveProtoMPI daveProtoPPI daveSpeed19k daveSpeed45k daveSpeed93k
     daveSysFlags daveTimer200 */
  /* Offset 9 gives the best switch position.  */
  switch (name[9]) {
  case '1':
    if (memEQ(name, "daveSpeed19k", 12)) {
    /*                        ^         */
#ifdef daveSpeed19k
      *iv_return = daveSpeed19k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "daveTimer200", 12)) {
    /*                        ^         */
#ifdef daveTimer200
      *iv_return = daveTimer200;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "daveSpeed45k", 12)) {
    /*                        ^         */
#ifdef daveSpeed45k
      *iv_return = daveSpeed45k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '9':
    if (memEQ(name, "daveSpeed93k", 12)) {
    /*                        ^         */
#ifdef daveSpeed93k
      *iv_return = daveSpeed93k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "daveDebugAll", 12)) {
    /*                        ^         */
#ifdef daveDebugAll
      *iv_return = daveDebugAll;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "daveDebugMPI", 12)) {
    /*                        ^         */
#ifdef daveDebugMPI
      *iv_return = daveDebugMPI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "daveProtoMPI", 12)) {
    /*                        ^         */
#ifdef daveProtoMPI
      *iv_return = daveProtoMPI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "daveDebugPDU", 12)) {
    /*                        ^         */
#ifdef daveDebugPDU
      *iv_return = daveDebugPDU;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "daveProtoPPI", 12)) {
    /*                        ^         */
#ifdef daveProtoPPI
      *iv_return = daveProtoPPI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'a':
    if (memEQ(name, "daveSysFlags", 12)) {
    /*                        ^         */
#ifdef daveSysFlags
      *iv_return = daveSysFlags;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'e':
    if (memEQ(name, "daveFuncRead", 12)) {
    /*                        ^         */
#ifdef daveFuncRead
      *iv_return = daveFuncRead;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'p':
    if (memEQ(name, "_davePtEmpty", 12)) {
    /*                        ^         */
#ifdef _davePtEmpty
      *iv_return = _davePtEmpty;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_13 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     _davePtMPIAck daveDebugByte daveDebugOpen daveFuncWrite daveMPIunused
     daveMaxRawLen daveProtoMPI2 daveProtoMPI3 daveSpeed187k daveSpeed500k */
  /* Offset 9 gives the best switch position.  */
  switch (name[9]) {
  case '1':
    if (memEQ(name, "daveSpeed187k", 13)) {
    /*                        ^          */
#ifdef daveSpeed187k
      *iv_return = daveSpeed187k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '5':
    if (memEQ(name, "daveSpeed500k", 13)) {
    /*                        ^          */
#ifdef daveSpeed500k
      *iv_return = daveSpeed500k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "daveDebugByte", 13)) {
    /*                        ^          */
#ifdef daveDebugByte
      *iv_return = daveDebugByte;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "_davePtMPIAck", 13)) {
    /*                        ^          */
#ifdef _davePtMPIAck
      *iv_return = _davePtMPIAck;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "daveProtoMPI2", 13)) {
    /*                        ^          */
#ifdef daveProtoMPI2
      *iv_return = daveProtoMPI2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "daveProtoMPI3", 13)) {
    /*                        ^          */
#ifdef daveProtoMPI3
      *iv_return = daveProtoMPI3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "daveDebugOpen", 13)) {
    /*                        ^          */
#ifdef daveDebugOpen
      *iv_return = daveDebugOpen;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "daveFuncWrite", 13)) {
    /*                        ^          */
#ifdef daveFuncWrite
      *iv_return = daveFuncWrite;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'u':
    if (memEQ(name, "daveMPIunused", 13)) {
    /*                        ^          */
#ifdef daveMPIunused
      *iv_return = daveMPIunused;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'w':
    if (memEQ(name, "daveMaxRawLen", 13)) {
    /*                        ^          */
#ifdef daveMaxRawLen
      *iv_return = daveMaxRawLen;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_14 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveCounter200 daveFuncUpload daveResTimeout daveSpeed1500k */
  /* Offset 4 gives the best switch position.  */
  switch (name[4]) {
  case 'C':
    if (memEQ(name, "daveCounter200", 14)) {
    /*                   ^                */
#ifdef daveCounter200
      *iv_return = daveCounter200;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "daveFuncUpload", 14)) {
    /*                   ^                */
#ifdef daveFuncUpload
      *iv_return = daveFuncUpload;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "daveResTimeout", 14)) {
    /*                   ^                */
#ifdef daveResTimeout
      *iv_return = daveResTimeout;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "daveSpeed1500k", 14)) {
    /*                   ^                */
#ifdef daveSpeed1500k
      *iv_return = daveSpeed1500k;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_15 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveDebugPacket daveDebugUpload daveProtoISOTCP */
  /* Offset 9 gives the best switch position.  */
  switch (name[9]) {
  case 'I':
    if (memEQ(name, "daveProtoISOTCP", 15)) {
    /*                        ^            */
#ifdef daveProtoISOTCP
      *iv_return = daveProtoISOTCP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "daveDebugPacket", 15)) {
    /*                        ^            */
#ifdef daveDebugPacket
      *iv_return = daveDebugPacket;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "daveDebugUpload", 15)) {
    /*                        ^            */
#ifdef daveDebugUpload
      *iv_return = daveDebugUpload;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_16 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveBlockType_DB daveBlockType_FB daveBlockType_FC daveBlockType_OB
     daveDebugCompare daveDebugConnect daveDebugPassive daveDebugRawRead
     daveMPIReachable daveProtoMPI_IBH daveProtoPPI_IBH daveResCPUNoData
     daveUnknownError */
  /* Offset 14 gives the best switch position.  */
  switch (name[14]) {
  case 'B':
    if (memEQ(name, "daveProtoMPI_IBH", 16)) {
    /*                             ^        */
#ifdef daveProtoMPI_IBH
      *iv_return = daveProtoMPI_IBH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "daveProtoPPI_IBH", 16)) {
    /*                             ^        */
#ifdef daveProtoPPI_IBH
      *iv_return = daveProtoPPI_IBH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "daveBlockType_DB", 16)) {
    /*                             ^        */
#ifdef daveBlockType_DB
      *iv_return = daveBlockType_DB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "daveBlockType_FB", 16)) {
    /*                             ^        */
#ifdef daveBlockType_FB
      *iv_return = daveBlockType_FB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "daveBlockType_FC", 16)) {
    /*                             ^        */
#ifdef daveBlockType_FC
      *iv_return = daveBlockType_FC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "daveBlockType_OB", 16)) {
    /*                             ^        */
#ifdef daveBlockType_OB
      *iv_return = daveBlockType_OB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'a':
    if (memEQ(name, "daveDebugRawRead", 16)) {
    /*                             ^        */
#ifdef daveDebugRawRead
      *iv_return = daveDebugRawRead;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'c':
    if (memEQ(name, "daveDebugConnect", 16)) {
    /*                             ^        */
#ifdef daveDebugConnect
      *iv_return = daveDebugConnect;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "daveMPIReachable", 16)) {
    /*                             ^        */
#ifdef daveMPIReachable
      *iv_return = daveMPIReachable;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "daveUnknownError", 16)) {
    /*                             ^        */
#ifdef daveUnknownError
      *iv_return = daveUnknownError;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "daveDebugCompare", 16)) {
    /*                             ^        */
#ifdef daveDebugCompare
      *iv_return = daveDebugCompare;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "daveResCPUNoData", 16)) {
    /*                             ^        */
#ifdef daveResCPUNoData
      *iv_return = daveResCPUNoData;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'v':
    if (memEQ(name, "daveDebugPassive", 16)) {
    /*                             ^        */
#ifdef daveDebugPassive
      *iv_return = daveDebugPassive;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_17 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveBlockType_SDB daveBlockType_SFB daveBlockType_SFC daveDebugExchange
     daveDebugRawWrite daveFuncEndUpload daveOrderCodeSize */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'D':
    if (memEQ(name, "daveBlockType_SDB", 17)) {
    /*                              ^        */
#ifdef daveBlockType_SDB
      *iv_return = daveBlockType_SDB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "daveBlockType_SFB", 17)) {
    /*                              ^        */
#ifdef daveBlockType_SFB
      *iv_return = daveBlockType_SFB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "daveBlockType_SFC", 17)) {
    /*                              ^        */
#ifdef daveBlockType_SFC
      *iv_return = daveBlockType_SFC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'a':
    if (memEQ(name, "daveFuncEndUpload", 17)) {
    /*                              ^        */
#ifdef daveFuncEndUpload
      *iv_return = daveFuncEndUpload;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'g':
    if (memEQ(name, "daveDebugExchange", 17)) {
    /*                              ^        */
#ifdef daveDebugExchange
      *iv_return = daveDebugExchange;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "daveDebugRawWrite", 17)) {
    /*                              ^        */
#ifdef daveDebugRawWrite
      *iv_return = daveDebugRawWrite;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'z':
    if (memEQ(name, "daveOrderCodeSize", 17)) {
    /*                              ^        */
#ifdef daveOrderCodeSize
      *iv_return = daveOrderCodeSize;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_19 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     _davePtReadResponse daveFuncInsertBlock daveFuncStartUpload
     davePartnerListSize */
  /* Offset 12 gives the best switch position.  */
  switch (name[12]) {
  case 'e':
    if (memEQ(name, "_davePtReadResponse", 19)) {
    /*                           ^             */
#ifdef _davePtReadResponse
      *iv_return = _davePtReadResponse;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'i':
    if (memEQ(name, "davePartnerListSize", 19)) {
    /*                           ^             */
#ifdef davePartnerListSize
      *iv_return = davePartnerListSize;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "daveFuncInsertBlock", 19)) {
    /*                           ^             */
#ifdef daveFuncInsertBlock
      *iv_return = daveFuncInsertBlock;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "daveFuncStartUpload", 19)) {
    /*                           ^             */
#ifdef daveFuncStartUpload
      *iv_return = daveFuncStartUpload;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_20 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     _davePtWriteResponse daveDebugInitAdapter daveDebugPrintErrors
     daveEmptyResultError */
  /* Offset 17 gives the best switch position.  */
  switch (name[17]) {
  case 'n':
    if (memEQ(name, "_davePtWriteResponse", 20)) {
    /*                                ^         */
#ifdef _davePtWriteResponse
      *iv_return = _davePtWriteResponse;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "daveDebugPrintErrors", 20)) {
    /*                                ^         */
#ifdef daveDebugPrintErrors
      *iv_return = daveDebugPrintErrors;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "daveEmptyResultError", 20)) {
    /*                                ^         */
#ifdef daveEmptyResultError
      *iv_return = daveEmptyResultError;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "daveDebugInitAdapter", 20)) {
    /*                                ^         */
#ifdef daveDebugInitAdapter
      *iv_return = daveDebugInitAdapter;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_21 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     _davePtUnknownMPIFunc _davePtUnknownPDUFunc daveAddressOutOfRange
     daveDebugSpecialChars daveFuncDownloadBlock daveFuncDownloadEnded
     daveResUnexpectedFunc */
  /* Offset 16 gives the best switch position.  */
  switch (name[16]) {
  case 'B':
    if (memEQ(name, "daveFuncDownloadBlock", 21)) {
    /*                               ^           */
#ifdef daveFuncDownloadBlock
      *iv_return = daveFuncDownloadBlock;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "daveDebugSpecialChars", 21)) {
    /*                               ^           */
#ifdef daveDebugSpecialChars
      *iv_return = daveDebugSpecialChars;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "daveFuncDownloadEnded", 21)) {
    /*                               ^           */
#ifdef daveFuncDownloadEnded
      *iv_return = daveFuncDownloadEnded;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "_davePtUnknownMPIFunc", 21)) {
    /*                               ^           */
#ifdef _davePtUnknownMPIFunc
      *iv_return = _davePtUnknownMPIFunc;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "daveAddressOutOfRange", 21)) {
    /*                               ^           */
#ifdef daveAddressOutOfRange
      *iv_return = daveAddressOutOfRange;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "_davePtUnknownPDUFunc", 21)) {
    /*                               ^           */
#ifdef _davePtUnknownPDUFunc
      *iv_return = _davePtUnknownPDUFunc;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'd':
    if (memEQ(name, "daveResUnexpectedFunc", 21)) {
    /*                               ^           */
#ifdef daveResUnexpectedFunc
      *iv_return = daveResUnexpectedFunc;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_23 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     daveDebugErrorReporting daveDebugListReachables daveEmptyResultSetError
     daveFuncRequestDownload daveResItemNotAvailable */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case 'e':
    if (memEQ(name, "daveEmptyResultSetError", 23)) {
    /*                         ^                   */
#ifdef daveEmptyResultSetError
      *iv_return = daveEmptyResultSetError;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'i':
    if (memEQ(name, "daveDebugListReachables", 23)) {
    /*                         ^                   */
#ifdef daveDebugListReachables
      *iv_return = daveDebugListReachables;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'm':
    if (memEQ(name, "daveResItemNotAvailable", 23)) {
    /*                         ^                   */
#ifdef daveResItemNotAvailable
      *iv_return = daveResItemNotAvailable;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'q':
    if (memEQ(name, "daveFuncRequestDownload", 23)) {
    /*                         ^                   */
#ifdef daveFuncRequestDownload
      *iv_return = daveFuncRequestDownload;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "daveDebugErrorReporting", 23)) {
    /*                         ^                   */
#ifdef daveDebugErrorReporting
      *iv_return = daveDebugErrorReporting;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!/usr/bin/perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(DLE ETX NAK STX SYN _davePtEmpty _davePtMPIAck
	       _davePtReadResponse _davePtUnknownMPIFunc _davePtUnknownPDUFunc
	       _davePtWriteResponse daveAddressOutOfRange daveAnaIn daveAnaOut
	       daveBlockType_DB daveBlockType_FB daveBlockType_FC
	       daveBlockType_OB daveBlockType_SDB daveBlockType_SFB
	       daveBlockType_SFC daveCounter daveCounter200 daveDB daveDI
	       daveDebugAll daveDebugByte daveDebugCompare daveDebugConnect
	       daveDebugErrorReporting daveDebugExchange daveDebugInitAdapter
	       daveDebugListReachables daveDebugMPI daveDebugOpen daveDebugPDU
	       daveDebugPacket daveDebugPassive daveDebugPrintErrors
	       daveDebugRawRead daveDebugRawWrite daveDebugSpecialChars
	       daveDebugUpload daveEmptyResultError daveEmptyResultSetError
	       daveFlags daveFuncDownloadBlock daveFuncDownloadEnded
	       daveFuncEndUpload daveFuncInsertBlock daveFuncOpenS7Connection
	       daveFuncRead daveFuncRequestDownload daveFuncStartUpload
	       daveFuncUpload daveFuncWrite daveInputs daveLocal
	       daveMPIReachable daveMPIunused daveMaxRawLen daveOrderCodeSize
	       daveOutputs daveP davePartnerListSize daveProtoISOTCP
	       daveProtoISOTCP243 daveProtoMPI daveProtoMPI2 daveProtoMPI3
	       daveProtoMPI_IBH daveProtoPPI daveProtoPPI_IBH
	       daveProtoUserTransport daveResCPUNoData daveResCannotEvaluatePDU
	       daveResItemNotAvailable daveResItemNotAvailable200
	       daveResMultipleBitsNotSupported daveResNoPeripheralAtAddress
	       daveResOK daveResShortPacket daveResTimeout
	       daveResUnexpectedFunc daveResUnknownDataUnitSize daveSpeed1500k
	       daveSpeed187k daveSpeed19k daveSpeed45k daveSpeed500k
	       daveSpeed93k daveSpeed9k daveSysFlags daveSysInfo daveTimer
	       daveTimer200 daveUnknownError daveV daveWriteDataSizeMismatch));

print constant_types(); # macro defs
foreach (C_constant ("Nodave", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "#### XS Section:\n";
print XS_constant ("Nodave", $types);
__END__
   */

  switch (len) {
  case 3:
    return constant_3 (aTHX_ name, iv_return);
    break;
  case 5:
    /* Names all of length 5.  */
    /* daveP daveV */
    /* Offset 4 gives the best switch position.  */
    switch (name[4]) {
    case 'P':
      if (memEQ(name, "dave", 4)) {
      /*                   P     */
#ifdef daveP
        *iv_return = daveP;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'V':
      if (memEQ(name, "dave", 4)) {
      /*                   V     */
#ifdef daveV
        *iv_return = daveV;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 6:
    /* Names all of length 6.  */
    /* daveDB daveDI */
    /* Offset 5 gives the best switch position.  */
    switch (name[5]) {
    case 'B':
      if (memEQ(name, "daveD", 5)) {
      /*                    B     */
#ifdef daveDB
        *iv_return = daveDB;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'I':
      if (memEQ(name, "daveD", 5)) {
      /*                    I     */
#ifdef daveDI
        *iv_return = daveDI;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 9:
    return constant_9 (aTHX_ name, iv_return);
    break;
  case 10:
    /* Names all of length 10.  */
    /* daveAnaOut daveInputs */
    /* Offset 9 gives the best switch position.  */
    switch (name[9]) {
    case 's':
      if (memEQ(name, "daveInput", 9)) {
      /*                        s     */
#ifdef daveInputs
        *iv_return = daveInputs;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 't':
      if (memEQ(name, "daveAnaOu", 9)) {
      /*                        t     */
#ifdef daveAnaOut
        *iv_return = daveAnaOut;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 11:
    return constant_11 (aTHX_ name, iv_return);
    break;
  case 12:
    return constant_12 (aTHX_ name, iv_return);
    break;
  case 13:
    return constant_13 (aTHX_ name, iv_return);
    break;
  case 14:
    return constant_14 (aTHX_ name, iv_return);
    break;
  case 15:
    return constant_15 (aTHX_ name, iv_return);
    break;
  case 16:
    return constant_16 (aTHX_ name, iv_return);
    break;
  case 17:
    return constant_17 (aTHX_ name, iv_return);
    break;
  case 18:
    /* Names all of length 18.  */
    /* daveProtoISOTCP243 daveResShortPacket */
    /* Offset 4 gives the best switch position.  */
    switch (name[4]) {
    case 'P':
      if (memEQ(name, "daveProtoISOTCP243", 18)) {
      /*                   ^                    */
#ifdef daveProtoISOTCP243
        *iv_return = daveProtoISOTCP243;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'R':
      if (memEQ(name, "daveResShortPacket", 18)) {
      /*                   ^                    */
#ifdef daveResShortPacket
        *iv_return = daveResShortPacket;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 19:
    return constant_19 (aTHX_ name, iv_return);
    break;
  case 20:
    return constant_20 (aTHX_ name, iv_return);
    break;
  case 21:
    return constant_21 (aTHX_ name, iv_return);
    break;
  case 22:
    if (memEQ(name, "daveProtoUserTransport", 22)) {
#ifdef daveProtoUserTransport
      *iv_return = daveProtoUserTransport;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 23:
    return constant_23 (aTHX_ name, iv_return);
    break;
  case 24:
    /* Names all of length 24.  */
    /* daveFuncOpenS7Connection daveResCannotEvaluatePDU */
    /* Offset 11 gives the best switch position.  */
    switch (name[11]) {
    case 'n':
      if (memEQ(name, "daveFuncOpenS7Connection", 24)) {
      /*                          ^                   */
#ifdef daveFuncOpenS7Connection
        *iv_return = daveFuncOpenS7Connection;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'o':
      if (memEQ(name, "daveResCannotEvaluatePDU", 24)) {
      /*                          ^                   */
#ifdef daveResCannotEvaluatePDU
        *iv_return = daveResCannotEvaluatePDU;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 25:
    if (memEQ(name, "daveWriteDataSizeMismatch", 25)) {
#ifdef daveWriteDataSizeMismatch
      *iv_return = daveWriteDataSizeMismatch;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 26:
    /* Names all of length 26.  */
    /* daveResItemNotAvailable200 daveResUnknownDataUnitSize */
    /* Offset 10 gives the best switch position.  */
    switch (name[10]) {
    case 'm':
      if (memEQ(name, "daveResItemNotAvailable200", 26)) {
      /*                         ^                      */
#ifdef daveResItemNotAvailable200
        *iv_return = daveResItemNotAvailable200;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'n':
      if (memEQ(name, "daveResUnknownDataUnitSize", 26)) {
      /*                         ^                      */
#ifdef daveResUnknownDataUnitSize
        *iv_return = daveResUnknownDataUnitSize;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 28:
    if (memEQ(name, "daveResNoPeripheralAtAddress", 28)) {
#ifdef daveResNoPeripheralAtAddress
      *iv_return = daveResNoPeripheralAtAddress;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 31:
    if (memEQ(name, "daveResMultipleBitsNotSupported", 31)) {
#ifdef daveResMultipleBitsNotSupported
      *iv_return = daveResMultipleBitsNotSupported;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

