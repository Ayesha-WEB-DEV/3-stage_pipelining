module flip_flop_1bit (
    input  logic clk,
    reset,
    enable,
    flush,
    input  logic d,
    output logic q
);
  always_ff @(posedge clk) begin
    if (reset || flush) begin
      q <= 0;
    end else if (enable) begin
      q <= d;
    end
  end
endmodule

