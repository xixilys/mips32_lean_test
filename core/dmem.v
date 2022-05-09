`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 21:13:55
// Design Name: 
// Module Name: dmem
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


module dmem(
    input               clk,
    input               rst,
    
    input               req,
    input               addr_ok,
    (*mark_debug = "true"*)input               data_ok,
    (*mark_debug = "true"*)input       [31:0]  rdata,

    input               WE,
    input       [31:0]  A,
    // input       [31:0]  WD,
    input       [1 :0]  WIDTH,
    (*mark_debug = "true"*)input               SIGN,
    (*mark_debug = "true"*)output reg  [31:0]  RD,

    (*mark_debug = "true"*)output reg          data_pending
    );
    
    wire [1:0] ra = A[1:0];

    function [31:0] get_ext_byte(input [31:0] data, input [1:0] offset, input sign);
    begin
        case (offset) 
            2'b00: get_ext_byte = sign ? {{24{data[7]}},  data[7:0]}   : {24'b0, data[7:0]};
            2'b01: get_ext_byte = sign ? {{24{data[15]}}, data[15:8]}  : {24'b0, data[15:8]};
            2'b10: get_ext_byte = sign ? {{24{data[23]}}, data[23:16]} : {24'b0, data[23:16]};
            2'b11: get_ext_byte = sign ? {{24{data[31]}}, data[31:24]} : {24'b0, data[31:24]};
        endcase
    end
    endfunction

    function [31:0] get_ext_halfword(input [31:0] data, input [1:0] offset, input sign);
    begin
        case (offset) 
            2'b00: get_ext_halfword = sign ? {{16{data[15]}}, data[15:0]}  : {16'b0, data[15:0]};
            2'b01: get_ext_halfword = 32'b0;
            2'b10: get_ext_halfword = sign ? {{16{data[31]}}, data[31:16]} : {16'b0, data[31:16]};
            2'b11: get_ext_halfword = 32'b0;
        endcase
    end
    endfunction

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RD <= 32'b0;
            data_pending <= 0;
        end
        else begin
            if (req && addr_ok) begin
                data_pending <= 1;
            end
            else if (data_ok) begin
                if (!WE) begin
                    case (WIDTH)
                        2'b00: RD <= 32'b0;
                        2'b01: RD <= get_ext_byte(rdata, ra, SIGN);
                        2'b10: RD <= get_ext_halfword(rdata, ra, SIGN);
                        2'b11: RD <= rdata;
                    endcase
                end
                data_pending <= 0;
            end
        end
    end
    
endmodule
