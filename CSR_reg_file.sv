module CSR_reg_file (
    input logic [31:0] PC,
    wdata,
    input logic [31:0] Address,
    input logic [31:0] interrupt,
    input logic reg_wr,
    reg_rd,
    is_mret,
    input logic clk,
    reset,
    output logic [31:0] epc,
    csr_rdata,
    output logic epc_taken
);
  logic csr_mip_wr_flag, csr_mie_wr_flag, csr_mstatus_wr_flag;
  logic csr_mcause_wr_flag, csr_mtvec_wr_flag, csr_mepc_wr_flag;
  logic [31:0] csr_mip, csr_mie, csr_mstatus, csr_mcause, csr_mtvec, csr_mepc;
  logic [11:0] CSR_ADDR_MIP, CSR_ADDR_MIE, CSR_ADDR_MSTATUS, CSR_ADDR_MCAUSE;
  logic [11:0] CSR_ADDR_MTVEC, CSR_ADDR_MEPC;
  logic [11:0] Addr;
  logic interrupt_occured;
  logic [31:0] timer_interrupt;
  logic [31:0] external_interrupt;
  logic [31:0] vector_in, non_vector_in, vector_out;
  assign Addr = Address[11:0];
  assign CSR_ADDR_MIP = 12'h344;
  assign CSR_ADDR_MIE = 12'h304;
  assign CSR_ADDR_MSTATUS = 12'h300;
  assign CSR_ADDR_MCAUSE = 12'h342;
  assign CSR_ADDR_MTVEC = 12'h305;
  assign CSR_ADDR_MEPC = 12'h341;
  assign timer_interrupt = 32'h0000_0080;
  assign external_interrupt = 32'h0000_0800;
  //assign csr_mepc = 32'h04;
  assign interrupt_occured = (((csr_mip[7] && csr_mie[7]) || (csr_mip[11] &&
 csr_mie[11])) && csr_mstatus[3]);
  assign vector_in = (csr_mcause << 2) + {csr_mtvec[31:2], 2'b00};
  assign non_vector_in = {csr_mtvec[31:2], 2'b00};
  assign epc_taken = is_mret | interrupt_occured;
  mux21 MUX_VECTOR (
      .s(csr_mtvec[0]),
      .a(non_vector_in),
      .b(vector_in),
      .y(vector_out)
  );
  mux21 MUX_IS_MRET (
      .s(is_mret),
      .a(vector_out),
      .b(csr_mepc),
      .y(epc)
  );
  // CSR Read Operation
  always_comb begin
    csr_rdata = 32'b0;
    if (reg_rd) begin
      case (Addr)
        CSR_ADDR_MIP: csr_rdata = csr_mip;
        CSR_ADDR_MIE: csr_rdata = csr_mie;
        CSR_ADDR_MSTATUS: csr_rdata = csr_mstatus;
        CSR_ADDR_MCAUSE: csr_rdata = csr_mcause;
        CSR_ADDR_MTVEC: csr_rdata = csr_mtvec;
        CSR_ADDR_MEPC: csr_rdata = csr_mepc;
      endcase
    end
  end
  // CSR Write Operation
  always_comb begin
    csr_mip_wr_flag = 1'b0;
    csr_mie_wr_flag = 1'b0;
    csr_mstatus_wr_flag = 1'b0;
    csr_mcause_wr_flag = 1'b0;
    csr_mtvec_wr_flag = 1'b0;
    csr_mepc_wr_flag = 1'b0;
    if (reg_wr) begin
      case (Addr)
        CSR_ADDR_MIP: csr_mip_wr_flag = 1'b1;
        CSR_ADDR_MIE: csr_mie_wr_flag = 1'b1;
        CSR_ADDR_MSTATUS: csr_mstatus_wr_flag = 1'b1;
        CSR_ADDR_MCAUSE: csr_mcause_wr_flag = 1'b1;
        CSR_ADDR_MTVEC: csr_mtvec_wr_flag = 1'b1;
        CSR_ADDR_MEPC: csr_mepc_wr_flag = 1'b1;
      endcase
    end
  end
  // Update the mip (Machine Interrupt Pending) CSR
  always_ff @(posedge clk) begin
    if (reset) begin
      csr_mip <= {32{1'b0}};
    end else begin
      if (csr_mip_wr_flag) begin
        csr_mip <= wdata;
      end
      // Timer Interrupt Pending
      if (interrupt[7] == 1'b1) begin
        csr_mip[7] <= 1'b1;
      end else begin
        csr_mip[7] <= 1'b0;
      end
      // External Interrupt Pending
      if (interrupt[11] == 1'b1) begin
        csr_mip[11] <= 1'b1;
      end else begin
        csr_mip[11] <= 1'b0;
      end
    end
  end
  // Update the mie (Machine Interrupt Enable) CSR
  always_ff @(posedge clk) begin
    if (reset) begin
      csr_mie <= {32{1'b0}};
    end else if (csr_mie_wr_flag) begin
      csr_mie <= wdata;
    end
  end
  // Update the mstatus (Machine Status) CSR
  always_ff @(posedge clk) begin
    if (reset) begin
      csr_mstatus <= {32{1'b0}};
    end else if (csr_mstatus_wr_flag) begin
      csr_mstatus <= wdata;
    end
  end
  // Update the mcause (Machine Trap Cause) CSR
  always_ff @(posedge clk) begin
    if (reset) begin
      csr_mcause <= {32{1'b0}};
    end else begin
      if (csr_mcause_wr_flag) begin
        csr_mcause <= wdata;
      end
      // Timer Interrupt Pending
      if (interrupt[7] == 1'b1) begin
        csr_mcause <= (csr_mcause | 32'b1);
      end
      // External Interrupt Pending
      if (interrupt[11] == 1'b1) begin
        csr_mcause <= (csr_mcause & (~(32'b01)));
      end
    end
  end
  // Update the mtvec (Machine Trap Handler Base Address) CSR
  always_ff @(posedge clk) begin
    if (reset) begin
      csr_mtvec <= {32{1'b0}};
    end else if (csr_mtvec_wr_flag) begin
      csr_mtvec <= wdata;
    end
  end
  // Update the mepc (Machine Exception Program Counter) CSR
  always_ff @(posedge clk) begin
    if (reset) begin
      csr_mepc <= {32{1'b0}};
    end else if (interrupt_occured) begin
      csr_mepc <= PC;
    end else if (csr_mepc_wr_flag) begin
      csr_mepc <= wdata;
    end
  end
endmodule
