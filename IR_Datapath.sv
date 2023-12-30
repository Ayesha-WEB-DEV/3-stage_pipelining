module IR_Datapath (
    input logic [3:0] alu_op,
    input logic [1:0] wb_selMW,
    input logic clk,
    reset,
    reg_wrMW,
    sel_A,
    sel_B,
    input logic rd_enMW,
    wr_enMW,
    input logic stall,
    stallMW,
    forward_A,
    forward_B,
    flush,
    input logic [31:0] interrupt,
    input logic CSR_reg_rdMW,
    CSR_reg_wrMW,
    is_mretMW,
    output logic [31:0] alu_out2,
    output logic [31:0] instruction1,
    instruction2,
    instruction3,
    output logic br_taken3,
    epc_taken,
    output logic [31:0] data_out
);
  logic [31:0] PC_out1, PC_out2, PC_out3, PC_in, PC_plus, PC_taken, wdata3;
  logic [31:0] rdata1, rdata2, A_input, B_input, WB_out, alu_out;
  logic [31:0] A_fwd_input, B_fwd_input;
  logic [6:0] opcode;
  logic [31:0] immediate, rdata;
  logic [31:0] CSR_wdata, CSR_Address, CSR_epc, CSR_rdata;
  logic [2:0] func3_2, func3_3;
  logic br_taken, enable, enableMW;
  assign func3_2  = instruction2[14:12];
  assign func3_3  = instruction3[14:12];
  assign PC_plus  = PC_out1 + 4;
  assign enable   = !stall;
  assign enableMW = !stallMW;
  //STAGE 1: FETCH
  mux21 MUX_PC (
      .s(br_taken3),
      .a(PC_plus),
      .b(alu_out2),
      .y(PC_in)
  );
  mux21 MUX_CSR_PC (
      .s(epc_taken),
      .a(PC_in),
      .b(CSR_epc),
      .y(PC_taken)
  );
  flip_flop_pc FF_PC (
      .clk(clk),
      .reset(reset),
      .enable(enable),
      .d(PC_taken),
      .q(PC_out1)
  );
  inst_mem INST_MEM (
      .addr(PC_out1),
      .instruction1(instruction1)
  );
  //STAGE 2: DECODE and EXECUTE
  flip_flop PC_F_DE (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enable),
      .d(PC_out1),
      .q(PC_out2)
  );
  flip_flop_inst IR_F_DE (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enable),
      .d(instruction1),
      .q(instruction2)
  );
  reg_file REG_FILE (
      .instruction2(instruction2),
      .instruction3(instruction3),
      .wdata(WB_out),
      .clk(clk),
      .reg_wr(reg_wrMW),
      .reset(reset),
      .rdata1(rdata1),
      .rdata2(rdata2)
  );
  immediate_gen IMM_GEN (
      .instruction(instruction2),
      .out(immediate),
      .opcode(opcode)
  );
  //
  mux21 MUX_FWD_A (
      .s(forward_A),
      .a(alu_out2),
      .b(rdata1),
      .y(A_fwd_input)
  );
  mux21 MUX_FWD_B (
      .s(forward_B),
      .a(alu_out2),
      .b(rdata2),
      .y(B_fwd_input)
  );
  //
  mux21 MUX_A (
      .s(sel_A),
      .a(PC_out2),
      .b(A_fwd_input),
      .y(A_input)
  );
  mux21 MUX_B (
      .s(sel_B),
      .a(B_fwd_input),
      .b(immediate),
      .y(B_input)
  );
  alu ALU (
      .a (A_input),
      .b (B_input),
      .op(alu_op),
      .o (alu_out)
  );
  branch_cond BRANCH (
      .rdata1  (A_fwd_input),
      .rdata2  (B_fwd_input),
      .br_type (func3_2),
      .opcode  (opcode),
      .br_taken(br_taken)
  );
  //STAGE 3: MEMORY and WRITEBACK
  flip_flop PC_DE_MWB (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(PC_out2),
      .q(PC_out3)
  );
  flip_flop FF_ALU (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(alu_out),
      .q(alu_out2)
  );
  flip_flop FF_INTO_DM (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(rdata2),
      .q(wdata3)
  );
  flip_flop_inst IR_DE_MWB (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(instruction2),
      .q(instruction3)
  );
  flip_flop_1bit BR_DE_MWB (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(br_taken),
      .q(br_taken3)
  );
  flip_flop CSR_DATA (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(A_fwd_input),
      .q(CSR_wdata)
  );
  flip_flop CSR_ADDR (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(immediate),
      .q(CSR_Address)
  );
  CSR_reg_file CSR_REG (
      .PC(PC_out3),
      .wdata(CSR_wdata),
      .clk(clk),
      .reset(reset),
      .Address(CSR_Address),
      .interrupt(interrupt),
      .reg_wr(CSR_reg_wrMW),
      .reg_rd(CSR_reg_rdMW),
      .is_mret(is_mretMW),
      .epc_taken(epc_taken),
      .epc(CSR_epc),
      .csr_rdata(CSR_rdata)
  );
  data_memory DATA_Mem (
      .addr(alu_out2),
      .wdata(wdata3),
      .rd_en(rd_enMW),
      .clk(clk),
      .wr_en(wr_enMW),
      .func3(func3_3),
      .rdata(rdata),
      .data_out(data_out)
  );
  mux41 MUX_WB (
      .sel(wb_selMW),
      .a  (PC_out3 + 4),
      .b  (alu_out2),
      .c  (rdata),
      .d  (CSR_rdata),
      .y  (WB_out)
  );
endmodule
