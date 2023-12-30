module flip_flop_pc (
    input logic clk,
    reset,
    enable,
    input logic [31:0] d,
    output logic [31:0] q
);
  always_ff @(posedge clk) begin
    if (reset) begin
      q <= 0;
    end else if (enable) begin
      q <= d;
    end
  end
endmodule
