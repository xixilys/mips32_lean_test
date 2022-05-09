`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 12:37:58
// Design Name: 
// Module Name: ex2mem
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


module ex2mem(
    input               clk,
    input               rst,
    input               en,
    input               clr,
    
    input               RegWriteE,
    input               MemToRegE,
    input               MemWriteE,
    input [31:0]        ALUOutE,
    input [31:0]        WriteDataE,
    input [4:0]         WriteRegE,
    input               LoadUnsignedE,
    input [1:0]         MemWidthE,
    input [31:0]        PhyAddrE,
    input               LinkE,
    input [31:0]        PCPlus8E,
    input [1:0]         HiLoWriteE,
    input [1:0]         HiLoToRegE,
    input [31:0]        HiLoOutE,
    input [31:0]        HiInE,
    input [31:0]        LoInE,
    input               CP0WriteE,
    input               CP0ToRegE,
    input [4:0]         WriteCP0AddrE,
    input [2:0]         WriteCP0SelE,
    input [31:0]        WriteCP0HiLoDataE,
    input [31:0]        ReadCP0DataE,
    input [31:0]        PCE,
    input               InDelaySlotE,
    input [31:0]        BadVAddrE,
    input [31:0]        ExceptionTypeE,
    
    output reg          RegWriteM,
    output reg          MemToRegM,
    output reg          MemWriteM,
    output reg [31:0]   ALUOutM,
    output reg [31:0]   WriteDataM,
    output reg [4:0]    WriteRegM,
    output reg          LinkM,
    output reg [31:0]   PCPlus8M,
    output reg          LoadUnsignedM,
    output reg [1:0]    MemWidthM,
    output reg [31:0]   PhyAddrM,
    output reg [1:0]    HiLoWriteM,
    output reg [1:0]    HiLoToRegM,
    output reg [31:0]   HiLoOutM,
    output reg [31:0]   HiInM,
    output reg [31:0]   LoInM,
    output reg          CP0WriteM,
    output reg          CP0ToRegM,
    output reg [4:0]    WriteCP0AddrM,
    output reg [2:0]    WriteCP0SelM,
    output reg [31:0]   WriteCP0HiLoDataM,
    output reg [31:0]   ReadCP0DataM,
    output reg [31:0]   PCM,
    output reg          InDelaySlotM,
    output reg [31:0]   BadVAddrM,
    output reg [31:0]   ExceptionTypeM
    );
    
    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            RegWriteM           <= 32'b0;
            MemToRegM           <= 32'b0;
            MemWriteM           <= 32'b0;
            ALUOutM             <= 32'b0;
            WriteDataM          <= 32'b0;
            WriteRegM           <= 32'b0;
            LinkM               <= 1'b0;
            PCPlus8M            <= 32'b0;
            LoadUnsignedM       <= 1'b0;
            MemWidthM           <= 2'b0;
            PhyAddrM            <= 32'b0;
            HiLoWriteM          <= 2'b0;
            HiLoToRegM          <= 2'b0;
            HiLoOutM            <= 32'b0;
            HiInM               <= 32'b0;
            LoInM               <= 32'b0;
            CP0WriteM           <= 1'b0;
            CP0ToRegM           <= 1'b0;
            WriteCP0AddrM       <= 5'b0;
            WriteCP0SelM        <= 3'b0;
            WriteCP0HiLoDataM   <= 32'b0;
            ReadCP0DataM        <= 32'b0;
            PCM                 <= 32'b0;
            InDelaySlotM        <= 1'b0;
            BadVAddrM           <= 32'b0;
            ExceptionTypeM      <= 32'b0;
        end
        else if (en) begin
            RegWriteM           <= RegWriteE;
            MemToRegM           <= MemToRegE;
            MemWriteM           <= MemWriteE;
            ALUOutM             <= ALUOutE;
            WriteDataM          <= WriteDataE;
            WriteRegM           <= WriteRegE;
            LinkM               <= LinkE;
            PCPlus8M            <= PCPlus8E;
            LoadUnsignedM       <= LoadUnsignedE;
            MemWidthM           <= MemWidthE;
            PhyAddrM            <= PhyAddrE;
            HiLoWriteM          <= HiLoWriteE;
            HiLoToRegM          <= HiLoToRegE;
            HiLoOutM            <= HiLoOutE;
            HiInM               <= HiInE;
            LoInM               <= LoInE;
            CP0WriteM           <= CP0WriteE;
            CP0ToRegM           <= CP0ToRegE;
            WriteCP0AddrM       <= WriteCP0AddrE;
            WriteCP0SelM        <= WriteCP0SelE;
            WriteCP0HiLoDataM   <= WriteCP0HiLoDataE;
            ReadCP0DataM        <= ReadCP0DataE;
            PCM                 <= PCE;
            InDelaySlotM        <= InDelaySlotE;
            BadVAddrM           <= BadVAddrE;
            ExceptionTypeM      <= ExceptionTypeE;
        end
    end 
    
endmodule
