module branch_cond (
    input logic [31:0] rdata1,
    rdata2,
    input logic [2:0] br_type,
    input logic [6:0] opcode,
    output logic br_taken
);
  logic [2:0] BEQ, BNE, BLT, BGE, BLTU, BGEU;
  logic cmp_not_zero, cmp_overflow;
  logic [31:0] cmp_neg;
  logic [32:0] cmp_output;
  assign BEQ = 3'b000;
  assign BNE = 3'b001;
  assign BLT = 3'b100;
  assign BGE = 3'b101;
  assign BLTU = 3'b110;
  assign BGEU = 3'b111;
  assign cmp_output = {1'b0, rdata1} - {1'b0, rdata2};
  assign cmp_not_zero = |cmp_output[31:0];
  assign cmp_neg = cmp_output[31];
  assign cmp_overflow = (cmp_neg & ~rdata1[31] & rdata2[31])|
 (~cmp_neg & rdata1[31] & ~rdata2[31]);
  always_comb begin
    br_taken = 1'h0;
    if (opcode == 7'b1100011) begin
      case (br_type)
        BEQ: br_taken = ~(cmp_not_zero);
        BNE: br_taken = cmp_not_zero;
        BLT: br_taken = (cmp_neg ^ cmp_overflow);
        BLTU: br_taken = cmp_output[32];
        BGE: br_taken = ~(cmp_neg ^ cmp_overflow);
        BGEU: br_taken = ~cmp_output[32];
        default: br_taken = 1'h0;
      endcase
    end else if (opcode == 7'b1101111) begin
      br_taken = 1'h1;
    end else if (opcode == 7'b1100111) begin
      br_taken = 1'h1;
    end else begin
      br_taken = 1'h0;
    end

  end
endmodule
