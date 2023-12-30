module immediate_gen (
    input  logic [31:0] instruction,
    output logic [31:0] out,
    output logic [ 6:0] opcode
);
  logic [2:0] func3;
  logic [6:0] R_type, I_type, S_type, B_type, LOAD, LUI, AUIPC, JAL, JALR, CSR;
  assign opcode = instruction[6:0];
  assign func3 = instruction[14:12];
  assign R_type = 7'b0110011;
  assign I_type = 7'b001_0011;
  assign S_type = 7'b010_0011;
  assign B_type = 7'b110_0011;
  assign LOAD = 7'b000_0011;
  assign LUI = 7'b011_0111;
  assign AUIPC = 7'b001_0111;
  assign JAL = 7'b110_1111;
  assign JALR = 7'b110_0111;
  assign CSR = 7'b111_0011;
  always_comb begin
    case (opcode)
      R_type: begin
        out = 32'b0;
      end
      I_type: begin
        case (func3)
          3'b001:  out = {23'b0, instruction[24:20]};
          3'b101:  out = {23'b0, instruction[24:20]};
          default: out = {{20{instruction[31]}}, instruction[31:20]};
        endcase
      end
      S_type: begin
        out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      end
      B_type: begin
        out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      end
      LOAD: begin
        out = {{20{instruction[31]}}, instruction[31:20]};
      end
      LUI: begin
        out = {instruction[31:12], 12'b0};
      end
      AUIPC: begin
        out = {instruction[31:12], 12'b0};
      end
      JAL: begin
        out = {
          {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0
        };
      end
      JALR: begin
        out = {{20{instruction[31]}}, instruction[31:20]};
      end
      CSR: begin
        out = {{20{instruction[31]}}, instruction[31:20]};
      end
    endcase
  end
endmodule

