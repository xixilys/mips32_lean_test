`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/02/17 14:12:01
// Design Name:
// Module Name: mips_top
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


module mips_top (
    input           clk,
    input           rst,
    input  [5 :0]   ext_int,

    output          inst_req,
    output          inst_wr,
    output [1 :0]   inst_size,
    output [31:0]   inst_addr,
    output [31:0]   inst_wdata,
    output          inst_cache,
    input           inst_addr_ok,
    input           inst_data_ok,
    input  [31:0]   inst_rdata,

    output          data_req,
    output          data_wr,
    output [1 :0]   data_size,
    output [31:0]   data_addr,
    output [31:0]   data_wdata,
    output          data_cache,
    input           data_addr_ok,
    input           data_data_ok,
    input  [31:0]   data_rdata,

    (*mark_debug = "true"*)output [31:0] debug_wb_pc,
    (*mark_debug = "true"*)output [3 :0] debug_wb_rf_wen,
    (*mark_debug = "true"*)output [4 :0] debug_wb_rf_wnum,
    (*mark_debug = "true"*)output [31:0] debug_wb_rf_wdata
    );


// ---------- Functions ----------

    function [31:0] sel_2to4(input [1:0] sel,
                             input [31:0] in0, input [31:0] in1,
                             input [31:0] in2, input [31:0] in3);
    begin
        case (sel)
            2'b00 : sel_2to4 = in0;
            2'b01 : sel_2to4 = in1;
            2'b10 : sel_2to4 = in2;
            2'b11 : sel_2to4 = in3;
        endcase
    end
    endfunction

// ---------- END OF Functions ----------


// ---------- Wires ----------

// PC2IF Buffer
    // input
    (*mark_debug = "true"*)wire [31:0]     PC_next;
    wire [31:0]     PhyAddrP;
    wire            StallF;
    wire            InstUnalignedP;
    wire            ExceptionW;
    wire [31:0]     ReturnPCW;
    // output
    (*mark_debug = "true"*)wire [31:0]     PCP;
    (*mark_debug = "true"*)wire [31:0]     PCF;
    wire            AddrPendingF;
    wire            DataPendingF;
    wire            InstUnalignedF;
    wire            InExceptionF;


// IF(F): Instruction Fetch
    // imem input
    //wire            InstUnalignedF;
    // imem output
    wire [31:0]     ReadDataF;
    

// IF2ID Buffer
    // input
    wire            StallD;
    wire            FlushD;
    //wire [31:0]     ReadDataF;
    wire [31:0]     PCPlus4F;
    wire [31:0]     PCPlus8F;
    wire            NextDelaySlotD;
    //wire [31:0]     PCF;
    wire [31:0]     ExceptionTypeF;
    // output
    wire [31:0]     InstrD;
    wire [31:0]     PCPlus4D;
    wire [31:0]     PCPlus8D;
    wire            InDelaySlotD;
    (*mark_debug = "true"*)wire [31:0]     PCD;
    wire [31:0]     ExceptionTypeD_in;


// ID(D): Instruction Decode
    // cu decode input
    //wire [31:0]     InstrD;
    // cu decode output
    wire            RegWriteD;
    wire            MemToRegD;
    wire            MemWriteD;
    wire [4:0]      ALUCtrlD;
    wire [1:0]      ALUSrcD;
    wire [1:0]      RegDstD;
    wire [5:0]      BranchD;
    wire            JumpD;
    wire            JRD;
    wire            LinkD;
    wire [1:0]      HiLoWriteD;
    wire [1:0]      HiLoToRegD;
    wire            CP0WriteD;
    wire            CP0ToRegD;
    wire            LoadUnsignedD;
    wire [1:0]      MemWidthD;
    wire            ImmUnsignedD;
    wire            BadInstrD;
    wire            BreakD;
    wire            SysCallD;
    wire            EretD;
    // branch input
    wire [31:0]     BranchRsD;
    wire [31:0]     BranchRtD;
    //wire            BranchD;
    wire            CanBranchD;
    // branch output
    wire            BranchExeD;
    // regfile input
    wire [4:0]      A1D;
    wire [4:0]      A2D;
    wire [4:0]      WriteRegW;
    wire            RegWriteW;
    wire [31:0]     ResultW;
    // regfile output
    wire [31:0]     RD1D;
    wire [31:0]     RD2D;
    // next pc selector
    wire [1:0]      PCSrcD;
    wire [31:0]     PCBranchD;
    wire [31:0]     PCJumpD;


// ID2EX Buffer
    // input
    wire            StallE;
    wire            FlushE;
    //wire            RegWriteD;
    //wire            MemToRegD;
    //wire            MemWriteD;
    //wire [4:0]      ALUCtrlD;
    //wire [1:0]      ALUSrcD;
    //wire [1:0]      RegDstD;
    //wire [31:0]     RD1D;
    //wire [31:0]     RD2D;
    wire [4:0]      RsD;
    wire [4:0]      RtD;
    wire [4:0]      RdD;
    wire [31:0]     ImmD;
    //wire            LinkD;
    //wire [31:0]     PCPlus8D;
    //wire [1:0]      HiLoWriteD;
    //wire [1:0]      HiLoToRegD;
    //wire            LoadUnsignedD;
    //wire [1:0]      MemWidthD;
    //wire            CP0WriteD;
    //wire            CP0ToRegD;
    wire [4:0]      WriteCP0AddrD;
    wire [2:0]      WriteCP0SelD;
    wire [4:0]      ReadCP0AddrD;
    wire [2:0]      ReadCP0SelD;
    //wire [31:0]     PCD;
    //wire            InDelaySlotD;
    wire [31:0]     ExceptionTypeD;
    // output
    wire            RegWriteE;
    wire            MemToRegE;
    wire            MemWriteE;
    wire [4:0]      ALUCtrlE;
    wire [1:0]      ALUSrcE;
    wire [1:0]      RegDstE;
    wire [31:0]     RD1E;
    wire [31:0]     RD2E;
    wire [4:0]      RsE;
    wire [4:0]      RtE;
    wire [4:0]      RdE;
    wire [31:0]     ImmE;
    wire            LinkE;
    wire [31:0]     PCPlus8E;
    wire [1:0]      HiLoWriteE;
    wire [1:0]      HiLoToRegE;
    wire            LoadUnsignedE;
    wire [1:0]      MemWidthE;
    wire            CP0WriteE;
    wire            CP0ToRegE_in;
    wire [4:0]      WriteCP0AddrE;
    wire [2:0]      WriteCP0SelE;
    wire [4:0]      ReadCP0AddrE;
    wire [2:0]      ReadCP0SelE;
    (*mark_debug = "true"*)wire [31:0]     PCE;
    wire            InDelaySlotE;
    wire [31:0]     ExceptionTypeE_in;


// EX(E): Execute
    // alu input
    //wire [4:0]      ALUCtrlE;
    wire [31:0]     SrcAE;
    wire [31:0]     SrcBE;
    // alu output
    wire [31:0]     ALUOutE;
    wire            OverflowE;
    // muldiv input
    //wire [4:0]      ALUCtrlE;
    //wire [31:0]     SrcAE;
    //wire [31:0]     SrcBE;
    wire            DivPendingE;
    wire            CanMulDivE;
    // muldiv output
    wire [31:0]     HiResultE;
    wire [31:0]     LoResultE;
    // hilo input
    wire [1:0]      HiLoWriteW;
    wire [31:0]     HiInW;
    wire [31:0]     LoInW;
    // hilo output
    wire [31:0]     HiOutE;
    wire [31:0]     LoOutE;
    // dmemreq input
    //wire            MemToRegE;
    //wire            MemWriteE;
    //wire [1:0]      MemWidthE;
    wire [31:0]     BadVAddrE;
    wire [31:0]     PhyAddrE;
    wire [31:0]     WriteDataE;
    wire            MemAccessE;
    // dmemreq output
    wire            AddrPendingE;


// EX2MEM Buffer
    // input
    wire            FlushM;
    wire            StallM;
    //wire            RegWriteE;
    //wire            MemToRegE;
    //wire            MemWriteE;
    //wire [31:0]     ALUOutE;
    //wire [31:0]     WriteDataE;
    wire [4:0]      WriteRegE;
    //wire            LinkE;
    //wire [31:0]     PCPlus8E;
    //wire            LoadUnsignedE;
    //wire [1:0]      MemWidthE;
    //wire [31:0]     PhyAddrE;
    //wire [1:0]      HiLoWriteE;
    //wire [1:0]      HiLoToRegE;
    wire [31:0]     HiInE;
    wire [31:0]     LoInE;
    wire [31:0]     HiLoOutE;
    //wire            CP0WriteE;
    wire            CP0ToRegE;
    //wire [4:0]      WriteCP0AddrE;
    //wire [2:0]      WriteCP0SelE,
    wire [31:0]     WriteCP0HiLoDataE;
    wire [31:0]     ReadCP0DataE;
    //wire [31:0]     PCE;
    //wire            InDelaySlotE;
    wire [31:0]     ExceptionTypeE;
    // output
    wire            RegWriteM;
    wire            MemToRegM;
    wire            MemWriteM;
    wire [31:0]     ALUOutM;
    wire [31:0]     WriteDataM;
    wire [4:0]      WriteRegM;
    wire            LinkM;
    wire [31:0]     PCPlus8M;
    wire            LoadUnsignedM;
    wire [1:0]      MemWidthM;
    wire [31:0]     PhyAddrM;
    wire [1:0]      HiLoWriteM;
    wire [1:0]      HiLoToRegM;
    wire [31:0]     HiInM;
    wire [31:0]     LoInM;
    wire [31:0]     HiLoOutM;
    wire            CP0WriteM;
    wire            CP0ToRegM;
    wire [4:0]      WriteCP0AddrM;
    wire [2:0]      WriteCP0SelM;
    wire [31:0]     WriteCP0HiLoDataM;
    wire [31:0]     ReadCP0DataM;
    (*mark_debug = "true"*)wire [31:0]     PCM;
    wire            InDelaySlotM;
    wire [31:0]     BadVAddrM;
    wire [31:0]     ExceptionTypeM_in;


// MEM(M): Memory Access
    // dmem input
    //wire            MemWriteM;
    //wire [31:0]     PhyAddrM;
    //wire [31:0]     WriteDataM;
    //wire [31:0]     MemWidthM;
    //wire            LoadUnsignedM;
    // dmem output
    wire [31:0]     ReadDataM;
    wire            DataPendingM;


// MEM2WB Buffer
    // input
    wire            FlushW;
    wire            StallW;
    //wire            RegWriteM;
    //wire            MemToRegM;
    //wire [31:0]     ReadDataM;
    wire [31:0]     ResultM;
    //wire [4:0]      WriteRegM;
    //wire [1:0]      HiLoWriteM;
    //wire [31:0]     HiInM;
    //wire [31:0]     LoInM;
    //wire            CP0WriteM;
    //wire [4:0]      WriteCP0AddrM;
    //wire [2:0]      WriteCP0SelM;
    //wire [31:0]     WriteCP0HiLoDataM;
    //wire [31:0]     PCM;
    //wire            InDelaySlotM;
    //wire [31:0]     BadVAddrM;
    wire [31:0]     ExceptionTypeM;
    // output
    wire            RegWriteW_in;
    wire            MemToRegW;
    wire [31:0]     ReadDataW;
    wire [31:0]     ResultW_in;
    //wire [4:0]      WriteRegW;
    wire [1:0]      HiLoWriteW_in;
    //wire [31:0]     HiInW;
    //wire [31:0]     LoInW;
    wire            CP0WriteW_in;
    wire [4:0]      WriteCP0AddrW;
    wire [2:0]      WriteCP0SelW;
    wire [31:0]     WriteCP0HiLoDataW;
    (*mark_debug = "true"*)wire [31:0]     PCW;
    wire            InDelaySlotW;
    wire [31:0]     BadVAddrW;
    wire [31:0]     ExceptionTypeW_in;


// WB(W): Registers Write Back
    // no wire


// mmu input
    //wire [31:0]     PCP;
    //wire [31:0]     ALUOutE;
    //wire [1:0]      MemWidthE;
    //wire [31:0]     ALUOutE;

// mmu output
    //wire [31:0]     PhyAddrP;
    //wire [31:0]     PhyAddrE;
    //wire            InstUnalignedP;
    wire            DataUnalignedE;
    
// cp0 input
    //wire            CP0ToRegE;
    //wire [4:0]      ReadCP0AddrE;
    //wire [2:0]      ReadCP0SelE;
    wire            CP0WriteW;
    //wire [4:0]      WriteCP0AddrW;
    //wire [2:0]      WriteCP0SelW;
    //wire [31:0]     WriteCP0HiLoDataW;
    //wire [31:0]     PCW;
    //wire [31:0]     BadVAddrW;
    wire [31:0]     ExceptionTypeW;
    //wire            InDelaySlotW;
    
// cp0 output
    //wire [31:0]     ReadCP0DataE;
    //wire [31:0]     ReturnPCW;
    //wire            ExceptionW;

// cfu input
    //wire            BranchD;
    //wire            JumpD;
    //wire            JRD;
    //wire            CanBranchD;
    //wire            AddrPendingF;
    //wire            DataPendingF;
    //wire            DivPendingE;
    //wire            AddrPendingE;
    //wire            DataPendingM;
    //wire            InExceptionF;
    //wire [4:0]      RsD;
    //wire [4:0]      RtD;
    //wire [4:0]      RsE;
    //wire [4:0]      RtE;
    //wire [4:0]      WriteRegE;
    //wire            MemToRegE;
    //wire            RegWriteE;
    //wire [1:0]      HiLoToRegE;
    //wire            CP0ToRegE;
    //wire [4:0]      WriteRegM;
    //wire            MemToRegM;
    //wire            RegWriteM;
    //wire [1:0]      HiLoWriteM;
    //wire            CP0WriteM;
    //wire [4:0]      WriteRegW;
    //wire            RegWriteW;
    //wire [1:0]      HiLoWriteM;
    //wire            CP0WriteW;

// cfu output
    //wire            StallF;
    //wire            StallD;
    //wire            StallM;
    //wire            StallE;
    //wire            StallW;
    //wire            FlushD;
    //wire            FlushE;
    //wire            FlushM;
    //wire            FlushW;
    wire            ForwardAD;
    wire            ForwardBD;
    wire [1:0]      ForwardAE;
    wire [1:0]      ForwardBE;
    wire [1:0]      ForwardHE;


// ---------- END OF Wires ----------


// ---------- PC ----------
    
//    reg [31:0] PC_next_r;
//    assign PC_next = PC_next_r;
//    always @(negedge clk or negedge rst) begin
//        if (!rst) begin
//            PC_next_r <= 32'b0;
//        end
//        else begin
//            PC_next_r <= sel_2to4(PCSrcD, PCPlus4F, PCBranchD, PCJumpD, 32'b0);
//        end
//    end
    assign PC_next = sel_2to4(PCSrcD, PCPlus4F, PCBranchD, PCJumpD, 32'b0);

    pc2if _pc2if(
        .clk(clk), .rst(rst),
        // sram-like
        .wr             (inst_wr     ),
        .size           (inst_size   ),
        .addr           (inst_addr   ),
        .wdata          (inst_wdata  ),
        .req            (inst_req    ),
        .addr_ok        (inst_addr_ok),
        .data_ok        (inst_data_ok),
        //input
        .en             (StallF),
        .PC_next        (PC_next),
        .PhyAddrP       (PhyAddrP),
        .InstUnalignedP (InstUnalignedP),
        .ExceptionW     (ExceptionW),
        .ReturnPCW      (ReturnPCW),
        //output
        .PCP            (PCP),
        .PCF            (PCF),
        .addr_pending   (AddrPendingF),
        .data_pending   (DataPendingF),
        .InstUnalignedF (InstUnalignedF),
        .InExceptionF   (InExceptionF)
    );

// ---------- IF ----------

    imem _imem(
        .clk(clk), .rst(rst),
        // sram-like
        .req            (inst_req    ),     // input signal for pending
        .addr_ok        (inst_addr_ok),
        .data_ok        (inst_data_ok),
        .rdata          (inst_rdata  ),
        // input
        .unaligned      (InstUnalignedF),
        // output        
        .RD             (ReadDataF)
    );

    assign PCPlus4F = PCF + 4;
    assign PCPlus8F = PCF + 8;
    
    assign ExceptionTypeF = {32{InstUnalignedF}} & `EXCEP_MASK_AdELI;

    if2id _if2id(
        .clk(clk), .rst(rst),
        // input
        .en                 (StallD),
        .clr                (FlushD),
        .ReadDataF          (ReadDataF),
        .PCPlus4F           (PCPlus4F),
        .PCPlus8F           (PCPlus8F),
        .NextDelaySlotD     (NextDelaySlotD),
        .PCF                (PCF),
        .ExceptionTypeF     (ExceptionTypeF),
        // output
        .InstrD             (InstrD),
        .PCPlus4D           (PCPlus4D),
        .PCPlus8D           (PCPlus8D),
        .InDelaySlotD       (InDelaySlotD),
        .PCD                (PCD),
        .ExceptionTypeD     (ExceptionTypeD_in)
    );

