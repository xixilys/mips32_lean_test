`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 21:13:55
// Design Name: 
// Module Name: cu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "macros.vh"

module cu(
    input           rst,

    input  [31:0]   InstrD,
    
    output          RegWriteD,
    output          MemToRegD,
    output          MemWriteD,
    output [4:0]    ALUCtrlD,
    output [1:0]    ALUSrcD,
    output [1:0]    RegDstD,
    output          ImmUnsigned,
    output [5:0]    BranchD,
    output          JumpD,
    output          JRD,
    output          LinkD,
    output [1:0]    HiLoWriteD,
    output [1:0]    HiLoToRegD,
    output          CP0WriteD,
    output          CP0ToRegD,
    output          LoadUnsignedD,
    output [1:0]    MemWidthD,
    output          BadInstrD,
    output          BreakD,
    output          SysCallD,
    output          EretD
    );
    
    
    wire [5:0] OpD = InstrD[31:26];
    wire [5:0] FunctD = InstrD[5:0];
    wire [4:0] RsD = InstrD[25:21];
    wire [4:0] RtD = InstrD[20:16];
    wire [6:0] inst_id = get_inst_id(OpD, FunctD, RsD, RtD);
    function [6:0] get_inst_id(input [5:0] opcode, input [5:0] func, input [4:0] rs, input [4:0] rt);
    begin
        case (opcode)
            `OP_ADDI  : get_inst_id = `ID_ADDI;
            `OP_ANDI  : get_inst_id = `ID_ANDI;
            `OP_ADDIU : get_inst_id = `ID_ADDIU;
            `OP_SLTI  : get_inst_id = `ID_SLTI;
            `OP_SLTIU : get_inst_id = `ID_SLTIU;
            `OP_LUI   : get_inst_id = `ID_LUI;
            `OP_ORI   : get_inst_id = `ID_ORI;
            `OP_XORI  : get_inst_id = `ID_XORI;
            `OP_BEQ   : get_inst_id = `ID_BEQ;
            `OP_BNE   : get_inst_id = `ID_BNE;
            `OP_BGTZ  : get_inst_id = `ID_BGTZ;
            `OP_BLEZ  : get_inst_id = `ID_BLEZ;
            `OP_J     : get_inst_id = `ID_J;
            `OP_JAL   : get_inst_id = `ID_JAL;
            `OP_LB    : get_inst_id = `ID_LB;
            `OP_LBU   : get_inst_id = `ID_LBU;
            `OP_LH    : get_inst_id = `ID_LH;
            `OP_LHU   : get_inst_id = `ID_LHU;
            `OP_LW    : get_inst_id = `ID_LW;
            `OP_SB    : get_inst_id = `ID_SB;
            `OP_SH    : get_inst_id = `ID_SH;
            `OP_SW    : get_inst_id = `ID_SW;
            `OP_SPECIAL : begin
                case (func)
                    `FUNC_SUB       : get_inst_id = `ID_SUB;
                    `FUNC_AND       : get_inst_id = `ID_AND;
                    `FUNC_OR        : get_inst_id = `ID_OR;
                    `FUNC_SLT       : get_inst_id = `ID_SLT;
                    `FUNC_SLL       : get_inst_id = `ID_SLL;
                    `FUNC_SLTU      : get_inst_id = `ID_SLTU;
                    `FUNC_XOR       : get_inst_id = `ID_XOR;
                    `FUNC_ADD       : get_inst_id = `ID_ADD;
                    `FUNC_ADDU      : get_inst_id = `ID_ADDU;
                    `FUNC_SUBU      : get_inst_id = `ID_SUBU;              
                    `FUNC_DIV       : get_inst_id = `ID_DIV;
                    `FUNC_DIVU      : get_inst_id = `ID_DIVU;
                    `FUNC_MULT      : get_inst_id = `ID_MULT;
                    `FUNC_MULTU     : get_inst_id = `ID_MULTU;
                    `FUNC_NOR       : get_inst_id = `ID_NOR;
                    `FUNC_SLLV      : get_inst_id = `ID_SLLV;
                    `FUNC_SRA       : get_inst_id = `ID_SRA;
                    `FUNC_SRAV      : get_inst_id = `ID_SRAV;
                    `FUNC_SRL       : get_inst_id = `ID_SRL;
                    `FUNC_SRLV      : get_inst_id = `ID_SRLV;
                    `FUNC_JR        : get_inst_id = `ID_JR;
                    `FUNC_JALR      : get_inst_id = `ID_JALR;
                    `FUNC_MFHI      : get_inst_id = `ID_MFHI;
                    `FUNC_MFLO      : get_inst_id = `ID_MFLO;
                    `FUNC_MTHI      : get_inst_id = `ID_MTHI;
                    `FUNC_MTLO      : get_inst_id = `ID_MTLO;
                    `FUNC_BREAK     : get_inst_id = `ID_BREAK;
                    `FUNC_SYSCALL   : get_inst_id = `ID_SYSCALL;
                    default         : get_inst_id = `ID_NULL;
                endcase
            end
            
            `OP_BRANCH : begin
                case (rt)
                    `RT_BGEZ    : get_inst_id = `ID_BGEZ;
                    `RT_BGEZAL  : get_inst_id = `ID_BGEZAL;
                    `RT_BLTZ    : get_inst_id = `ID_BLTZ;
                    `RT_BLTZAL  : get_inst_id = `ID_BLTZAL;
                    default     : get_inst_id = `ID_NULL;
                endcase
            end
            
            `OP_PRIVILEGE : begin
                case (rs)
                    `RS_ERET    : get_inst_id = `ID_ERET;
                    `RS_MFC0    : get_inst_id = `ID_MFC0;
                    `RS_MTC0    : get_inst_id = `ID_MTC0;
                    default     : get_inst_id = `ID_NULL;
                endcase
            end
            
            default     : get_inst_id = `ID_NULL;
        endcase
    end
    endfunction
    
    assign BadInstrD = inst_id == `ID_NULL;
    assign BreakD    = inst_id == `ID_BREAK;
    assign SysCallD  = inst_id == `ID_SYSCALL;
    assign EretD     = inst_id == `ID_ERET;
    
    assign {RegWriteD, RegDstD, ALUSrcD, ImmUnsigned, BranchD, JumpD, JRD, LinkD, 
            HiLoWriteD, HiLoToRegD, CP0WriteD, CP0ToRegD, 
            MemWriteD, MemToRegD, LoadUnsignedD, MemWidthD} = rst ? get_controls(inst_id) : `CTRL_NULL;
    function [25:0] get_controls(input [6:0] inst_id);
    begin
        case (inst_id)
            `ID_NULL    : get_controls = `CTRL_NULL;
            `ID_ADDI    : get_controls = `CTRL_ITYPE;
            `ID_SUB     : get_controls = `CTRL_RTYPE;
            `ID_AND     : get_controls = `CTRL_RTYPE;
            `ID_OR      : get_controls = `CTRL_RTYPE;
            `ID_XOR     : get_controls = `CTRL_RTYPE;
            `ID_SLT     : get_controls = `CTRL_RTYPE;
            `ID_SLL     : get_controls = `CTRL_RTYPES;
            `ID_ANDI    : get_controls = `CTRL_ITYPEU;
            `ID_ADD     : get_controls = `CTRL_RTYPE;
            `ID_ADDU    : get_controls = `CTRL_RTYPE;
            `ID_ADDIU   : get_controls = `CTRL_ITYPE;
            `ID_SUBU    : get_controls = `CTRL_RTYPE;
            `ID_SLTI    : get_controls = `CTRL_ITYPE;
            `ID_SLTU    : get_controls = `CTRL_RTYPE;
            `ID_SLTIU   : get_controls = `CTRL_ITYPE;
            `ID_DIV     : get_controls = `CTRL_DIV;
            `ID_DIVU    : get_controls = `CTRL_DIV;
            `ID_MULT    : get_controls = `CTRL_MULT;
            `ID_MULTU   : get_controls = `CTRL_MULT;
            `ID_LUI     : get_controls = `CTRL_ITYPE;
            `ID_NOR     : get_controls = `CTRL_RTYPE;
            `ID_ORI     : get_controls = `CTRL_ITYPEU;
            `ID_XORI    : get_controls = `CTRL_ITYPEU;
            `ID_SLLV    : get_controls = `CTRL_RTYPE;
            `ID_SRA     : get_controls = `CTRL_RTYPES;
            `ID_SRAV    : get_controls = `CTRL_RTYPE;
            `ID_SRL     : get_controls = `CTRL_RTYPES;
            `ID_SRLV    : get_controls = `CTRL_RTYPE;
            `ID_BEQ     : get_controls = `CTRL_BEQ;
            `ID_BNE     : get_controls = `CTRL_BNE;
            `ID_BGEZ    : get_controls = `CTRL_BGEZ;
            `ID_BGEZAL  : get_controls = `CTRL_BGEZAL;
            `ID_BGTZ    : get_controls = `CTRL_BGTZ;
            `ID_BLEZ    : get_controls = `CTRL_BLEZ;
            `ID_BLTZ    : get_controls = `CTRL_BLTZ;
            `ID_BLTZAL  : get_controls = `CTRL_BLTZAL;
            `ID_J       : get_controls = `CTRL_J;
            `ID_JAL     : get_controls = `CTRL_JAL;
            `ID_JR      : get_controls = `CTRL_JR;
            `ID_JALR    : get_controls = `CTRL_JALR;
            `ID_MFHI    : get_controls = `CTRL_MFHI;
            `ID_MFLO    : get_controls = `CTRL_MFLO;
            `ID_MTHI    : get_controls = `CTRL_MTHI;
            `ID_MTLO    : get_controls = `CTRL_MTLO;
            `ID_BREAK   : get_controls = `CTRL_BREAK;
            `ID_SYSCALL : get_controls = `CTRL_SYSCALL;
            `ID_LB      : get_controls = `CTRL_LB;
            `ID_LBU     : get_controls = `CTRL_LBU;
            `ID_LH      : get_controls = `CTRL_LH;
            `ID_LHU     : get_controls = `CTRL_LHU;
            `ID_LW      : get_controls = `CTRL_LW;
            `ID_SB      : get_controls = `CTRL_SB;
            `ID_SH      : get_controls = `CTRL_SH;
            `ID_SW      : get_controls = `CTRL_SW;
            `ID_ERET    : get_controls = `CTRL_ERET;
            `ID_MFC0    : get_controls = `CTRL_MFC0;
            `ID_MTC0    : get_controls = `CTRL_MTC0;
            default     : get_controls = `CTRL_NULL;
        endcase
    end
    endfunction 
    
    assign ALUCtrlD = rst ? get_alu_op(inst_id) : `ALU_NULL;
    function [4:0] get_alu_op(input [6:0] inst_id);
    begin
        case (inst_id)
            `ID_NULL    : get_alu_op = `ALU_NULL;
            `ID_ADD     : get_alu_op = `ALU_ADDE;
            `ID_ADDI    : get_alu_op = `ALU_ADDE;
            `ID_ADDU    : get_alu_op = `ALU_ADDU;
            `ID_ADDIU   : get_alu_op = `ALU_ADDU;
            `ID_SUB     : get_alu_op = `ALU_SUBE;
            `ID_SUBU    : get_alu_op = `ALU_SUBU;
            `ID_SLT     : get_alu_op = `ALU_SLT;
            `ID_SLTI    : get_alu_op = `ALU_SLT;
            `ID_SLTU    : get_alu_op = `ALU_SLTU;
            `ID_SLTIU   : get_alu_op = `ALU_SLTU;
            `ID_DIV     : get_alu_op = `ALU_DIV;
            `ID_DIVU    : get_alu_op = `ALU_DIVU;
            `ID_MULT    : get_alu_op = `ALU_MULT;
            `ID_MULTU   : get_alu_op = `ALU_MULTU;
            `ID_AND     : get_alu_op = `ALU_AND;
            `ID_ANDI    : get_alu_op = `ALU_AND;
            `ID_LUI     : get_alu_op = `ALU_LUI;
            `ID_NOR     : get_alu_op = `ALU_NOR;
            `ID_OR      : get_alu_op = `ALU_OR;
            `ID_ORI     : get_alu_op = `ALU_OR;
            `ID_XOR     : get_alu_op = `ALU_XOR;
            `ID_XORI    : get_alu_op = `ALU_XOR;
            `ID_SLL     : get_alu_op = `ALU_SLL;
            `ID_SLLV    : get_alu_op = `ALU_SLL;
            `ID_SRA     : get_alu_op = `ALU_SRA;
            `ID_SRAV    : get_alu_op = `ALU_SRA;
            `ID_SRL     : get_alu_op = `ALU_SRL;
            `ID_SRLV    : get_alu_op = `ALU_SRL;
            `ID_BEQ     : get_alu_op = `ALU_SUB;
            `ID_BNE     : get_alu_op = `ALU_SUB;
            `ID_BGEZ    : get_alu_op = `ALU_SUB;
            `ID_BGEZAL  : get_alu_op = `ALU_SUB;
            `ID_BGTZ    : get_alu_op = `ALU_SUB;
            `ID_BLEZ    : get_alu_op = `ALU_SUB;
            `ID_BLTZ    : get_alu_op = `ALU_SUB;
            `ID_BLTZAL  : get_alu_op = `ALU_SUB;
            `ID_J       : get_alu_op = `ALU_NULL;
            `ID_JAL     : get_alu_op = `ALU_NULL;
            `ID_JR      : get_alu_op = `ALU_NULL;
            `ID_JALR    : get_alu_op = `ALU_NULL;
            `ID_MFHI    : get_alu_op = `ALU_NULL;
            `ID_MFLO    : get_alu_op = `ALU_NULL;
            `ID_MTHI    : get_alu_op = `ALU_NULL;
            `ID_MTLO    : get_alu_op = `ALU_NULL;
            `ID_BREAK   : get_alu_op = `ALU_NULL;
            `ID_SYSCALL : get_alu_op = `ALU_NULL;
            `ID_LB      : get_alu_op = `ALU_ADD;
            `ID_LBU     : get_alu_op = `ALU_ADD;
            `ID_LH      : get_alu_op = `ALU_ADD;
            `ID_LHU     : get_alu_op = `ALU_ADD;
            `ID_LW      : get_alu_op = `ALU_ADD;
            `ID_SB      : get_alu_op = `ALU_ADD;
            `ID_SH      : get_alu_op = `ALU_ADD;
            `ID_SW      : get_alu_op = `ALU_ADD;
            `ID_ERET    : get_alu_op = `ALU_NULL;
            `ID_MFC0    : get_alu_op = `ALU_NULL;
            `ID_MTC0    : get_alu_op = `ALU_NULL;
            default     : get_alu_op = `ALU_NULL;
        endcase
    end
    endfunction
    
endmodule
