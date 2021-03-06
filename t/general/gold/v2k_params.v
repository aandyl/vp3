// Generated by vp3

//|@Module -v2k;
module v2k_params (
      input wire  i
    , output wire  o
);

subA #(.p1 (1), .p2 (2)) sa (.i(i), .o(o));

subB #(.p1 (1), .p2 (2)) sb (.i(i), .o(o));

endmodule

module subA #(parameter p1 = 22, p2 = 23) (input i, output o);

assign o = i;

endmodule

module subB #(parameter p1 = 22, parameter p2 = 23) (input i, output o);

assign o = i;

endmodule