// ---------- ID ----------

    cu _cu(
        .rst(rst),
        // input
        .InstrD             (InstrD),
        // output
        .RegWriteD          (RegWriteD),
        .MemToRegD          (MemToRegD),
        .MemWriteD          (MemWriteD),
        .ALUCtrlD           (ALUCtrlD),
        .ALUSrcD            (ALUSrcD),
        .RegDstD            (RegDstD),
        .BranchD            (BranchD),
        .JumpD              (JumpD),
        .JRD                (JRD),
        .LinkD              (LinkD),
        .HiLoWriteD         (HiLoWriteD),
        .HiLoToRegD         (HiLoToRegD),
        .LoadUnsignedD      (LoadUnsignedD),
        .MemWidthD          (MemWidthD),
        .CP0WriteD          (CP0WriteD),
        .CP0ToRegD          (CP0ToRegD),
        .ImmUnsigned        (ImmUnsignedD),
        .BadInstrD          (BadInstrD),
        .BreakD             (BreakD),
        .SysCallD           (SysCallD),
        .EretD              (EretD)
    );

    assign NextDelaySlotD = JumpD || BranchD;
    assign CanBranchD = ExceptionTypeD_in || ExceptionTypeE_in || ExceptionTypeM_in || ExceptionTypeW_in ? 0 : 1;
    assign BranchRsD = ForwardAD ? ResultM : RD1D;
    assign BranchRtD = ForwardBD ? ResultM : RD2D;
    br _br(
        .clk(clk), .rst(rst),
        // input
        .en             (CanBranchD),
        .rs             (BranchRsD),
        .rt             (BranchRtD),
        .branch         (BranchD),
        // output
        .exe            (BranchExeD)
    );

    assign A1D = InstrD[25:21];
    assign A2D = InstrD[20:16];
    regfile _regfile(
        .clk(clk), .rst(rst),
        // input
        .A1             (A1D),
        .A2             (A2D),
        .A3             (WriteRegW),
        .WD3            (ResultW),
        .WE3            (RegWriteW),
        // output
        .RD1            (RD1D),
        .RD2            (RD2D)
    );

