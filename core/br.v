`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/07 21:10:06
// Design Name: 
// Module Name: br
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


module br(
    input           clk,
    input           rst,
    input           en,
    
    input [31:0]    rs,
    input [31:0]    rt,
    input [5:0]     branch,
    
    output          exe
    );
    
    reg [31:0] rs_r;
    reg [31:0] rt_r;
    reg [31:0] branch_r;
    always @(*) begin
        if (!rst) begin
            rs_r <= 32'b0;
            rt_r <= 32'b0;
            branch_r <= 6'b0;
        end
        else if (en) begin
            rs_r <= rs;
            rt_r <= rt;
            branch_r <= branch;
        end
    end
    
    wire [5:0] result;
    assign result = {($signed(rs_r) < 0), 
                     ($signed(rs_r) <= 0), 
                     ($signed(rs_r) > 0), 
                     ($signed(rs_r) >= 0), 
                     (rs_r != rt_r), 
                     (rs_r == rt_r)};
    assign exe = en && rst && ((result & branch) != 0);
    
endmodule
