module alu(
input logic [31:0]a,[31:0]b,[3:0]op,
output logic [31:0]o);

logic [31:0]w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,x1;
logic [31:0]z;
logic [31:0]o1;

assign z=32'd0;

mux21 C1(.a(b), .b(~b), .s(op[0]),.y(x1));
add a1 (.a(a), .b(x1), .c(op[0]), .s(w1)); 

assign w2 = $signed(a)>>>$signed(b);
assign w3 = a>>b;
assign w4 = a<<<b;
assign w5 = a&b;
assign w6 = a|b;
assign w7 = a^b;
assign w8 = $signed(a)<$signed(b)?1:0;
assign w9 = a<b?1:0;
assign w10= b;

mux16_1 C0(.a0(w1), .a1(w1), .a2(w2), .a3(w3), .a4(w4), .a5(w5), .a6(w6), 
 .a7(w7), .a8(w8), .a9(w9), .a10(w10), .a11(z), .a12(z), .a13(z), .a14(z), 
 .a15(z), .s16(op), .y16(o));

endmodule


