module data_memory (
    input logic [31:0] addr,
    wdata,
    input logic rd_en,
    wr_en,
    clk,
    input logic [2:0] func3,
    output logic [31:0] rdata,
    output logic [31:0] data_out
);
  logic [7:0] data[2048];
  logic [15:0] hw_data;
  logic [7:0] b_data;
  logic [29:0] address_word;
  logic [29:0] address_hw;
  logic [1:0] mask;
  logic [2:0] LB, LH, LW, LBU, LHU, SB, SH, SW;
  assign LB = 3'b000;
  assign LH = 3'b001;
  assign LW = 3'b010;
  assign LBU = 3'b100;
  assign LHU = 3'b101;
  assign SB = 3'b000;
  assign SH = 3'b001;
  assign SW = 3'b010;
  assign address_word = addr[31:2];
  assign address_hw = addr[31:1];
  assign mask = addr[1:0];
  assign data_out = {data[{32'b11}], data[{32'b10}], data[{32'b01}], data[{32'b00}]};
  initial begin
    $readmemh("data.mem", data);
  end
  always_comb begin
    if (rd_en == 1'b1) begin
      case (func3)
        LB: begin
          b_data = data[addr];
          rdata  = {{24{b_data[7]}}, b_data};
        end
        LBU: begin
          b_data = data[addr];
          rdata  = {24'b0, b_data};
        end
        LH: begin
          hw_data = {data[{address_hw, 1'b1}], data[{address_hw, 1'b0}]};
          rdata   = {{16{hw_data[15]}}, hw_data};
        end
        LHU: begin
          hw_data = {data[{address_hw, 1'b1}], data[{address_hw, 1'b0}]};
          rdata   = {16'b0, hw_data};
        end
        LW: begin
          rdata = {
            data[{address_word, 2'b11}],
            data[{address_word, 2'b10}],
            data[{address_word, 2'b01}],
            data[{address_word, 2'b00}]
          };
        end
        default: rdata = 32'b0;
      endcase
    end
  end
  always_ff @(negedge clk) begin
    if (wr_en == 1'b1) begin
      case (func3)
        SW: begin
          data[{address_word, 2'b00}] <= wdata[7:0];
          data[{address_word, 2'b01}] <= wdata[15:8];
          data[{address_word, 2'b10}] <= wdata[23:16];
          data[{address_word, 2'b11}] <= wdata[31:24];
        end
        SH: begin
          //if (mask[1] == 0) begin
          data[{address_hw, 1'b0}] <= wdata[7:0];
          data[{address_hw, 1'b1}] <= wdata[15:8];
        end
        // else if (mask[1] == 1) begin
        // data[addr] <= wdata[23:16];
        // data[addr+1] <= wdata[31:24]; end end
        SB: begin
          //if (mask == 2'b00) begin
          data[addr] <= wdata[7:0];
          // end else if (mask == 2'b01) begin
          // data[address_word][15:8] <= wdata[15:8]; end
          // if (mask == 2'b10) begin
          // data[address_word][23:16] <= wdata[23:16]; end
          // if (mask == 2'b11) begin
          // data[address_word][31:24] <= wdata[31:24]; end
        end
      endcase
      $writememh("data.txt", data);
    end
  end
endmodule

