`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 21:13:55
// Design Name: 
// Module Name: alu
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
//乘除法专门设置了乘除法器
module alu(
//    input               clk,
    input               rst,
    
    input  [4:0]        ctrl,
    input  [31:0]       in1,
    input  [31:0]       in2,
   
    output reg [31:0]   result,
    output              overflow
    );
    
    wire [4:0]  sa     = in1[4:0];
    
    wire [31:0] o_and  = in1 & in2;
    wire [31:0] o_or   = in1 | in2;
    wire [31:0] o_xor  = in1 ^ in2;
    wire [31:0] o_nor  = ~o_or;
    
    wire [31:0] o_slt  = ($signed(in1) < $signed(in2)) ? 32'b1 : 32'b0;
    wire [31:0] o_sll  = in2 << sa;
    wire [31:0] o_sltu = ($unsigned(in1) < $unsigned(in2)) ? 32'b1 : 32'b0;
    
    wire [31:0] o_sra  = $signed(in2) >>> sa;
    wire [31:0] o_srl  = in2 >> sa;
    
    wire [31:0] o_lui  = {in2[15:0], 16'b0};
    
    wire [32:0] in1_e = {in1[31], in1};
    wire [32:0] in2_e = {in2[31], in2};
    
    wire [32:0] o_add = in1_e + in2_e;
    wire [32:0] o_sub = in1_e - in2_e;

    always @(*) begin
        if (!rst) begin
            result = 32'b0;
        end
        else begin
            case (ctrl)
                `ALU_ADD, `ALU_ADDE : result = o_add;
                `ALU_ADDU   : result = o_add;
                `ALU_SUB, `ALU_SUBE : result = o_sub;
                `ALU_SUBU   : result = o_sub;
                `ALU_AND    : result = o_and;
                `ALU_OR     : result = o_or;
                `ALU_SLT    : result = o_slt;
                `ALU_SLL    : result = o_sll;
                `ALU_SLTU   : result = o_sltu;
                `ALU_XOR    : result = o_xor;
                `ALU_LUI    : result = o_lui;
                `ALU_NOR    : result = o_nor;
                `ALU_SRA    : result = o_sra;
                `ALU_SRL    : result = o_srl;
                default     : result = 32'b0;
            endcase
        end
    end
                     
    //assign zero = (result == 0) ? 1 : 0;
    assign overflow = (ctrl == `ALU_ADDE && o_add[32] != o_add[31]) || (ctrl == `ALU_SUBE && o_sub[32] != o_sub[31]);
endmodule