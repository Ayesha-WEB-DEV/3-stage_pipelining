module RISC_V (
    input logic clk,
    reset,
    input logic [31:0] external_interrupt_occured,
    output logic [31:0] data_out
);
  logic [31:0] alu_out;
  logic [31:0] instruction1;
  logic [31:0] instruction2;
  logic [31:0] instruction3;
  logic [31:0] timer_interrupt_occured;
  logic [31:0] interrupt;
  logic [ 3:0] alu_op;
  logic reg_wr, sel_A, sel_B, rd_en, wr_en, reg_wrMW, wr_enMW, rd_enMW;
  logic [1:0] wb_sel, wb_selMW;
  logic forward_A, forward_B, stall, stallMW, flush, br_taken3;
  logic CSR_reg_rd, CSR_reg_wr;
  logic CSR_reg_rdMW, CSR_reg_wrMW, is_mret, is_mretMW;
  logic [7:0] timer;
  logic epc_taken;
  assign interrupt = (external_interrupt_occured | timer_interrupt_occured);
  IR_Datapath RDT (
      .alu_op(alu_op),
      .wb_selMW(wb_selMW),
      .clk(clk),
      .reset(reset),
      .epc_taken(epc_taken),
      .reg_wrMW(reg_wrMW),
      .sel_A(sel_A),
      .sel_B(sel_B),
      .rd_enMW(rd_enMW),
      .stall(stall),
      .stallMW(stallMW),
      .flush(flush),
      .wr_enMW(wr_enMW),
      .alu_out2(alu_out),
      .forward_A(forward_A),
      .forward_B(forward_B),
      .instruction1(instruction1),
      .br_taken3(br_taken3),
      .instruction2(instruction2),
      .instruction3(instruction3),
      .interrupt(interrupt),
      .is_mretMW(is_mretMW),
      .CSR_reg_rdMW(CSR_reg_rdMW),
      .CSR_reg_wrMW(CSR_reg_wrMW),
      .data_out(data_out)
  );
  Forwarding_Unit FWD (
      .br_taken(br_taken3),
      .flush(flush),
      .forward_A(forward_A),
      .forward_B(forward_B),
      .instruction2(instruction2),
      .instruction3(instruction3),
      .reg_wrMW(reg_wrMW),
      .epc_taken(epc_taken),
      .wb_selMW(wb_selMW),
      .stall(stall),
      .stallMW(stallMW)
  );
  IR_Controller RCT (
      .instruction2(instruction2),
      .alu_op(alu_op),
      .reg_wr(reg_wr),
      .sel_A(sel_A),
      .sel_B(sel_B),
      .rd_en(rd_en),
      .wr_en(wr_en),
      .wb_sel(wb_sel),
      .CSR_reg_rd(CSR_reg_rd),
      .CSR_reg_wr(CSR_reg_wr),
      .is_mret(is_mret)
  );
  IR_Controller2 RCT2 (
      .clk(clk),
      .reset(reset),
      .reg_wr(reg_wr),
      .wr_en(wr_en),
      .rd_en(rd_en),
      .stallMW(stallMW),
      .wb_sel(wb_sel),
      .flush(flush),
      .is_mret(is_mret),
      .reg_wrMW(reg_wrMW),
      .wr_enMW(wr_enMW),
      .rd_enMW(rd_enMW),
      .CSR_reg_rd(CSR_reg_rd),
      .CSR_reg_wr(CSR_reg_wr),
      .CSR_reg_rdMW(CSR_reg_rdMW),
      .CSR_reg_wrMW(CSR_reg_wrMW),
      .wb_selMW(wb_selMW),
      .is_mretMW(is_mretMW)
  );
  // Generating Timer Interrupt
  always_ff @(posedge clk) begin
    // Timer
    if (reset) begin
      timer <= 8'b0000_0000;
    end else begin
      timer <= timer + 1;
    end
    // Timer Interrupt
    if (timer == 8'b1111_1111) begin
      timer_interrupt_occured <= 32'h0000_0080;
    end else begin
      timer_interrupt_occured <= 32'h0000_0000;
    end
  end
endmodule