//    reg [1:0] PCSrcD_r;
//    reg [31:0] PCBranchD_r;
//    reg [31:0] PCJumpD_r;
//    assign PCSrcD = PCSrcD_r;
//    assign PCBranchD = PCBranchD_r;
//    assign PCJumpD = PCJumpD_r;
//    always @(negedge clk or negedge rst) begin
//        if (!rst) begin
//            PCSrcD_r <= 2'b0;
//            PCBranchD_r <= 32'b0;
//            PCJumpD_r <= 32'b0;
//        end
//        else begin
//            PCSrcD_r <= {JumpD, BranchExeD};
//            PCBranchD_r <= {{14{InstrD[15]}}, InstrD[15:0], 2'b0} + PCPlus4D;
//            PCJumpD_r <= JRD ? BranchRsD : {PCPlus4D[31:28], InstrD[25:0], 2'b0};
//        end
//    end
    assign PCSrcD = {JumpD, BranchExeD};
    assign PCBranchD = {{14{InstrD[15]}}, InstrD[15:0], 2'b0} + PCPlus4D;
    assign PCJumpD = JRD ? BranchRsD : {PCPlus4D[31:28], InstrD[25:0], 2'b0};

    assign RsD = InstrD[25:21];
    assign RtD = InstrD[20:16];
    assign RdD = InstrD[15:11];
    assign ImmD = ImmUnsignedD ? {16'b0, InstrD[15:0]} : {{16{InstrD[15]}}, InstrD[15:0]};
    assign WriteCP0AddrD = InstrD[15:11];
    assign WriteCP0SelD = InstrD[2:0];
    assign ReadCP0AddrD = InstrD[15:11];
    assign ReadCP0SelD = InstrD[2:0];

    assign ExceptionTypeD = ExceptionTypeD_in ? ExceptionTypeD_in :
                            ({32{BadInstrD}} & `EXCEP_MASK_RI)  |
                            ({32{SysCallD}}  & `EXCEP_MASK_Sys) |
                            ({32{BreakD}}    & `EXCEP_MASK_Bp)  |
                            ({32{EretD}}     & `EXCEP_MASK_ERET);

    id2ex _id2ex(
        .clk(clk), .rst(rst),
        // input
        .clr                (FlushE),
        .en                 (StallE),
        .RegWriteD          (RegWriteD),
        .MemToRegD          (MemToRegD),
        .MemWriteD          (MemWriteD),
        .ALUCtrlD           (ALUCtrlD),
        .ALUSrcD            (ALUSrcD),
        .RegDstD            (RegDstD),
        .RD1D               (RD1D),
        .RD2D               (RD2D),
        .RsD                (RsD),
        .RtD                (RtD),
        .RdD                (RdD),
        .ImmD               (ImmD),
        .LinkD              (LinkD),
        .PCPlus8D           (PCPlus8D),
        .LoadUnsignedD      (LoadUnsignedD),
        .MemWidthD          (MemWidthD),
        .HiLoWriteD         (HiLoWriteD),
        .HiLoToRegD         (HiLoToRegD),
        .CP0WriteD          (CP0WriteD),
        .CP0ToRegD          (CP0ToRegD),
        .WriteCP0AddrD      (WriteCP0AddrD),
        .WriteCP0SelD       (WriteCP0SelD),
        .ReadCP0AddrD       (ReadCP0AddrD),
        .ReadCP0SelD        (ReadCP0SelD),
        .PCD                (PCD),
        .InDelaySlotD       (InDelaySlotD),
        .ExceptionTypeD     (ExceptionTypeD),
        // output
        .RegWriteE          (RegWriteE),
        .MemToRegE          (MemToRegE),
        .MemWriteE          (MemWriteE),
        .ALUCtrlE           (ALUCtrlE),
        .ALUSrcE            (ALUSrcE),
        .RegDstE            (RegDstE),
        .RD1E               (RD1E),
        .RD2E               (RD2E),
        .RsE                (RsE),
        .RtE                (RtE),
        .RdE                (RdE),
        .ImmE               (ImmE),
        .LinkE              (LinkE),
        .PCPlus8E           (PCPlus8E),
        .LoadUnsignedE      (LoadUnsignedE),
        .MemWidthE          (MemWidthE),
        .HiLoWriteE         (HiLoWriteE),
        .HiLoToRegE         (HiLoToRegE),
        .CP0WriteE          (CP0WriteE),
        .CP0ToRegE          (CP0ToRegE_in),
        .WriteCP0AddrE      (WriteCP0AddrE),
        .WriteCP0SelE       (WriteCP0SelE),
        .ReadCP0AddrE       (ReadCP0AddrE),
        .ReadCP0SelE        (ReadCP0SelE),
        .PCE                (PCE),
        .InDelaySlotE       (InDelaySlotE),
        .ExceptionTypeE     (ExceptionTypeE_in)
    );

// ---------- EX ----------

//    wire [31:0] RD1ForwardE = sel_2to4(ForwardAE, RD1E, ResultW, ResultM, 32'b0);
//    wire [31:0] RD2ForwardE = sel_2to4(ForwardBE, RD2E, ResultW, ResultM, 32'b0);
    
    wire [31:0] RD1ForwardE_p = sel_2to4(ForwardAE, RD1E, ResultW, ResultM, 32'b0);
    wire [31:0] RD2ForwardE_p = sel_2to4(ForwardBE, RD2E, ResultW, ResultM, 32'b0);
    reg [31:0] RD1ForwardE_r;
    reg [31:0] RD2ForwardE_r;
    reg ForwardLock1E, ForwardLock2E;
    wire [31:0] RD1ForwardE = ForwardLock1E ? RD1ForwardE_r : RD1ForwardE_p;
    wire [31:0] RD2ForwardE = ForwardLock2E ? RD2ForwardE_r : RD2ForwardE_p;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RD1ForwardE_r <= 32'h0;
            RD2ForwardE_r <= 32'h0;
            ForwardLock1E <= 0;
            ForwardLock2E <= 0;
        end
        else begin
            if (StallE) begin
                ForwardLock1E <= 0;
                ForwardLock2E <= 0;
            end
            else begin
                if (ForwardAE == 2'b01 && !ForwardLock1E) begin
                    ForwardLock1E <= 1;
                    RD1ForwardE_r <= RD1ForwardE_p;
                end
                if (ForwardBE == 2'b01 && !ForwardLock2E) begin
                    ForwardLock2E <= 1;
                    RD2ForwardE_r <= RD2ForwardE_p;
                end
            end
        end
    end
    
    assign WriteRegE = sel_2to4(RegDstE, RtE, RdE, 5'b11111, 5'b00000);
    assign WriteDataE = RD2ForwardE;
    assign WriteCP0HiLoDataE = HiLoWriteE ? RD1ForwardE : (
                               CP0WriteE ? RD2ForwardE : 32'b0);
//    assign CP0ToRegE = ExceptionTypeE_in || ExceptionTypeM_in || ExceptionTypeW_in ? 0 : CP0ToRegE_in;
    assign CP0ToRegE = ExceptionTypeE_in ? 0 : CP0ToRegE_in;

    assign SrcAE = ALUSrcE[1] ? {27'b0, ImmE[10:6]} : RD1ForwardE;
    assign SrcBE = ALUSrcE[0] ? ImmE : WriteDataE;
    alu _alu(
        .rst(rst),
        // input
        .ctrl           (ALUCtrlE),
        .in1            (SrcAE),
        .in2            (SrcBE),
        // output
        .result         (ALUOutE),
        .overflow       (OverflowE)
    );
    //assign CanMulDivE = ExceptionTypeE_in || ExceptionTypeM_in || ExceptionTypeW_in ? 0 : 1;
    assign CanMulDivE = ExceptionTypeE_in ? 0 : 1;
    muldiv _muldiv(
        .clk(clk), .rst(rst),
        // input
        .en             (CanMulDivE),
        .ctrl           (ALUCtrlE),
        .in1            (SrcAE),
        .in2            (SrcBE),
        // output
        .hi             (HiResultE),
        .lo             (LoResultE),
        .pending        (DivPendingE)
    );

    assign BadVAddrE = DataUnalignedE ? ALUOutE : PCE;
    assign MemAccessE = (ExceptionTypeE_in || ExceptionTypeM_in || ExceptionTypeW_in) ? 0 
                      : (!DataUnalignedE) && StallE && (MemWriteE || MemToRegE);
    dmemreq _dmemreq(
        .clk(clk), .rst(rst),
        // sram-like
        .req            (data_req    ),
        .wr             (data_wr     ),
        .size           (data_size   ),
        .addr           (data_addr   ),
        .wdata          (data_wdata  ),
        .addr_ok        (data_addr_ok),
        // input
        .en             (MemAccessE),
        .MemWriteE      (MemWriteE),
        .MemToRegE      (MemToRegE),
        .MemWidthE      (MemWidthE),
        .PhyAddrE       (PhyAddrE),
        .WriteDataE     (WriteDataE),
        // output
        .addr_pending   (AddrPendingE)
    );

    assign HiInE = HiLoWriteE == 2'b10 ? WriteCP0HiLoDataE : HiResultE;
    assign LoInE = HiLoWriteE == 2'b01 ? WriteCP0HiLoDataE : LoResultE;
    hilo _hilo(
        .clk(clk), .rst(rst),
        // input
        .we             (HiLoWriteW),
        .hi_i           (HiInW),
        .lo_i           (LoInW),
        // output
        .hi_o           (HiOutE),
        .lo_o           (LoOutE)
    );
    assign HiLoOutE = sel_2to4(HiLoToRegE,
                               32'b0,
                               sel_2to4(ForwardHE, LoOutE, LoInW, LoInM, 32'b0),
                               sel_2to4(ForwardHE, HiOutE, HiInW, HiInM, 32'b0),
                               32'b0);
                               
    assign ExceptionTypeE = ExceptionTypeE_in ? ExceptionTypeE_in :
                            ({32{DataUnalignedE && MemToRegE}} & `EXCEP_MASK_AdELD) |
                            ({32{DataUnalignedE && MemWriteE}} & `EXCEP_MASK_AdES)  |
                            ({32{OverflowE}}                   & `EXCEP_MASK_Ov);

    ex2mem _ex2mem(
        .clk(clk), .rst(rst),
        // input
        .clr                (FlushM),
        .en                 (StallM),
        .RegWriteE          (RegWriteE),
        .MemToRegE          (MemToRegE),
        .MemWriteE          (MemWriteE),
        .ALUOutE            (ALUOutE),
        .WriteDataE         (WriteDataE),
        .WriteRegE          (WriteRegE),
        .LoadUnsignedE      (LoadUnsignedE),
        .MemWidthE          (MemWidthE),
        .PhyAddrE           (PhyAddrE),
        .LinkE              (LinkE),
        .PCPlus8E           (PCPlus8E),
        .HiLoWriteE         (HiLoWriteE),
        .HiLoToRegE         (HiLoToRegE),
        .HiLoOutE           (HiLoOutE),
        .HiInE              (HiInE),
        .LoInE              (LoInE),
        .CP0WriteE          (CP0WriteE),
        .CP0ToRegE          (CP0ToRegE),
        .WriteCP0AddrE      (WriteCP0AddrE),
        .WriteCP0SelE       (WriteCP0SelE),
        .WriteCP0HiLoDataE  (WriteCP0HiLoDataE),
        .ReadCP0DataE       (ReadCP0DataE),
        .PCE                (PCE),
        .InDelaySlotE       (InDelaySlotE),
        .BadVAddrE          (BadVAddrE),
        .ExceptionTypeE     (ExceptionTypeE),
        // output
        .RegWriteM          (RegWriteM),
        .MemToRegM          (MemToRegM),
        .MemWriteM          (MemWriteM),
        .ALUOutM            (ALUOutM),
        .WriteDataM         (WriteDataM),
        .WriteRegM          (WriteRegM),
        .LinkM              (LinkM),
        .PCPlus8M           (PCPlus8M),
        .LoadUnsignedM      (LoadUnsignedM),
        .MemWidthM          (MemWidthM),
        .PhyAddrM           (PhyAddrM),
        .HiLoWriteM         (HiLoWriteM),
        .HiLoToRegM         (HiLoToRegM),
        .HiLoOutM           (HiLoOutM),
        .HiInM              (HiInM),
        .LoInM              (LoInM),
        .CP0WriteM          (CP0WriteM),
        .CP0ToRegM          (CP0ToRegM),
        .WriteCP0AddrM      (WriteCP0AddrM),
        .WriteCP0SelM       (WriteCP0SelM),
        .WriteCP0HiLoDataM  (WriteCP0HiLoDataM),
        .ReadCP0DataM       (ReadCP0DataM),
        .PCM                (PCM),
        .InDelaySlotM       (InDelaySlotM),
        .BadVAddrM          (BadVAddrM),
        .ExceptionTypeM     (ExceptionTypeM_in)
    );

// ---------- MEM ----------

    assign ResultM = LinkM ? PCPlus8M : (
                     CP0ToRegM ? ReadCP0DataM : (
                     HiLoToRegM ? HiLoOutM : (
                     ALUOutM)));
    
    wire SignedM = ~LoadUnsignedM;
    
    dmem _dmem(
        .clk(clk), .rst(rst),
        // sram-like
        .req            (data_req    ),     // input signal for pending
        .addr_ok        (data_addr_ok),
        .data_ok        (data_data_ok),
        .rdata          (data_rdata  ),
        // input
        .WE             (MemWriteM),
        .A              (PhyAddrM),
        //.WD             (WriteDataM),
        .WIDTH          (MemWidthM),
        .SIGN           (SignedM),
        // output
        .RD             (ReadDataM),
        .data_pending   (DataPendingM)
    );

    assign ExceptionTypeM = ExceptionTypeM_in;
    mem2wb _mem2wb(
        .clk(clk), .rst(rst),
        // input
        .clr                (FlushW),
        .en                 (StallW),
        .RegWriteM          (RegWriteM),
        .MemToRegM          (MemToRegM),
        .ReadDataM          (ReadDataM),
        .ResultM            (ResultM),
        .WriteRegM          (WriteRegM),
        .HiLoWriteM         (HiLoWriteM),
        .HiInM              (HiInM),
        .LoInM              (LoInM),
        .CP0WriteM          (CP0WriteM),
        .WriteCP0AddrM      (WriteCP0AddrM),
        .WriteCP0SelM       (WriteCP0SelM),
        .WriteCP0HiLoDataM  (WriteCP0HiLoDataM),
        .PCM                (PCM),
        .InDelaySlotM       (InDelaySlotM),
        .BadVAddrM          (BadVAddrM),
        .ExceptionTypeM     (ExceptionTypeM),
        // output
        .RegWriteW          (RegWriteW_in),
        .MemToRegW          (MemToRegW),
        .ReadDataW          (ReadDataW),
        .ResultW            (ResultW_in),
        .WriteRegW          (WriteRegW),
        .HiLoWriteW         (HiLoWriteW_in),
        .HiInW              (HiInW),
        .LoInW              (LoInW),
        .CP0WriteW          (CP0WriteW_in),
        .WriteCP0AddrW      (WriteCP0AddrW),
        .WriteCP0SelW       (WriteCP0SelW),
        .WriteCP0HiLoDataW  (WriteCP0HiLoDataW),
        .PCW                (PCW),
        .InDelaySlotW       (InDelaySlotW),
        .BadVAddrW          (BadVAddrW),
        .ExceptionTypeW     (ExceptionTypeW_in)
    );

// ---------- WB ----------

    assign ResultW = MemToRegW ? ReadDataW : ResultW_in;
//    assign ResultW = ResultW_in;
    assign RegWriteW = ExceptionTypeW_in ? 1'b0 : RegWriteW_in;
    assign HiLoWriteW = ExceptionTypeW_in ? 2'b0 : HiLoWriteW_in;
    assign CP0WriteW = ExceptionTypeW_in ? 1'b0 : CP0WriteW_in;

    //assign debug_wb_pc = PCW;

    reg [31:0] debug_wb_pc_r;
    assign debug_wb_pc = debug_wb_pc_r;
    always @(rst or PCW) begin
        if (!rst) begin
            debug_wb_pc_r <= 32'hbfc00000;
        end
        else if (PCW != 32'b0) begin
            debug_wb_pc_r <= PCW;
        end
    end
    
    assign debug_wb_rf_wen = WriteRegW ? {4{RegWriteW}} : 4'b0;
    assign debug_wb_rf_wnum = WriteRegW;
    assign debug_wb_rf_wdata = ResultW;
    
    assign ExceptionTypeW = ExceptionTypeW_in;

// ---------- OTHER ----------
    
    reg DisableCache;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            DisableCache <= 0;
        end
        else if (PCF == 32'hbfc00050 && ReadDataF == 32'h3c1dbfc1) begin
            DisableCache <= 1;
        end
    end    
    
    wire TransIAddrP = StallF;
    wire TransDAddrE = (ExceptionTypeE_in || ExceptionTypeM_in || ExceptionTypeW_in) ? 0 
                      : StallE && (MemWriteE || MemToRegE);
    wire ClearDAddrE = 0;//ExceptionTypeE ? 1 : 0;
    wire inst_cache_in, data_cache_in;
    assign inst_cache = !DisableCache && inst_cache_in;
    assign data_cache = !DisableCache && data_cache_in;
    mmu _mmu(
        .clk(clk), .rst(rst),
        // input
        .i_vaddr        (PCP),
        .i_en           (TransIAddrP),
        .d_vaddr        (ALUOutE),
        .d_width        (MemWidthE),
        .d_en           (TransDAddrE),
        .d_clr          (ClearDAddrE),
        // output
        .i_paddr        (PhyAddrP),
        .i_unaligned    (InstUnalignedP),
        .i_cached       (inst_cache_in),
        .d_paddr        (PhyAddrE),
        .d_unaligned    (DataUnalignedE),
        .d_cached       (data_cache_in)
    );

    cp0 _cp0(
        .clk(clk), .rst(rst),
        // input
        .cp0_read_addr      (ReadCP0AddrE),
        .cp0_read_sel       (ReadCP0SelE),
        .cp0_write_addr     (WriteCP0AddrW),
        .cp0_write_sel      (WriteCP0SelW),
        .cp0_write_data     (WriteCP0HiLoDataW),
        .cp0_write_en       (CP0WriteW),
        .int_i              (ext_int),
        .pc                 (PCW),
        .mem_bad_vaddr      (BadVAddrW),
        .exception_type_i   (ExceptionTypeW),
        .in_delayslot       (InDelaySlotW),
        // output
        .cp0_read_data      (ReadCP0DataE),
        .return_pc          (ReturnPCW),
        .exception          (ExceptionW)
    );

    cfu _cfu(
        .clk(clk), .rst(rst),
        // input
        .AddrPendingF       (AddrPendingF),
        .DataPendingF       (DataPendingF),
        .BranchD            (BranchD),
        .JumpD              (JumpD),
        .JRD                (JRD),
        .CanBranchD         (CanBranchD),
        .DivPendingE        (DivPendingE),
        .AddrPendingE       (AddrPendingE),
        .DataPendingM       (DataPendingM),
        .InExceptionF       (InExceptionF),
        .RsD                (RsD),
        .RtD                (RtD),
        .RsE                (RsE),
        .RtE                (RtE),
        .WriteRegE          (WriteRegE),
        .MemToRegE          (MemToRegE),
        .RegWriteE          (RegWriteE),
        .HiLoToRegE         (HiLoToRegE),
        .CP0ToRegE          (CP0ToRegE),
        .WriteRegM          (WriteRegM),
        .MemToRegM          (MemToRegM),
        .RegWriteM          (RegWriteM),
        .HiLoWriteM         (HiLoWriteM),
        .CP0WriteM          (CP0WriteM),
        .WriteRegW          (WriteRegW),
        .RegWriteW          (RegWriteW),
        .HiLoWriteW         (HiLoWriteW),
        .CP0WriteW          (CP0WriteW),
        // output
        .StallF             (StallF),
        .StallD             (StallD),
        .StallE             (StallE),
        .StallM             (StallM),
        .StallW             (StallW),
        .FlushD             (FlushD),
        .FlushE             (FlushE),
        .FlushM             (FlushM),
        .FlushW             (FlushW),
        .ForwardAD          (ForwardAD),
        .ForwardBD          (ForwardBD),
        .ForwardAE          (ForwardAE),
        .ForwardBE          (ForwardBE),
        .ForwardHE          (ForwardHE)
    );


endmodule
