module Forwarding_Unit (
    input logic [31:0] instruction2,
    instruction3,
    input logic reg_wrMW,
    br_taken,
    epc_taken,
    input logic [1:0] wb_selMW,
    output logic forward_A,
    forward_B,
    stall,
    stallMW,
    flush
);
  logic [4:0] rs1_DE, rs2_DE, rs1_MW, rs2_MW, rd_MW;
  logic [6:0] opcode3;
  logic rs1_addr_valid, rs2_addr_valid;
  logic hazard_A, hazard_B;
  assign rs1_DE = instruction2[19:15];
  assign rs2_DE = instruction2[24:20];
  assign rs1_MW = instruction3[19:15];
  assign rs2_MW = instruction3[24:20];
  assign rd_MW = instruction3[11:7];
  assign opcode3 = instruction3[6:0];
  //Control signals for validity of register file read/write operation
  assign rs1_addr_valid = |rs1_DE;
  assign rs2_addr_valid = |rs2_DE;
  assign rd_addr_valid = |rd_MW & reg_wrMW;
  assign hazard_A = ((wb_selMW == 2'b01) && (rs1_DE == rd_MW) && reg_wrMW && rs1_addr_valid);
  assign hazard_B = ((wb_selMW == 2'b01) && (rs2_DE == rd_MW) && reg_wrMW && rs2_addr_valid);
  assign forward_A = !hazard_A;
  assign forward_B = !hazard_B;
  //Since, our Data Memory does not have multi cycle latenncy. So, 
  assign stall = 1'b0;
  assign stallMW = 1'b0;
  always_comb begin
    if (br_taken | epc_taken) begin
      flush = 1'b1;
    end else begin
      flush = 1'b0;
    end
  end
endmodule
