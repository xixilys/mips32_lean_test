`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/08 00:16:11
// Design Name: 
// Module Name: hilo
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


module hilo(
    input  clk,
    input  rst,
    
    input  [1:0] we,
    input  [31:0] hi_i,
    input  [31:0] lo_i,
    
    output reg [31:0] hi_o,
    output reg [31:0] lo_o
    );
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            hi_o <= 32'b0;
            lo_o <= 32'b0;
        end
        else begin
            case (we)
                2'b00: begin
                
                end
                2'b01: begin
                    lo_o <= lo_i;
                end
                2'b10: begin
                    hi_o <= hi_i;
                end
                2'b11: begin
                    hi_o <= hi_i;
                    lo_o <= lo_i;
                end
            endcase
        end
    end
endmodule
