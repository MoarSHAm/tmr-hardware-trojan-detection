`timescale 1ns/1ps
module tmr_fpga_top (
    input  wire clk_12mhz,
    input  wire uart_rx,
    output wire uart_tx,
    input  wire btn_trojan,
    output wire led_fault,
    output wire led_trojan
);

    wire clk;
    wire [7:0] data_in;
    wire [7:0] data_out;
    reg trojan_en;

    reg [3:0] div = 0;
    always @(posedge clk_12mhz)
        div <= div + 1;
    assign clk = div[3];

    always @(posedge clk)
        trojan_en <= btn_trojan;

    uart_rx_byte uart_rx_inst (
        .clk(clk),
        .rx(uart_rx),
        .rx_byte(data_in),
        .rx_ready()
    );

    tmr_trojan_top_mon uut (
        .clk(clk),
        .data_in(data_in),
        .trojan_en(trojan_en),
        .data_out(data_out),
        .fault_flag(led_fault),
        .sus_trojan(led_trojan)
    );

    uart_tx_byte uart_tx_inst (
        .clk(clk),
        .data(data_out),
        .send(1'b1),
        .tx(uart_tx)
    );
endmodule
