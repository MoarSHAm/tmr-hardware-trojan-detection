`timescale 1ns/1ps
module uart_rx_byte #(
    parameter CLK_DIV = 8  // adjust for baud rate
)(
    input  wire clk,
    input  wire rx,
    output reg  [7:0] rx_byte,
    output reg        rx_ready
);

    reg [3:0] bit_idx = 0;
    reg [7:0] shift = 0;
    reg [7:0] clk_cnt = 0;
    reg busy = 0;

    always @(posedge clk) begin
        rx_ready <= 0;

        if (!busy) begin
            if (rx == 0) begin // start bit
                busy <= 1;
                clk_cnt <= CLK_DIV;
                bit_idx <= 0;
            end
        end else begin
            if (clk_cnt == 0) begin
                clk_cnt <= CLK_DIV;

                if (bit_idx < 8) begin
                    shift <= {rx, shift[7:1]};
                    bit_idx <= bit_idx + 1;
                end else begin
                    rx_byte <= shift;
                    rx_ready <= 1;
                    busy <= 0;
                end
            end else begin
                clk_cnt <= clk_cnt - 1;
            end
        end
    end
endmodule
