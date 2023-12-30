`timescale 1ps / 1ps
module testbench_IR;
  logic clk, reset;
  logic [31:0] interrupt;
  logic [31:0] data_out;
  RISC_V DUT (
      .clk(clk),
      .reset(reset),
      .external_interrupt_occured(interrupt),
      .data_out(data_out)
  );
  initial begin
    clk = 0;
    forever #5 clk <= ~clk;
  end
  initial begin
    reset = 1;
    @(posedge clk) @(posedge clk) reset = 0;
    @(posedge clk) #550 interrupt = 32'h0000_0800;
    #10 interrupt = 32'h0000_0000;
    #10000;
    $stop;
  end
endmodule
