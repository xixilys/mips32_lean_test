`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 12:37:06
// Design Name: 
// Module Name: mem2wb
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


module mem2wb(
    input               clk,
    input               rst,
    input               en,
    input               clr,
    
    input               RegWriteM,
    input               MemToRegM,
    input [31:0]        ReadDataM,
    input [31:0]        ResultM,
    input [4:0]         WriteRegM,
    input [1:0]         HiLoWriteM,
    input [31:0]        HiInM,
    input [31:0]        LoInM,
    input               CP0WriteM,
    input [4:0]         WriteCP0AddrM,
    input [2:0]         WriteCP0SelM,
    input [31:0]        WriteCP0HiLoDataM,
    input [31:0]        PCM,
    input               InDelaySlotM,
    input [31:0]        BadVAddrM,
    input [31:0]        ExceptionTypeM,
    
    output reg          RegWriteW,
    output reg          MemToRegW,
    output reg [31:0]   ReadDataW,
    output reg [31:0]   ResultW,
    output reg [4:0]    WriteRegW,
    output reg [1:0]    HiLoWriteW,
    output reg [31:0]   HiInW,
    output reg [31:0]   LoInW,
    output reg          CP0WriteW,
    output reg [4:0]    WriteCP0AddrW,
    output reg [2:0]    WriteCP0SelW,
    output reg [31:0]   WriteCP0HiLoDataW,
    output reg [31:0]   PCW,
    output reg          InDelaySlotW,
    output reg [31:0]   BadVAddrW,
    output reg [31:0]   ExceptionTypeW
    );
    
    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            RegWriteW           <= 1'b0;
            MemToRegW           <= 1'b0;
            ReadDataW           <= 32'b0;
            ResultW             <= 32'b0;
            WriteRegW           <= 5'b0;
            HiLoWriteW          <= 2'b0;
            HiInW               <= 32'b0;
            LoInW               <= 32'b0;
            CP0WriteW           <= 1'b0;
            WriteCP0AddrW       <= 5'b0;
            WriteCP0SelW        <= 3'b0;
            WriteCP0HiLoDataW   <= 32'b0;
            PCW                 <= 32'b0;
            InDelaySlotW        <= 1'b0;
            BadVAddrW           <= 32'b0;
            ExceptionTypeW      <= 32'b0;
        end
        else if (en) begin
            RegWriteW           <= RegWriteM;
            MemToRegW           <= MemToRegM;
            ReadDataW           <= ReadDataM;
            ResultW             <= ResultM;
            WriteRegW           <= WriteRegM;
            HiLoWriteW          <= HiLoWriteM;
            HiInW               <= HiInM;
            LoInW               <= LoInM;
            CP0WriteW           <= CP0WriteM;
            WriteCP0AddrW       <= WriteCP0AddrM;
            WriteCP0SelW        <= WriteCP0SelM;
            WriteCP0HiLoDataW   <= WriteCP0HiLoDataM;
            PCW                 <= PCM;
            InDelaySlotW        <= InDelaySlotM;
            BadVAddrW           <= BadVAddrM;
            ExceptionTypeW      <= ExceptionTypeM;
        end
    end 
    
endmodule
