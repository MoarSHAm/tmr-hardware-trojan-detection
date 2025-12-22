`timescale 1ns/1ps

module tmr_monitor #(
    parameter WIDTH  = 8,
    parameter THRESH = 3   // consecutive mismatches required to flag
)(
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] r_a,
    input  wire [WIDTH-1:0] r_b,
    input  wire [WIDTH-1:0] r_c,
    input  wire [WIDTH-1:0] data_out,
    output reg              fault_flag,
    output reg              sus_trojan
);

    // --------------------------------------------------
    // Current-cycle mismatch detection (combinational)
    // --------------------------------------------------
    wire mismatch_now;
    assign mismatch_now =
        (r_a != r_b) || (r_a != r_c) || (r_b != r_c);

    // --------------------------------------------------
    // Temporal state
    // --------------------------------------------------
    reg [$clog2(THRESH+1)-1:0] mismatch_streak; // consecutive mismatches
    reg [15:0] mismatch_hist;                  // total mismatches
    reg [15:0] bypass_hist;                    // masked mismatches

    // --------------------------------------------------
    // Sequential temporal logic
    // --------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            mismatch_streak <= 0;
            mismatch_hist   <= 0;
            bypass_hist     <= 0;
            fault_flag      <= 0;
            sus_trojan      <= 0;
        end else begin
            // Count total mismatches
            if (mismatch_now)
                mismatch_hist <= mismatch_hist + 1;

            // Count consecutive mismatches
            if (mismatch_now)
                mismatch_streak <= mismatch_streak + 1;
            else
                mismatch_streak <= 0;

            // Count cases where TMR masked the error
            if (mismatch_now &&
                (data_out == r_a || data_out == r_b || data_out == r_c))
                bypass_hist <= bypass_hist + 1;

            // Raise flags only after persistence
            fault_flag <= (mismatch_streak >= THRESH);
            sus_trojan <= (mismatch_streak >= THRESH);
        end
    end

endmodule
