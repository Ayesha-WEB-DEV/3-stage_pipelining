module mux16_1(
input logic [3:0]s16,
input logic [31:0]a0,[31:0]a1,[31:0]a2,[31:0]a3,[31:0]a4,[31:0]a5,
input logic [31:0]a6,[31:0]a7, [31:0]a8,[31:0]a9,[31:0]a10,[31:0]a11,
input logic [31:0]a12,[31:0]a13,[31:0]a14,[31:0]a15,
output logic [31:0]y16
); 

always_comb begin
case (s16)
4'h0: y16 = a0;
4'h1: y16 = a1;
4'h2: y16 = a2;
4'h3: y16 = a3;
4'h4: y16 = a4;
4'h5: y16 = a5;
4'h6: y16 = a6;
4'h7: y16 = a7;
4'h8: y16 = a8;
4'h9: y16 = a9;
4'hA: y16 = a10;
4'hB: y16 = a11;
4'hC: y16 = a12;
4'hD: y16 = a13;
4'hE: y16 = a14;
4'hF: y16 = a15;
default: y16 = 32'h0;
endcase

end

endmodule
