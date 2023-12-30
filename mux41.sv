module mux41(
input logic [1:0]sel,[31:0]a,[31:0]b,[31:0]c,[31:0]d,
output logic [31:0]y
);
    logic [31:0]x1; 
    logic[31:0]x2;
    mux21 m0(.a(a), .b(b), .s(sel[0]),.y(x1));
    mux21 m1(.a(c), .b(d), .s(sel[0]),.y(x2));
    mux21 m2(.a(x1),.b(x2),.s(sel[1]),.y(y)); 
endmodule
