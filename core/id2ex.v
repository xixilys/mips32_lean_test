`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 12:37:06
// Design Name: 
// Module Name: id2ex
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


module id2ex(
    input               clk,
    input               rst,
    input               en,
    input               clr,
    
    input               RegWriteD,
    input               MemToRegD,
    input               MemWriteD,
    input [4:0]         ALUCtrlD,
    input [1:0]         ALUSrcD,
    input [1:0]         RegDstD,
    input [31:0]        RD1D,
    input [31:0]        RD2D,
    input [4:0]         RsD,
    input [4:0]         RtD,
    input [4:0]         RdD,
    input [31:0]        ImmD,
    input               LinkD,
    input [31:0]        PCPlus8D,
    input               LoadUnsignedD,
    input [1:0]         MemWidthD, 
    input [1:0]         HiLoWriteD,
    input [1:0]         HiLoToRegD,
    input               CP0WriteD,
    input               CP0ToRegD,
    input [4:0]         WriteCP0AddrD,
    input [2:0]         WriteCP0SelD,
    input [4:0]         ReadCP0AddrD,
    input [2:0]         ReadCP0SelD,
    input [31:0]        PCD,
    input               InDelaySlotD,
    input [31:0]        ExceptionTypeD,
    
    output reg          RegWriteE,
    output reg          MemToRegE,
    output reg          MemWriteE,
    output reg [4:0]    ALUCtrlE,
    output reg [1:0]    ALUSrcE,
    output reg [1:0]    RegDstE,
    output reg [31:0]   RD1E,
    output reg [31:0]   RD2E,
    output reg [4:0]    RsE,
    output reg [4:0]    RtE,
    output reg [4:0]    RdE,
    output reg [31:0]   ImmE,
    output reg          LinkE,
    output reg [31:0]   PCPlus8E,
    output reg          LoadUnsignedE,
    output reg [1:0]    MemWidthE,
    output reg [1:0]    HiLoWriteE,
    output reg [1:0]    HiLoToRegE,
    output reg          CP0WriteE,
    output reg          CP0ToRegE,
    output reg [4:0]    WriteCP0AddrE,
    output reg [2:0]    WriteCP0SelE,
    output reg [4:0]    ReadCP0AddrE,
    output reg [2:0]    ReadCP0SelE,
    output reg [31:0]   PCE,
    output reg          InDelaySlotE,
    output reg [31:0]   ExceptionTypeE
    );
    
    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            RegWriteE           <= 1'b0;
            MemToRegE           <= 1'b0;
            MemWriteE           <= 1'b0;
            ALUCtrlE            <= 5'b0;
            ALUSrcE             <= 2'b0;
            RegDstE             <= 2'b0;
            RD1E                <= 32'b0;
            RD2E                <= 32'b0;
            RsE                 <= 5'b0;
            RtE                 <= 5'b0;
            RdE                 <= 5'b0;
            ImmE                <= 32'b0;
            LinkE               <= 1'b0;
            PCPlus8E            <= 32'b0;
            LoadUnsignedE       <= 1'b0;
            MemWidthE           <= 2'b0;
            HiLoWriteE          <= 2'b0;
            HiLoToRegE          <= 2'b0;
            CP0WriteE           <= 1'b0;
            CP0ToRegE           <= 1'b0;
            WriteCP0AddrE       <= 5'b0;
            WriteCP0SelE        <= 3'b0;
            ReadCP0AddrE        <= 5'b0;
            ReadCP0SelE         <= 3'b0;
            PCE                 <= 32'b0;
            InDelaySlotE        <= 1'b0;
            ExceptionTypeE      <= 32'b0;
        end
        else if (en) begin
            RegWriteE           <= RegWriteD;
            MemToRegE           <= MemToRegD;
            MemWriteE           <= MemWriteD;
            ALUCtrlE            <= ALUCtrlD;
            ALUSrcE             <= ALUSrcD;
            RegDstE             <= RegDstD;
            RD1E                <= RD1D;
            RD2E                <= RD2D;
            RsE                 <= RsD;
            RtE                 <= RtD;
            RdE                 <= RdD;
            ImmE                <= ImmD;
            LinkE               <= LinkD;
            PCPlus8E            <= PCPlus8D;
            LoadUnsignedE       <= LoadUnsignedD;
            MemWidthE           <= MemWidthD;
            HiLoWriteE          <= HiLoWriteD;
            HiLoToRegE          <= HiLoToRegD;
            CP0WriteE           <= CP0WriteD;
            CP0ToRegE           <= CP0ToRegD;
            WriteCP0AddrE       <= WriteCP0AddrD;
            WriteCP0SelE        <= WriteCP0SelD;
            ReadCP0AddrE        <= ReadCP0AddrD;
            ReadCP0SelE         <= ReadCP0SelD;
            PCE                 <= PCD;
            InDelaySlotE        <= InDelaySlotD;
            ExceptionTypeE      <= ExceptionTypeD;
        end
    end 
    
endmodule
