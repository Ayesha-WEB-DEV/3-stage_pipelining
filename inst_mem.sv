module inst_mem (
    input  logic [31:0] addr,
    output logic [31:0] instruction1
);
  logic [31:0] inst_memory[256];
  initial begin
    $readmemh("main.mem", inst_memory);
  end
  assign instruction1 = inst_memory[addr[31:2]];
endmodule
