`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 12:37:06
// Design Name: 
// Module Name: if2id
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


module if2id(
    input               clk,
    input               rst,
    input               en,
    input               clr,
    
    input  [31:0]       ReadDataF,
    input  [31:0]       PCPlus4F,
    input  [31:0]       PCPlus8F,
    input               NextDelaySlotD,
    input  [31:0]       PCF,
    input  [31:0]       ExceptionTypeF,
    
    output reg [31:0]   InstrD,
    output reg [31:0]   PCPlus4D,
    output reg [31:0]   PCPlus8D,
    output reg          InDelaySlotD,
    output reg [31:0]   PCD,
    output reg [31:0]   ExceptionTypeD
    );
    
    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            InstrD          <= 32'b0;
            PCPlus4D        <= 32'b0;
            PCPlus8D        <= 32'b0;
            InDelaySlotD    <= 1'b0;
            PCD             <= 32'b0;
            ExceptionTypeD  <= 32'b0;
        end
        else if (en) begin
            InstrD          <= ReadDataF;
            PCPlus4D        <= PCPlus4F;
            PCPlus8D        <= PCPlus8F;
            InDelaySlotD    <= NextDelaySlotD;
            PCD             <= PCF;
            ExceptionTypeD  <= ExceptionTypeF;
        end
    end 
    
endmodule
