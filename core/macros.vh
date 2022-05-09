// inst & func def
`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
`define OP_ANDI 6'b001100
`define OP_LUI 6'b001111
`define OP_ORI 6'b001101
`define OP_XORI 6'b001110
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_BGTZ 6'b000111
`define OP_BLEZ 6'b000110
`define OP_J 6'b000010
`define OP_JAL 6'b000011
`define OP_LB 6'b100000
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101
`define OP_LW 6'b100011
`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_SW 6'b101011
`define OP_SPECIAL 6'b000000
`define OP_BRANCH 6'b000001
`define OP_PRIVILEGE 6'b010000
`define OP_SPECIAL2 6'b011100
`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_DIV 6'b011010
`define FUNC_DIVU 6'b011011
`define FUNC_MULT 6'b011000
`define FUNC_MULTU 6'b011001
`define FUNC_AND 6'b100100
`define FUNC_NOR 6'b100111
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_SLL 6'b000000
`define FUNC_SLLV 6'b000100
`define FUNC_SRA 6'b000011
`define FUNC_SRAV 6'b000111
`define FUNC_SRL 6'b000010
`define FUNC_SRLV 6'b000110
`define FUNC_JR 6'b001000
`define FUNC_JALR 6'b001001
`define FUNC_MFHI 6'b010000
`define FUNC_MFLO 6'b010010
`define FUNC_MTHI 6'b010001
`define FUNC_MTLO 6'b010011
`define FUNC_BREAK 6'b001101
`define FUNC_SYSCALL 6'b001100
`define RT_BGEZ 5'b00001
`define RT_BGEZAL 5'b10001
`define RT_BLTZ 5'b00000
`define RT_BLTZAL 5'b10000
`define RS_ERET 5'b10000
`define FULL_ERET 32'b01000010_00000000_00000000_00011000
`define RS_MFC0 5'b00000
`define RS_MTC0 5'b00100


// inst_type id def
`define ID_NULL 0
`define ID_ADD 1
`define ID_ADDI 2
`define ID_ADDU 3
`define ID_ADDIU 4
`define ID_SUB 5
`define ID_SUBU 6
`define ID_SLT 7
`define ID_SLTI 8
`define ID_SLTU 9
`define ID_SLTIU 10
`define ID_DIV 11
`define ID_DIVU 12
`define ID_MULT 13
`define ID_MULTU 14
`define ID_AND 15
`define ID_ANDI 16
`define ID_LUI 17
`define ID_NOR 18
`define ID_OR 19
`define ID_ORI 20
`define ID_XOR 21
`define ID_XORI 22
`define ID_SLL 23
`define ID_SLLV 24
`define ID_SRA 25
`define ID_SRAV 26
`define ID_SRL 27
`define ID_SRLV 28
`define ID_BEQ 29
`define ID_BNE 30
`define ID_BGEZ 31
`define ID_BGEZAL 32
`define ID_BGTZ 33
`define ID_BLEZ 34
`define ID_BLTZ 35
`define ID_BLTZAL 36
`define ID_J 37
`define ID_JAL 38
`define ID_JR 39
`define ID_JALR 40
`define ID_MFHI 41
`define ID_MFLO 42
`define ID_MTHI 43
`define ID_MTLO 44
`define ID_BREAK 45
`define ID_SYSCALL 46
`define ID_LB 47
`define ID_LBU 48
`define ID_LH 49
`define ID_LHU 50
`define ID_LW 51
`define ID_SB 52
`define ID_SH 53
`define ID_SW 54
`define ID_ERET 55
`define ID_MFC0 56
`define ID_MTC0 57
`define ALU_ADD 1
`define ALU_ADDE 2
`define ALU_ADDU 3
`define ALU_AND 4
`define ALU_DIV 5
`define ALU_DIVU 6
`define ALU_LUI 7
`define ALU_MULT 8
`define ALU_MULTU 9
`define ALU_NOR 10
`define ALU_OR 11
`define ALU_SLL 12
`define ALU_SLT 13
`define ALU_SLTU 14
`define ALU_SRA 15
`define ALU_SRL 16
`define ALU_SUB 17
`define ALU_SUBE 18
`define ALU_SUBU 19
`define ALU_XOR 20
`define ID_NOP 58


// alu cmd def
`define ALU_NULL 0
`define ALU_ADD 1
`define ALU_ADDE 2
`define ALU_ADDU 3
`define ALU_AND 4
`define ALU_DIV 5
`define ALU_DIVU 6
`define ALU_LUI 7
`define ALU_MULT 8
`define ALU_MULTU 9
`define ALU_NOR 10
`define ALU_OR 11
`define ALU_SLL 12
`define ALU_SLT 13
`define ALU_SLTU 14
`define ALU_SRA 15
`define ALU_SRL 16
`define ALU_SUB 17
`define ALU_SUBE 18
`define ALU_SUBU 19
`define ALU_XOR 20


