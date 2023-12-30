module IR_Controller (
    input logic [31:0] instruction2,
    output logic [3:0] alu_op,
    output logic reg_wr,
    sel_A,
    sel_B,
    wr_en,
    rd_en,
    output logic [1:0] wb_sel,
    output logic CSR_reg_rd,
    CSR_reg_wr,
    is_mret
);
  logic [6:0] R_type, I_type, S_type, B_type, LOAD, LUI, AUIPC, JAL, JALR, CSR;
  logic [6:0] opcode, func7;
  logic [2:0] func3;
  logic [3:0] ADD, SUB, SRA, SRL, SLL, AND, OR, XOR, SLT, SLTU, UPPER;
  logic [11:0] func12;
  assign ADD = 4'b0000;
  assign SUB = 4'b0001;
  assign SRA = 4'b0010;
  assign SRL = 4'b0011;
  assign SLL = 4'b0100;
  assign AND = 4'b0101;
  assign OR = 4'b0110;
  assign XOR = 4'b0111;
  assign SLT = 4'b1000;
  assign SLTU = 4'b1001;
  assign UPPER = 4'b1010;
  assign opcode = instruction2[6:0];
  assign R_type = 7'b011_0011;
  assign I_type = 7'b001_0011;
  assign S_type = 7'b010_0011;
  assign B_type = 7'b110_0011;
  assign LOAD = 7'b000_0011;
  assign LUI = 7'b011_0111;
  assign AUIPC = 7'b001_0111;
  assign JAL = 7'b110_1111;
  assign JALR = 7'b110_0111;
  assign CSR = 7'b111_0011;
  assign func12 = instruction2[31:20];
  assign func7 = instruction2[31:25];
  assign func3 = instruction2[14:12];
  always_comb begin
    case (opcode)
      R_type: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b01;
        reg_wr = 1'b1;
        sel_A = 1'b1;
        sel_B = 1'b0;
        case (func7)
          7'b000_0000: begin
            case (func3)
              3'b000: alu_op = ADD;
              3'b001: alu_op = SLL;
              3'b010: alu_op = SLT;
              3'b011: alu_op = SLTU;
              3'b100: alu_op = XOR;
              3'b101: alu_op = SRL;
              3'b110: alu_op = OR;
              3'b111: alu_op = AND;
            endcase
          end
          7'b010_0000: begin
            case (func3)
              3'b000: alu_op = SUB;
              3'b101: alu_op = SRA;
            endcase
          end
        endcase
      end
      I_type: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b01;
        reg_wr = 1'b1;
        sel_A = 1'b1;
        sel_B = 1'b1;
        case (func3)
          3'b000: alu_op = ADD;
          3'b010: alu_op = SLT;
          3'b011: alu_op = SLTU;
          3'b100: alu_op = XOR;
          3'b110: alu_op = OR;
          3'b111: alu_op = AND;
          3'b001: begin
            if (func7 == 7'b0000000) begin
              alu_op = SLL;
            end
          end
          3'b101: begin
            if (func7 == 7'b0000000) begin
              alu_op = SRL;
            end else if (func7 == 7'b0100000) begin
              alu_op = SRA;
            end
          end
        endcase
      end
      LOAD: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b1;
        wr_en = 1'b0;
        wb_sel = 2'b10;
        reg_wr = 1'b1;
        sel_A = 1'b1;
        sel_B = 1'b1;
        alu_op = ADD;
      end
      LUI: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b01;
        reg_wr = 1'b1;
        sel_A = 1'b0;
        sel_B = 1'b1;
        alu_op = UPPER;
      end
      AUIPC: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b01;
        reg_wr = 1'b1;
        sel_A = 1'b0;
        sel_B = 1'b1;
        alu_op = ADD;
      end
      S_type: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b1;
        wb_sel = 2'b10;
        reg_wr = 1'b0;
        sel_A = 1'b1;
        sel_B = 1'b1;
        alu_op = ADD;
      end
      B_type: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b10;
        reg_wr = 1'b0;
        sel_A = 1'b0;
        sel_B = 1'b1;
        alu_op = ADD;
      end
      JAL: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b00;
        reg_wr = 1'b1;
        sel_A = 1'b0;
        sel_B = 1'b1;
        alu_op = ADD;
      end
      CSR: begin
        case (func3)
          3'b001: begin
            rd_en = 1'b1;
            wr_en = 1'b1;
            wb_sel = 2'b11;
            reg_wr = 1'b1;
            sel_A = 1'b0;
            sel_B = 1'b1;
            alu_op = ADD;
            CSR_reg_rd = 1'b1;
            CSR_reg_wr = 1'b1;
            is_mret = 1'b0;
          end
          3'b000: begin
            if (func12 == 12'h302) begin
              rd_en = 1'b1;
              wr_en = 1'b1;
              wb_sel = 2'b11;
              reg_wr = 1'b1;
              sel_A = 1'b0;
              sel_B = 1'b1;
              alu_op = ADD;
              CSR_reg_rd = 1'b0;
              CSR_reg_wr = 1'b0;
              is_mret = 1'b1;
            end
          end
        endcase
      end
      default: begin
        CSR_reg_rd = 1'b0;
        CSR_reg_wr = 1'b0;
        is_mret = 1'b0;
        rd_en = 1'b0;
        wr_en = 1'b0;
        wb_sel = 2'b10;
        reg_wr = 1'b1;
        sel_A = 1'b1;
        sel_B = 1'b0;
        alu_op = ADD;
      end
    endcase
  end
endmodule
