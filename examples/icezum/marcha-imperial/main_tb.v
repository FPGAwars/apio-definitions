// Testbench for main.v.
// Run it in batch mode with 'apio test', or view the signals
// in GTKWave with 'apio sim'.

// Checks that 'actual_val' equals 'expected_val'. On a mismatch, prints
// the values and location, sets assertion_err, and stops the simulation.
// Under 'apio sim' the simulation continues so the signals can be viewed.
`define EXPECT_EQ(actual_val, expected_val) \
  if ((actual_val) !== (expected_val)) begin \
    $display("*** ASSERTION FAILED at %s:%0d: expected 'h%h, actual 'h%h", \
             `__FILE__, `__LINE__, (expected_val), (actual_val)); \
    assertion_err = 1; \
    if (!`APIO_SIM) $fatal; \
  end

`timescale 1ns / 1ps

module main_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The signals driven by the design.
  wire [7:0] leds;
  wire buzzer;

  // Clocks per note, reduced to run quickly.
  localparam integer DUR = 3;

  main #(
      .DUR(DUR)
  ) dut (
      .sys_clk(sys_clk),
      .leds(leds),
      .buzzer(buzzer)
  );

  // The ROM address and note as of the previous clock.
  reg [7:0] prev_addr;
  reg [15:0] prev_note;

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // The ROM address goes up every DUR clocks, the first time at clock
    // 1. The note is the ROM entry at the previous clock's address, and
    // the LEDs show its low byte. During a rest (note 0) the buzzer is
    // silent.
    for (i = 1; i <= 60; i = i + 1) begin
      prev_addr = dut.addr;
      prev_note = dut.note;
      @(posedge sys_clk);
      #1;
      `EXPECT_EQ(dut.addr, ((i - 1) /DUR + 1) % 256)
      `EXPECT_EQ(dut.note, dut.ROM.rom[prev_addr])
      `EXPECT_EQ(leds, dut.note[7:0])
      if (i > 1 && prev_note == 0) `EXPECT_EQ(buzzer, 1'b0)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
