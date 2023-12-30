module add(
input logic c,[31:0]a,[31:0]b,
output logic [31:0]s
 );
assign s = a+b+c;
endmodule

