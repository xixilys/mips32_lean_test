`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/25 06:26:29
// Design Name: 
// Module Name: dmemreq
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


module dmemreq(
    input               clk,
    input               rst,
    (*mark_debug = "true"*)input               en,
    
    (*mark_debug = "true"*)input               MemWriteE,
    (*mark_debug = "true"*)input               MemToRegE,
    (*mark_debug = "true"*)input       [1 :0]  MemWidthE,
    (*mark_debug = "true"*)input       [31:0]  PhyAddrE,
    (*mark_debug = "true"*)input       [31:0]  WriteDataE,
    
    (*mark_debug = "true"*)output              req,
    (*mark_debug = "true"*)output              wr,
    (*mark_debug = "true"*)output      [1 :0]  size,
    (*mark_debug = "true"*)output      [31:0]  addr,
    (*mark_debug = "true"*)output      [31:0]  wdata,
    (*mark_debug = "true"*)input               addr_ok,

    (*mark_debug = "true"*)output              addr_pending
    );

    function [1:0] get_size(input [1:0] width);
    begin
        case (width)
            2'b00: get_size = 2'b10;
            2'b01: get_size = 2'b00;
            2'b10: get_size = 2'b01;
            2'b11: get_size = 2'b10;
        endcase
    end
    endfunction

    function [31:0] get_data(input [31:0] data, input [1:0] offset, input [1:0] width);
    begin
        case (offset)
            2'b00: begin
                case (width)
                    2'b00: get_data = 32'b0;
                    2'b01: get_data = {24'b0, data[7:0]};
                    2'b10: get_data = {16'b0, data[15:0]};
                    2'b11: get_data = data;
                endcase
            end
            2'b01: begin
                case (width)
                    2'b00: get_data = 32'b0;
                    2'b01: get_data = {16'b0, data[7:0], 8'b0};
                    2'b10: get_data = 32'b0;
                    2'b11: get_data = 32'b0;
                endcase
            end
            2'b10: begin
                case (width)
                    2'b00: get_data = 32'b0;
                    2'b01: get_data = {8'b0, data[7:0], 16'b0};
                    2'b10: get_data = {data[15:0], 16'b0};
                    2'b11: get_data = 32'b0;
                endcase
            end
            2'b11: begin
                case (width)
                    2'b00: get_data = 32'b0;
                    2'b01: get_data = {data[7:0], 24'b0};
                    2'b10: get_data = 32'b0;
                    2'b11: get_data = 32'b0;
                endcase
            end
        endcase
    end
    endfunction

    wire [1:0] ra = PhyAddrE[1:0];
    assign addr_pending = 0;
    assign wr = MemWriteE;
    assign size = get_size(MemWidthE);
    assign addr = PhyAddrE;
    assign wdata = get_data(WriteDataE, ra, MemWidthE);
    assign req = (MemWriteE || MemToRegE) && en;

//    always @(posedge clk or negedge rst) begin
//        if (!rst) begin
//            req <= 0;
//            wr <= 0;
//            size <= 2'b00;
//            addr <= 32'b0;
//            wdata <= 32'b0;
//        end
//        else begin
//            if (en) begin
//                wr <= MemWriteE;
//                size <= get_size(MemWidthE);
//                addr <= PhyAddrE;
//                wdata <= get_data(WriteDataE, ra, MemWidthE);
//            end
//            req <= en;
//        end
//    end 

endmodule
