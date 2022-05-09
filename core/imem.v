`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 21:13:55
// Design Name: 
// Module Name: imem
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


module imem(
    input               clk,
    input               rst,
//    input               en,
    
    input               req,
    input               addr_ok,
    input               data_ok,
    input       [31:0]  rdata,

    input               unaligned,
    output      [31:0]  RD
    );

    reg [31:0] RD_r;
//    assign RD = RD_r;
    assign RD = data_ok ? rdata : RD_r;
    always @(posedge clk or negedge rst) begin
        if (!rst || unaligned) begin
            RD_r <= 32'b0;
        end
        else if (data_ok) begin
            RD_r <= rdata;
        end
    end
    
endmodule
