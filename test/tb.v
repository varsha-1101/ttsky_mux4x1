`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump waveform
  initial begin
      $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Inputs
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // DUT (Device Under Test)
  tt_um_mux4x1 user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in(ui_in),
      .uo_out(uo_out),
      .uio_in(uio_in),
      .uio_out(uio_out),
      .uio_oe(uio_oe),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  integer i;
  reg [3:0] d;
  reg [1:0] sel;
  reg expected;

  // Test stimulus
  initial begin
    // Initialize
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    #20;
    rst_n = 1;

    // -----------------------------
    // Directed tests
    // -----------------------------
    d = 4'b0001; sel = 2'b00; #10;
    $display("d=%b sel=%b | out=%b", d, sel, uo_out[0]);

    d = 4'b0010; sel = 2'b01; #10;
    $display("d=%b sel=%b | out=%b", d, sel, uo_out[0]);

    d = 4'b0100; sel = 2'b10; #10;
    $display("d=%b sel=%b | out=%b", d, sel, uo_out[0]);

    d = 4'b1000; sel = 2'b11; #10;
    $display("d=%b sel=%b | out=%b", d, sel, uo_out[0]);

    // -----------------------------
    // Random tests
    // -----------------------------
    repeat (16) begin
      d   = $random;
      sel = $random;

      ui_in[3:0] = d;
      ui_in[5:4] = sel;

      #10;

      case (sel)
        2'b00: expected = d[0];
        2'b01: expected = d[1];
        2'b10: expected = d[2];
        2'b11: expected = d[3];
      endcase

      if (uo_out[0] !== expected) begin
        $display("FAIL: d=%b sel=%b got=%b exp=%b",
                  d, sel, uo_out[0], expected);
      end else begin
        $display("PASS: d=%b sel=%b out=%b",
                  d, sel, uo_out[0]);
      end
    end

    #20;
    $finish;

  end

endmodule
