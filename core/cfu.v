`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 12:37:58
// Design Name: 
// Module Name: cfu
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


module cfu(
    input               rst,
    input               clk,

    input               AddrPendingF,
    input               DataPendingF,
    
    input  [5:0]        BranchD,
    input               JumpD,
    input               JRD,
    input               CanBranchD,

    input               DivPendingE,

    input               AddrPendingE,
    input               DataPendingM,
    
    input               InExceptionF,

    input  [4:0]        WriteRegE,
    input               MemToRegE,
    input               RegWriteE,
    input  [1:0]        HiLoToRegE,
    input               CP0ToRegE,
    
    input  [4:0]        WriteRegM,
    input               MemToRegM,
    input               RegWriteM,
    input  [1:0]        HiLoWriteM,
    input               CP0WriteM,
    
    input  [4:0]        WriteRegW,
    input               RegWriteW,
    input  [1:0]        HiLoWriteW,
    input               CP0WriteW,

    output              StallF,
    output              StallD,
    output              StallE,
    output              StallM,
    output              StallW,
    output              FlushD,
    output              FlushE,
    output              FlushM,
    output              FlushW,

    input  [4:0]        RsD,
    input  [4:0]        RtD,
    output reg          ForwardAD,
    output reg          ForwardBD,
    
    input  [4:0]        RsE,
    input  [4:0]        RtE,
    output reg [1:0]    ForwardAE,
    output reg [1:0]    ForwardBE,
    
    output reg [1:0]    ForwardHE
    );
        
    always @(*) begin
        if (!rst) begin
            ForwardAD <= 1'b0;
            ForwardBD <= 1'b0;
        end
        else begin
            ForwardAD <= RsD != 0 && RsD == WriteRegM && RegWriteM;
            ForwardBD <= RtD != 0 && RtD == WriteRegM && RegWriteM;
        end
    end
    
    always @(*) begin
        if (!rst) begin
            ForwardAE <= 2'b00;
            ForwardBE <= 2'b00;
        end
        else begin
            if (RsE != 0 && RsE == WriteRegM && RegWriteM) begin
                ForwardAE <= 2'b10;
            end
            else if (RsE != 0 && RsE == WriteRegW && RegWriteW) begin
                ForwardAE <= 2'b01;
            end
            else begin
                ForwardAE <= 2'b00;
            end
            if (RtE != 0 && RtE == WriteRegM && RegWriteM) begin
                ForwardBE <= 2'b10;
            end
            else if (RtE != 0 && RtE == WriteRegW && RegWriteW) begin
                ForwardBE <= 2'b01;
            end
            else begin
                ForwardBE <= 2'b00;
            end
        end
    end
    
    always @(*) begin
        if (!rst) begin
            ForwardHE <= 2'b00;
        end
        else begin
            if ((HiLoToRegE & HiLoWriteM) != 0) begin
                ForwardHE <= 2'b10;
            end
            else if ((HiLoToRegE & HiLoWriteW) != 0) begin
                ForwardHE <= 2'b01;
            end
            else begin
                ForwardHE <= 2'b00;
            end
        end
    end
    
    wire lmStall = (RsD == RtE || RtD == RtE) && MemToRegE;
    wire brStall = CanBranchD && (BranchD != 0) &&
                   ((RegWriteE && (WriteRegE == RsD || WriteRegE == RtD)) || 
                    (MemToRegM && (WriteRegM == RsD || WriteRegM == RtD)));
    wire jrStall = JumpD && JRD &&
                   ((RegWriteE && (WriteRegE == RsD || WriteRegE == RtD)) || 
                    (MemToRegM && (WriteRegM == RsD || WriteRegM == RtD)));
    wire cp0Stall = (CP0WriteM && CP0ToRegE) || (CP0WriteW && CP0ToRegE);
    wire divStall = DivPendingE;
//    wire ifreqStall = AddrPendingF;
    wire ifStall = DataPendingF;
//    wire dmemreqStall = AddrPendingE;
    wire dmemStall = DataPendingM;
    
    wire hasStall = lmStall || brStall || jrStall || cp0Stall || ifStall || divStall || dmemStall;
    wire excepStall = (InExceptionF && hasStall);
    wire excepFlush = (InExceptionF && !hasStall);
    
    assign StallF = ~(rst ? (
                        lmStall || brStall || jrStall || 
                        cp0Stall || divStall || dmemStall || excepStall
                        ) : 0);
                        
    assign StallD = ~(rst ? (
                        ifStall || lmStall || brStall || jrStall || 
                        cp0Stall || divStall || dmemStall || excepStall
                        ) : 0);
                        
    assign StallE = ~(rst ? (
                        cp0Stall || divStall || dmemStall || excepStall
                        ) : 0);
                        
    assign StallM = ~(rst ? (
                        dmemStall || excepStall
                        ) : 0);
                        
    assign StallW = ~(rst ? (
                        excepStall
                        ) : 0);
                        
    assign FlushD = (rst ? (StallD && (
                        excepFlush
                        )) : 0);
                        
    assign FlushE = (rst ? (StallE && (
                        ifStall || lmStall || brStall || jrStall || excepFlush
                        )) : 0);
                        
    assign FlushM = (rst ? (StallM && (
                        cp0Stall || divStall || excepFlush
                        )) : 0);
                        
    assign FlushW = (rst ? (StallW && (
                        dmemStall || excepFlush
                        )) : 0);

endmodule
