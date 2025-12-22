`timescale 1ns/1ps
module uart_tx_byte #(
    parameter CLK_DIV = 8
)(
    input  wire clk,
    input  wire [7:0] data,
    input  wire send,
    output reg  tx
);

    reg [3:0] bit_idx = 0;
    reg [9:0] shift = 10'b1111111111;
    reg [7:0] clk_cnt = 0;
    reg busy = 0;

    always @(posedge clk) begin
        if (!busy) begin
            if (send) begin
                // start bit (0), data, stop bit (1)
                shift <= {1'b1, data, 1'b0};
                busy <= 1;
                bit_idx <= 0;
                clk_cnt <= CLK_DIV;
            end
            tx <= 1;
        end else begin
            if (clk_cnt == 0) begin
                tx <= shift[0];
                shift <= {1'b1, shift[9:1]};
                clk_cnt <= CLK_DIV;
                bit_idx <= bit_idx + 1;

                if (bit_idx == 9) begin
                    busy <= 0;
                end
            end else begin
                clk_cnt <= clk_cnt - 1;
            end
        end
    end
endmodule
