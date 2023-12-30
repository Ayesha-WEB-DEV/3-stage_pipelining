module reg_file (
    input logic [31:0] instruction2,
    instruction3,
    input logic [31:0] wdata,
    input logic clk,
    reg_wr,
    reset,
    output logic [31:0] rdata1,
    rdata2
);
  logic [4:0] raddr1, raddr2, waddr;
  logic rs1_addr_valid, rs2_addr_valid, rd_addr_valid;
  assign raddr1 = instruction2[19:15];
  assign raddr2 = instruction2[24:20];
  assign waddr  = instruction3[11:7];
  logic [31:0] register[31:0];
  //Control signals for validity of register file read/write operation
  assign rs1_addr_valid = |raddr1;
  assign rs2_addr_valid = |raddr2;
  assign rd_addr_valid = |waddr & reg_wr;
  //Asynchronous read operation for two register operands
  assign rdata1 = (rs1_addr_valid) ? register[raddr1] : '0;
  assign rdata2 = (rs2_addr_valid) ? register[raddr2] : '0;
  always_ff @(negedge clk) begin
    if (reset) begin
      register <= '{default: '0};
    end else if (rd_addr_valid) begin
      register[waddr] <= wdata;
    end
  end
endmodule
