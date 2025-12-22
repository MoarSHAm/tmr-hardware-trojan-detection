`timescale 1ns/1ps

// Bitwise majority voter for 3 channels.
module tmr_core #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] in_a,
    input  wire [WIDTH-1:0] in_b,
    input  wire [WIDTH-1:0] in_c,
    output wire [WIDTH-1:0] voted
);
    assign voted = (in_a & in_b) | (in_a & in_c) | (in_b & in_c);
endmodule
