`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 12:38:57
// Design Name: 
// Module Name: pc2if
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


module pc2if(
    input               clk,
    input               rst,
    input               en,
    
    input       [31:0]  PC_next,
    output      [31:0]  PCP,
    input       [31:0]  PhyAddrP,
    output reg  [31:0]  PCF,
    input               InstUnalignedP,
    output reg          InstUnalignedF,
    input               ExceptionW,
    input       [31:0]  ReturnPCW,
    
    output      [31:0]  addr,
    output              wr,
    output      [1 :0]  size,
    output      [31:0]  wdata,
    output              req,
    input               addr_ok,
    input               data_ok,
    
    output              addr_pending,
    output              data_pending,
    output              InExceptionF
    );

//    reg [31:0] next_pc_r;
    reg [31:0] return_pc_r;
    assign PCP = rst ? (InExceptionF ? return_pc_r : PC_next) : 32'hbfc00000;
    
    reg in_exception_r;
    assign InExceptionF = in_exception_r;    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
//            next_pc_r <= 32'hbfc00000;
            return_pc_r <= 32'b0;
            in_exception_r <= 0;
        end
        else begin
            if (!in_exception_r && ExceptionW) begin
                return_pc_r <= ReturnPCW;
                in_exception_r <= 1;
            end
            else begin
//                if (en) begin
//                    next_pc_r <= PC_next;
//                end
                if (req) begin
                    in_exception_r <= 0;
                end
            end
        end
    end
    
    reg rst_flag;
    
    reg req_pending, req_wait;
    wire req_miss = data_ok ^ req_pending;
    wire req_stall = req_wait || req_miss;
    assign addr_pending = 0;
    assign req = rst_flag && en && (!req_stall || (req_stall && data_ok));
    assign data_pending = rst && !req && req_stall;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            rst_flag <= 0;
            req_pending <= 0;
            req_wait <= 0;
        end
        else begin
            rst_flag <= 1;
            req_pending <= req;
            req_wait <= req_miss ? !req_wait : req_wait;
        end
    end
    
//    reg [31:0] addr_r;
//    assign addr = addr_r;
    assign addr = PhyAddrP;
    assign wr = 0;
    assign size = 2'b10;
    assign wdata = 32'h0;
 
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            PCF <= 32'hbfbffffc;
            InstUnalignedF <= 0;
//            addr_r <= 32'h0;
        end
        else begin
            if (req) begin
                PCF <= PCP;
                InstUnalignedF <= InstUnalignedP;
            end
//            if (!rst_flag || data_ok) begin
//                addr_r <= PhyAddrP;
//            end
        end
    end 
    
endmodule
