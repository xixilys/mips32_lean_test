`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 2021/07/12 21:48:19
// Design Name: 
// Module Name: CP0
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


`include "macros.vh"

module cp0(
    input           clk,
    input           rst,
    
    input  [4:0]    cp0_read_addr,
    input  [2:0]    cp0_read_sel,
    output [31:0]   cp0_read_data,
    input  [4:0]    cp0_write_addr,
    input  [2:0]    cp0_write_sel,
    input  [31:0]   cp0_write_data,
    input           cp0_write_en,
    
    input  [5:0]    int_i,
    input  [31:0]   pc,
    input  [31:0]   mem_bad_vaddr,
    input  [31:0]   exception_type_i,
    input           in_delayslot,
    output [31:0]   return_pc,
    output          exception
    );
    
    reg [31:0] cp0_index;    // 0
    reg [31:0] cp0_random;   // 1
    reg [31:0] cp0_entrylo0; // 2
    reg [31:0] cp0_entrylo1; // 3
    reg [31:0] cp0_pagemask; // 5
    reg [31:0] cp0_badvaddr; // 8
    reg [31:0] cp0_count;    // 9
    reg [31:0] cp0_entryhi;  // 10
    reg [31:0] cp0_compare;  // 11
    reg [31:0] cp0_status;   // 12
    reg [31:0] cp0_cause;    // 13
    reg [31:0] cp0_epc;      // 14
    reg [31:0] cp0_prid;     // 15
    reg [31:0] cp0_config0;  // 16, 0
    reg [31:0] cp0_config1;  // 16, 1
    
    reg [31:0] pc_r;
    reg in_delayslot_r;
    always @ (posedge clk) begin
        pc_r <= pc;
        in_delayslot_r <= in_delayslot;
    end
    
    // exception handle
    wire timer_int = (cp0_compare != 32'b0 && cp0_count == cp0_compare) ? 1'b1 : 1'b0;
    wire [5:0] interrupt = {timer_int | int_i[5], int_i[4:0]};
    
    wire int_signal = cp0_status[15:8] & cp0_cause[15:8] && !cp0_status[1] && cp0_status[0];

    wire [31:0] exception_type = {exception_type_i[31:1], int_signal};
    
    reg exl_r;
    //wire commit_exception = |exception_type[30:0] && !cp0_status[1];
    wire commit_exception = |exception_type[30:0] && !exl_r;
    wire commit_in_delayslot = (int_signal) ? in_delayslot_r : in_delayslot;//中断是否处于延迟槽
    wire commit_eret = (exception_type & `EXCEP_MASK_ERET) ? 1'b1 : 1'b0;
    assign exception = commit_exception || commit_eret;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            exl_r <= 0;
        end 
        else begin
            exl_r <= cp0_status[1];
        end
    end

    wire [31:0] commit_epc;
    assign commit_epc = (int_signal) ? ((in_delayslot_r == 1'b1) ? pc_r - 4  : pc_r + 4) : 
                       (in_delayslot == 1'b1) ? pc - 4 : pc;
    
    reg [31:0] cp0_read_data_r;
    wire [7:0] read_addr_sel = {cp0_read_addr, cp0_read_sel};
    wire [7:0] write_addr_sel = {cp0_write_addr, cp0_write_sel};
    assign cp0_read_data = rst ? cp0_read_data_r : 32'b0;
    
    reg [4:0] cause_exccode;//用于写cause[6:2]
    reg [31:0] commit_bvaddr;//用于写badvaddr
    reg [31:0] return_pc_r;
    assign return_pc = rst ? return_pc_r : 32'b0;
    
    always @ (*) begin
        if (!rst) begin
            cause_exccode <= 5'b0;
            return_pc_r <= 32'h00000000;
            commit_bvaddr <= 32'b0;
        end
        else begin
            if (exception_type[`EXCEP_INT]) begin//中断
                cause_exccode <= `EXCEP_CODE_INT;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= 32'b0;
            end
            else if (exception_type[`EXCEP_AdELD]) begin
                cause_exccode <= `EXCEP_CODE_AdEL;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= mem_bad_vaddr;
            end
            else if (exception_type[`EXCEP_AdELI]) begin//中断
                cause_exccode <= `EXCEP_CODE_AdEL;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= pc;
            end
            else if (exception_type[`EXCEP_AdES]) begin
                cause_exccode <= `EXCEP_CODE_AdES;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= mem_bad_vaddr;
            end
            else if (exception_type[`EXCEP_Sys]) begin
                cause_exccode <= `EXCEP_CODE_Sys;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= 32'b0;
            end
            else if (exception_type[`EXCEP_Bp]) begin
                cause_exccode <= `EXCEP_CODE_Bp;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= 32'b0;
            end
            else if (exception_type[`EXCEP_RI]) begin
                cause_exccode <= `EXCEP_CODE_RI;
                return_pc_r <= 32'hbfc00200;
                commit_bvaddr <= 32'b0;
            end
            else if (exception_type[`EXCEP_Ov]) begin
                cause_exccode <= `EXCEP_CODE_Ov;
                return_pc_r <= 32'hbfc00380;
                commit_bvaddr <= 32'b0;
            end
            else if (exception_type[`EXCEP_ERET]) begin
                cause_exccode <= `EXCEP_CODE_ERET;
                return_pc_r <= cp0_epc;
                commit_bvaddr <= 32'b0;
            end
            else begin
                cause_exccode <= 5'h0;
                return_pc_r <= 32'h0;
                commit_bvaddr <= 32'b0;
            end
        end
    end
    
    // read
    always @ (*) begin
        case (read_addr_sel)
            `CP0_ADDR_SEL_INDEX:    begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_index[31:5], cp0_write_data[4:0]};
                end
                else begin
                    cp0_read_data_r = cp0_index;
                end
            end
            
            `CP0_ADDR_SEL_RANDOM:   begin
                cp0_read_data_r = cp0_random;
            end
            
            `CP0_ADDR_SEL_ENTRYLO0: begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_entrylo0[31:26], cp0_write_data[25:0]};
                end
                else begin
                    cp0_read_data_r = cp0_entrylo0;
                end
            end
            
            `CP0_ADDR_SEL_ENTRYLO1: begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_entrylo1[31:26], cp0_write_data[25:0]};
                end
                else begin
                    cp0_read_data_r = cp0_entrylo1;
                end
            end
            
            `CP0_ADDR_SEL_PAGEMASK: begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_pagemask[31:25], cp0_write_data[24:13], cp0_pagemask[12:0]};
                end
                else begin
                    cp0_read_data_r = cp0_pagemask;
                end
            end
            
            `CP0_ADDR_SEL_BADVADDR: begin
                cp0_read_data_r = cp0_badvaddr;
            end
            
            `CP0_ADDR_SEL_COUNT:    begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = cp0_write_data;
                end
                else begin
                    cp0_read_data_r = cp0_count;
                end
            end
            
            `CP0_ADDR_SEL_ENTRYHI:  begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_write_data[31:13], cp0_entryhi[12:8], cp0_write_data[7:0]};
                end
                else begin
                    cp0_read_data_r = cp0_entryhi;
                end
            end
            
            `CP0_ADDR_SEL_COMPARE:  begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = cp0_write_data;
                end
                else begin
                    cp0_read_data_r = cp0_compare;
                end
            end
            
            `CP0_ADDR_SEL_STATUS:   begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_status[31:16], cp0_write_data[15:8], cp0_status[7:2], cp0_write_data[1:0]};
                end
                else begin
                    cp0_read_data_r = cp0_status;
                end
            end
            
            `CP0_ADDR_SEL_CAUSE:    begin
                cp0_read_data_r = cp0_cause;
            end
            
            `CP0_ADDR_SEL_EPC:      begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = cp0_write_data;
                end
                else begin
                    cp0_read_data_r = cp0_epc;
                end
            end
            
            `CP0_ADDR_SEL_PRID:     begin
                cp0_read_data_r = cp0_prid;
            end
            
            `CP0_ADDR_SEL_CONFIG0:  begin
                if (cp0_write_en && write_addr_sel == read_addr_sel) begin
                    cp0_read_data_r = {cp0_config0[31:3], cp0_write_data[2:0]};
                end
                else begin
                    cp0_read_data_r = cp0_config0;
                end
            end
            
            `CP0_ADDR_SEL_CONFIG1:  begin
                cp0_read_data_r = cp0_config1;
            end
            
            default:                begin
                cp0_read_data_r = 32'b0;
            end
        endcase
    end
    
    // write
    // index (tlb)
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_index <= 32'b0;   
        end
        else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_INDEX) begin
            cp0_index[4:0] <= cp0_write_data[4:0];
        end 
    end
    // random (tlb)
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_random <= 32'b0;   
        end else begin
            cp0_random[4:0] <= cp0_random[4:0] + 1;
        end
    end
    // entrylo0 (tlb)
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_entrylo0 <= 32'b0;
        end else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_ENTRYLO0) begin
            cp0_entrylo0[25:0] <= cp0_write_data[25:0];
        end
    end
    // entrylo1 (tlb)
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_entrylo1 <= 32'b0;
        end else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_ENTRYLO1) begin
            cp0_entrylo1[25:0] <= cp0_write_data[25:0];
        end
    end
    // pagemask (tlb)
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_pagemask <= 32'b0;
        end else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_PAGEMASK) begin
            cp0_pagemask[24:13] <= cp0_write_data[24:13];
        end
    end
    //badvaddr
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_badvaddr <= 32'b0;
        end
        else if (commit_exception) begin
            cp0_badvaddr <= commit_bvaddr;
        end
    end
    //count
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_count <= 32'b0;
        end else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_COUNT) begin
            cp0_count <= cp0_write_data;
        end else begin
            cp0_count <= cp0_count + 1;
        end
    end
    // entryhi (tlb)
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_entryhi <= 32'b0;
        end
        else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_ENTRYHI) begin
            cp0_entryhi[31:13] <= cp0_write_data[31:13];
            cp0_entryhi[7:0] <= cp0_write_data[7:0];
        end
    end
    // compare
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_compare <= 32'b0;
        end else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_COMPARE) begin
            cp0_compare <= cp0_write_data;
        end
    end
    // status
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_status <= 32'b00000000010000000000000000000000;
        end
        else if (commit_exception || commit_eret) begin
            cp0_status[1] <= !commit_eret;
        end
        else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_STATUS) begin
            cp0_status[15:8] <= cp0_write_data[15:8];
            cp0_status[1:0] <= cp0_write_data[1:0];
        end
    end
    // cause
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_cause <= 32'b0;
        end
        else begin
            cp0_cause[30] <= timer_int; //计时器中断
            cp0_cause[15:10] <= interrupt; //硬件中断
            if (commit_exception) begin
                cp0_cause[31] <= commit_in_delayslot;
                cp0_cause[6:2] <= cause_exccode;
            end
            else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_CAUSE) begin
                cp0_cause[9:8] <= cp0_write_data[9:8];
            end
        end
    end
    // epc
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_epc <= 32'b0;
        end
        else if (commit_exception) begin
            cp0_epc <= commit_epc;
        end
        else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_EPC) begin
            cp0_epc <= cp0_write_data;
        end
    end
    // prid
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_prid <= 32'b0;
        end
    end
    // config0
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_config0 <= {1'b1, // M
                            15'b000000000000000, // 
                            1'b0, // BE
                            2'b00, // AT
                            3'b000, // AR
                            //3'b001, // MT
                            3'b000, // MT
                            4'b0000, // 
                            3'b010 // K0
                            };
        end else if (cp0_write_en && write_addr_sel == `CP0_ADDR_SEL_CONFIG0) begin
            cp0_config0[2:0] <= cp0_write_data[2:0];
        end
    end
    // config1
    always @ (negedge clk or negedge rst) begin
        if (!rst) begin
            cp0_config1 <= {1'b0, // M
                            //6'b011111, // MMUSize - 1
                            6'b000000, // MMUSize - 1
                            //3'b001, // IS
                            3'b000, // IS
                            //3'b100, // IL
                            3'b000, // IL
                            //3'b001, // IA
                            3'b000, // IA
                            //3'b001, // DS
                            3'b000, // DS
                            //3'b100, // DL
                            3'b000, // DL
                            //3'b001, // DA
                            3'b000, // DA
                            7'b0000000 // C2 MD PC WR CA EP FP
                            };
        end
    end
     
endmodule