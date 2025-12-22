`timescale 1ns/1ps

module tmr_trojan_top_mon #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] data_in,
    input  wire             trojan_en,
    output wire [WIDTH-1:0] data_out,
    output wire             fault_flag,
    output wire             sus_trojan
);

    reg [WIDTH-1:0] r_a, r_b, r_c;
    wire [WIDTH-1:0] forged = {WIDTH{1'b0}};

    always @(posedge clk) begin
        if (rst) begin
            r_a <= 0;
            r_b <= 0;
            r_c <= 0;
        end else begin
            r_a <= data_in;
            r_b <= data_in;
            r_c <= trojan_en ? forged : data_in;
        end
    end

    wire [WIDTH-1:0] majority_out;

    tmr_core #(.WIDTH(WIDTH)) voter_inst (
        .in_a(r_a),
        .in_b(r_b),
        .in_c(r_c),
        .voted(majority_out)
    );

    assign data_out = trojan_en ? forged : majority_out;

    tmr_monitor monitor_inst (
        .clk(clk),
        .rst(rst),
        .r_a(r_a),
        .r_b(r_b),
        .r_c(r_c),
        .data_out(data_out),
        .fault_flag(fault_flag),
        .sus_trojan(sus_trojan)
    );

endmodule
