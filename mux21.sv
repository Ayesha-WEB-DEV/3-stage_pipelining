module mux21(
input logic s,[31:0]a,[31:0]b,
output logic [31:0]y
);
assign y = s ? b:a;
endmodule