// cu control signals def
// RegWriteD	RegDstD	ALUSrcD	BranchD	JumpD	JRD	LinkD	HiLoWriteD	HiLoToRegD	CP0WriteD	CP0ToRegD	MemWriteD	MemToRegD	LoadUnsignedD	MemWidthD
`define CTRL_NULL 26'b00000000000000000000000000
`define CTRL_ITYPE 26'b10001000000000000000000000
`define CTRL_ITYPEU 26'b10001100000000000000000000
`define CTRL_RTYPE 26'b10100000000000000000000000
`define CTRL_RTYPES 26'b10110000000000000000000000
`define CTRL_LB 26'b10001000000000000000001001
`define CTRL_LBU 26'b10001000000000000000001101
`define CTRL_LH 26'b10001000000000000000001010
`define CTRL_LHU 26'b10001000000000000000001110
`define CTRL_LW 26'b10001000000000000000001011
`define CTRL_SB 26'b00001000000000000000010001
`define CTRL_SH 26'b00001000000000000000010010
`define CTRL_SW 26'b00001000000000000000010011
`define CTRL_BEQ 26'b00000000000100000000000000
`define CTRL_BNE 26'b00000000001000000000000000
`define CTRL_BGEZ 26'b00000000010000000000000000
`define CTRL_BGEZAL 26'b11000000010000100000000000
`define CTRL_BGTZ 26'b00000000100000000000000000
`define CTRL_BLEZ 26'b00000001000000000000000000
`define CTRL_BLTZ 26'b00000010000000000000000000
`define CTRL_BLTZAL 26'b11000010000000100000000000
`define CTRL_J 26'b00000000000010000000000000
`define CTRL_JAL 26'b11000000000010100000000000
`define CTRL_JR 26'b00000000000011000000000000
`define CTRL_JALR 26'b10100000000011100000000000
`define CTRL_DIV 26'b00000000000000011000000000
`define CTRL_DIVU 26'b00000000000000011000000000
`define CTRL_MULT 26'b00000000000000011000000000
`define CTRL_MULTU 26'b00000000000000011000000000
`define CTRL_MFHI 26'b10100000000000000100000000
`define CTRL_MFLO 26'b10100000000000000010000000
`define CTRL_MTHI 26'b00000000000000010000000000
`define CTRL_MTLO 26'b00000000000000001000000000
`define CTRL_BREAK 26'b00000000000000000000000000
`define CTRL_SYSCALL 26'b00000000000000000000000000
`define CTRL_ERET 26'b00000000000000000000000000
`define CTRL_MFC0 26'b10000000000000000000100000
`define CTRL_MTC0 26'b00000000000000000001000000


// cp0 address & select
`define CP0_ADDR_SEL_INDEX      {5'b00000, 3'b000} 
`define CP0_ADDR_SEL_RANDOM     {5'b00001, 3'b000} 
`define CP0_ADDR_SEL_ENTRYLO0   {5'b00010, 3'b000} 
`define CP0_ADDR_SEL_ENTRYLO1   {5'b00011, 3'b000} 
`define CP0_ADDR_SEL_PAGEMASK   {5'b00101, 3'b000} 
`define CP0_ADDR_SEL_BADVADDR   {5'b01000, 3'b000} 
`define CP0_ADDR_SEL_COUNT      {5'b01001, 3'b000} 
`define CP0_ADDR_SEL_ENTRYHI    {5'b01010, 3'b000} 
`define CP0_ADDR_SEL_COMPARE    {5'b01011, 3'b000} 
`define CP0_ADDR_SEL_STATUS     {5'b01100, 3'b000} 
`define CP0_ADDR_SEL_CAUSE      {5'b01101, 3'b000} 
`define CP0_ADDR_SEL_EPC        {5'b01110, 3'b000} 
`define CP0_ADDR_SEL_PRID       {5'b01111, 3'b000} 
`define CP0_ADDR_SEL_CONFIG0    {5'b10000, 3'b000} 
`define CP0_ADDR_SEL_CONFIG1    {5'b00000, 3'b001} 


// exception
`define EXCEP_INT       5'h0        // interrupt
`define EXCEP_AdELD     5'h4        // lw addr error
`define EXCEP_AdELI     5'h14       // pc fetch error
`define EXCEP_AdES      5'h5        // sw addr 
`define EXCEP_Sys       5'h8        // syscall
`define EXCEP_Bp        5'h9        // break point
`define EXCEP_RI        5'ha        // reserved instr
`define EXCEP_Ov        5'hc        // overflow      
`define EXCEP_Tr        5'hd        // trap
`define EXCEP_ERET      5'h1f       // eret treated as exception


// exception mask
`define EXCEP_MASK_INT      32'b00000000_00000000_00000000_00000001
`define EXCEP_MASK_AdELD    32'b00000000_00000000_00000000_00010000
`define EXCEP_MASK_AdELI    32'b00000000_00010000_00000000_00000000
`define EXCEP_MASK_AdES     32'b00000000_00000000_00000000_00100000
`define EXCEP_MASK_Sys      32'b00000000_00000000_00000001_00000000
`define EXCEP_MASK_Bp       32'b00000000_00000000_00000010_00000000
`define EXCEP_MASK_RI       32'b00000000_00000000_00000100_00000000
`define EXCEP_MASK_Ov       32'b00000000_00000000_00010000_00000000
`define EXCEP_MASK_Tr       32'b00000000_00000000_00100000_00000000
`define EXCEP_MASK_ERET     32'b10000000_00000000_00000000_00000000


// exception code
`define EXCEP_CODE_INT      5'h0        // interrupt
`define EXCEP_CODE_AdEL     5'h4        // pc fetch or lw addr error
`define EXCEP_CODE_AdES     5'h5        // sw addr 
`define EXCEP_CODE_Sys      5'h8        // syscall
`define EXCEP_CODE_Bp       5'h9        // break point
`define EXCEP_CODE_RI       5'ha        // reserved instr
`define EXCEP_CODE_Ov       5'hc        // overflow      
`define EXCEP_CODE_Tr       5'hd        // trap
`define EXCEP_CODE_ERET     5'h1f       // eret treated as exception
`define EXCEP_CODE_TLBL     5'h2        // tlbl, refill bfc00200, invalid bfc00380
`define EXCEP_CODE_TLBS     5'h3        // tlbs, refill bfc00200, invalid bfc00380
`define EXCEP_CODE_MOD      5'h1        // modified
