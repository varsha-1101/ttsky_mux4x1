/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_mux4x1 (
    input  wire [7:0] ui_in,    // inputs
    output wire [7:0] uo_out,   // outputs
    input  wire [7:0] uio_in,   // IO input (unused here)
    output wire [7:0] uio_out,  // IO output
    output wire [7:0] uio_oe,   // IO enable
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // -----------------------------
    // 4x1 MUX mapping
    // -----------------------------
    wire d0   = ui_in[0];
    wire d1   = ui_in[1];
    wire d2   = ui_in[2];
    wire d3   = ui_in[3];

    wire sel0 = ui_in[4];
    wire sel1 = ui_in[5];

    wire [1:0] sel = {sel1, sel0};

    reg y;

    always @(*) begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 1'b0;
        endcase
    end

    // Output mapping
    assign uo_out[0] = y;
    assign uo_out[7:1] = 0;

    assign uio_out = 0;
    assign uio_oe  = 0;

    wire _unused = &{ena, clk, rst_n, uio_in};

endmodule
