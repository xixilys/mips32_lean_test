`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/11 15:59:13
// Design Name: 
// Module Name: mmu
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


module mmu (
    input               clk,
    input               rst,
    
    input      [31:0]   i_vaddr,
    input               i_en,
//    input               i_clr,
    output reg [31:0]   i_paddr,
    output reg          i_cached,
    output reg          i_unaligned,

    input      [31:0]   d_vaddr,
    input      [1 :0]   d_width,
    input               d_en,
    input               d_clr,
    output reg [31:0]   d_paddr,
    output reg          d_cached,
    output reg          d_unaligned
    );
    
    //assign unaligned = (rst && d_en) ? check_addr(d_width, d_vaddr) : 0;
    function check_addr(input [1:0] width, input [31:0] rd);
    begin
        case (width)
            2'b00: check_addr = 0;
            2'b01: check_addr = 0;
            2'b10: check_addr = rd[0] ? 1 : 0;
            2'b11: check_addr = rd[1:0] ? 1 : 0;
        endcase
    end
    endfunction

    //assign i_paddr = rst ? (i_en ? memory_mapping(i_vaddr) : 32'h0) : 32'hbfc00000;
    //assign d_paddr = (rst && d_en) ? memory_mapping(d_vaddr) : 32'h0;
    function [31:0] memory_mapping(input [31:0] address);
    begin
        case (address[31:29])
            3'b000, 3'b001, 3'b010, 3'b011, 3'b110, 3'b111: begin
                memory_mapping = address;
            end
            3'b100, 3'b101: begin
                memory_mapping = {3'b0, address[28:0]};
            end
        endcase
    end
    endfunction

    function check_cached(input [31:0] address);
    begin
        case (address[31:29])
            3'b000, 3'b001, 3'b010, 3'b011, 3'b101, 3'b110, 3'b111: begin
                check_cached = 1'b0;
            end
            3'b100: begin
                check_cached = 1'b1;
            end
        endcase
    end
    endfunction

    always @(*) begin
        if (!rst) begin
            i_paddr <= 32'hbfc00000;
            i_unaligned <= 0;
            i_cached <= 0;
            d_paddr <= 32'h0;
            d_unaligned <= 0;
            d_cached <= 0;
        end
        else begin
            if (i_en) begin
                i_paddr <= memory_mapping(i_vaddr);
                i_unaligned <= check_addr(2'b11, i_vaddr);
                i_cached <= check_cached(i_vaddr);
//                i_cached <= 1;
            end
            if (d_clr) begin
                d_paddr <= 32'b0;
                d_unaligned <= 0;
                d_cached <= 0;
            end
            else if (d_en) begin
                d_paddr <= memory_mapping(d_vaddr);
                d_unaligned <= check_addr(d_width, d_vaddr);
                d_cached <= check_cached(d_vaddr);
//                d_cached <= 0;
            end
        end
    end

endmodule
