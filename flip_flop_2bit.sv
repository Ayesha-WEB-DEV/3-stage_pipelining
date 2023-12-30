module flip_flop_2bit (
    input logic clk,
    reset,
    enable,
    flush,
    input logic [1:0] d,
    output logic [1:0] q
);
  always_ff @(posedge clk) begin
    if (reset || flush) begin
      q <= 0;
    end else if (enable) begin
      q <= d;
    end
  end
endmodule

