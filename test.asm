.text
.equ myval, 0x12122002
main:
  JAL     ra, imm             # immediate arithmetic, and test upper stuffs
  JAL     ra, store           # store cycles of values into DataMem
  JAL     ra, reg             # register arithmetic
  JAL     ra, load            # test loading these values into registers
  JAL     ra, branch          # just lots of branch conditions
  ADDI    a2, zero, 0x0FF     # setting up for f1thing
forever:
  JAL     ra, f1thing         # simplified ver. of f1 program
  J       forever

imm:
  LUI     a0, 0x12122
  ADDI    a0, a0, 0x002       # equiv to LI  a0, myval
  ADDI    a1, a0, 0x110       # a1 = 0x12122112
  SLLI    a2, a0, 0x003       # a2 = 0x90910010
  ADDI    a3, a2, 0xC78       # a2 = 0x9090FC88
  SLTI    t0, a0, 0xD0D       # t0 = 0
  SLTIU   t1, a0, 0xD0D       # t1 = 1
  XORI    a4, a3, 0xA67       # a4 = 0x6F6F06EF
  SRLI    a5, a4, 0x008       # a5 = 0x006F6F06
  SRAI    t2, a4, 0x6BB       # t2 = 0xDDEDEDE0
  ORI     a6, a3, 0x7A4       # a6 = 0x9090FFEC
  ANDI    a7, a4, 0x678       # a7 = 0x00000668
  AUIPC   s0, 0xBFC00         # s0 = 0xBFC00 + PC
  LUI     a1, 0xF7F78
  ADDI    a1, a1, 0x878       # a1 = 0xF7F78878
  RET

store:
  ADDI    a7, zero, 0x003     # loop_count a7 = 3
  ADDI    a6, zero, 0x91A     # can replace below with mul (*2)
  ADDI    a6, a6, 0x91A       # base_address = 0x00001234
_loop1:                         
  SB      a3, 0x002(a6)       # mem[[a6]+2] = 0x88
  SH      a5, 0x000(a6)       # mem[[a6]]   = 0x6F06
  SW      a7, 0xFFE(a6)       # mem[[a6]-2] = 0x00000003
  ADDI    t0, t0, 0x001       # increment t0
  ADD     a6, a6, t0          # increase a6
  BNE     t0, a7, _loop1      # until t0 = 3
  RET

reg:
  ADD     s1, zero, a0        # just keeping this val safe
  SUB     a3, a1, a2          # a3 = 0x67668868
  ADD     a0, a1, a2          # a0 = 0x88888888
  SLT     t0, a1, a2          # t0 = 0
  XOR     a4, a1, a2          # a4 = 0x67668868
  OR      a5, a1, a2          # a5 = 0xF7F78878
  AND     a6, a1, a2          # a6 = 0x90910010
  ADDI    a1, a1, 0x011       # a1 = 0x011
  SLL     a7, a0, a1          # a7 = 0x11100000
  ADDI    a1, a1, 0x002       # a1 = 0x002
  SRL     a3, a0, a1          # a0 = 0x22222222
  RET

load:
  LUI     a1, 0x00001
  ADDI    a1, a1, 0x236       # a1 = 0x00001236
  LB      a2, a1, 0xFFE       # a2 = 0xFFFFFFEF
  LH      a4, a1, 0x000       # a4 = 0x00000088
  LW      a5, a1, 0x001       # a5 = 0x6F6F06EF
  LBU     a6, a1, 0x003       # a6 = 0x00000088
  LHU     a7, a1, 0xFFD       # a7 = 0x00006F0D
  RET

# doesn't fully test branches, for lack of time
branch: 
  BEQ     a2, a3, branch      # shouldn't branch
  BGE     a4, a5, branch      # shouldn't branch
  BGEU    a1, a0, branch      # shouldn't branch
  BLT     a7, a0, branch      # shouldn't branch
  BLTU    a0, a1, branch      # shouldn't branch
  RET
