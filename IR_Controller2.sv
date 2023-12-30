module IR_Controller2 (
    input logic clk,
    reset,
    reg_wr,
    wr_en,
    rd_en,
    stallMW,
    flush,
    input logic CSR_reg_rd,
    CSR_reg_wr,
    is_mret,
    input logic [1:0] wb_sel,
    output logic reg_wrMW,
    wr_enMW,
    rd_enMW,
    CSR_reg_rdMW,
    CSR_reg_wrMW,
    output logic is_mretMW,
    output logic [1:0] wb_selMW
);
  logic enableMW;
  assign enableMW = !stallMW;
  flip_flop_1bit FF_CSR_REG_RD (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(CSR_reg_rd),
      .q(CSR_reg_rdMW)
  );
  flip_flop_1bit FF_CSR_REG_WR (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(CSR_reg_wr),
      .q(CSR_reg_wrMW)
  );
  flip_flop_1bit FF_IS_MRET (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(is_mret),
      .q(is_mretMW)
  );
  flip_flop_1bit FF_REG_WR (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(reg_wr),
      .q(reg_wrMW)
  );
  flip_flop_1bit FF_WR_EN (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(wr_en),
      .q(wr_enMW)
  );
  flip_flop_1bit FF_RD_EN (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(rd_en),
      .q(rd_enMW)
  );
  flip_flop_2bit FF_WB_SEL (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .enable(enableMW),
      .d(wb_sel),
      .q(wb_selMW)
  );
endmodule
