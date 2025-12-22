`timescale 1ns/1ps

module tmr_trojan_mon_tb;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1;
    reg [7:0] data_in;
    reg trojan_en;

    wire [7:0] data_out;
    wire fault_flag;
    wire sus_trojan;

    tmr_trojan_top_mon uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .trojan_en(trojan_en),
        .data_out(data_out),
        .fault_flag(fault_flag),
        .sus_trojan(sus_trojan)
    );

    initial begin
        $dumpfile("tmr_trojan_temporal.vcd");
        $dumpvars(0, tmr_trojan_mon_tb);

        data_in = 8'h55;
        trojan_en = 0;

        repeat(3) @(posedge clk);
        rst = 0;

        repeat(8) @(posedge clk);

        $display("TRANSIENT FAULT");
        force uut.r_b = 8'hAA;
        repeat(2) @(posedge clk);
        release uut.r_b;

        repeat(10) @(posedge clk);

        $display("TROJAN BYPASS ON");
        trojan_en = 1;
        repeat(10) @(posedge clk);

        trojan_en = 0;
        repeat(10) @(posedge clk);

        $finish;
    end

endmodule
