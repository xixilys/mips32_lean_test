`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/07 23:37:31
// Design Name: 
// Module Name: muldiv
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


module muldiv(
    input           rst,
    input           clk,
    input           en,
    
    input  [4:0]    ctrl,
    input  [31:0]   in1,
    input  [31:0]   in2,
    output [31:0]   hi,
    output [31:0]   lo,
    output reg      pending
    );
    
    wire [63:0] mulu_prod;
    wire [63:0] mul_prod;
    assign mulu_prod = in1 * in2;
    assign mul_prod = $signed(in1) * $signed(in2);
    
    reg [31:0] hi_r;
    reg [31:0] lo_r;
    //计算高32位和低32位吧
    assign hi = (ctrl == `ALU_MULT) ? mul_prod[63:32] : ((ctrl == `ALU_MULTU) ? mulu_prod[63:32] : hi_r);
    assign lo = (ctrl == `ALU_MULT) ? mul_prod[31:0] : ((ctrl == `ALU_MULTU) ? mulu_prod[31:0] : lo_r);

    reg in2_valid_u, in1_valid_u, in2_valid, in1_valid;
    wire in2_ready_u, in1_ready_u, out_valid_u, in2_ready, in1_ready, out_valid;
    reg [31:0] divisor_r;
    reg [31:0] dividend_r;
    wire [31:0] divisor = divisor_r;
    wire [31:0] dividend = dividend_r;
    wire [63:0] divu_prod;
    wire [63:0] div_prod;
    
    wire clkn = ~clk;
    
    unsigned_div _udiv( 
        .aclk                       (clkn),
        //.aresetn                    (rst),
        .s_axis_divisor_tvalid      (in2_valid_u),
        .s_axis_divisor_tready      (in2_ready_u),
        .s_axis_divisor_tdata       (divisor),
        .s_axis_dividend_tvalid     (in1_valid_u),
        .s_axis_dividend_tready     (in1_ready_u),
        .s_axis_dividend_tdata      (dividend),
        .m_axis_dout_tvalid         (out_valid_u),
        .m_axis_dout_tdata          (divu_prod)
        );
    signed_div _div( 
        .aclk                       (clkn),
        //.aresetn                    (rst),
        .s_axis_divisor_tvalid      (in2_valid),
        .s_axis_divisor_tready      (in2_ready),
        .s_axis_divisor_tdata       (divisor),
        .s_axis_dividend_tvalid     (in1_valid),
        .s_axis_dividend_tready     (in1_ready),
        .s_axis_dividend_tdata      (dividend),
        .m_axis_dout_tvalid         (out_valid),
        .m_axis_dout_tdata          (div_prod)
        );

    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            hi_r <= 32'b0;
            lo_r <= 32'b0;
            divisor_r <= 32'b0;
            dividend_r <= 32'b0;
            in1_valid <= 0;
            in2_valid <= 0;
            in1_valid_u <= 0;
            in2_valid_u <= 0;
            pending <= 0;
        end
        else if (en && !pending) begin
            if (ctrl == `ALU_DIV) begin
                dividend_r <= in1;
                divisor_r <= in2;
                in1_valid <= 1;
                in2_valid <= 1;
                pending <= 1;
            end
            else if (ctrl == `ALU_DIVU) begin
                dividend_r <= in1;
                divisor_r <= in2;
                in1_valid_u <= 1;
                in2_valid_u <= 1;
                pending <= 1;
            end
        end
        else begin
            if (pending && in1_ready && in2_ready) begin
                in1_valid <= 0;
                in2_valid <= 0;
            end
            if (pending && in1_ready_u && in2_ready_u) begin
                in1_valid_u <= 0;
                in2_valid_u <= 0;
            end
            if (out_valid) begin
                {lo_r, hi_r} <= div_prod;
                pending <= 0;
            end
            if (out_valid_u) begin
                {lo_r, hi_r} <= divu_prod;
                pending <= 0;
            end
        end
    end

endmodule
