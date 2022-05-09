`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/17 14:11:42
// Design Name: 
// Module Name: regfile
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


module regfile(
    input             clk,
    input             rst,
    
    input      [4:0]  A1,
    input      [4:0]  A2,
    input             WE3,
    input      [4:0]  A3,
    input      [31:0] WD3,
   
    output reg [31:0] RD1,
    output reg [31:0] RD2
    );
    
    reg [31:0] regs[31:0];

    integer i;
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i <= 31; i = i + 1) 
                regs[i] <= 32'b0;
        end
        else if (WE3 && A3 != 5'b0) 
            regs[A3] <= WD3;
    end
        
    always @ (*) begin
        if (!rst)
            RD1 <= 32'b0;
        else if (A1 == 5'b0)
            RD1 <= 32'b0;
        else if (WE3 && A1 == A3)
            RD1 <= WD3;
        else
            RD1 <= regs[A1];
    end
    
    always @ (*) begin
        if (!rst)
            RD2 <= 32'b0;
        else if (A2 == 5'b0)
            RD2 <= 32'b0;
        else if (WE3 && A2 == A3)
            RD2 <= WD3;
        else
            RD2 <= regs[A2];
    end
    
endmodule
