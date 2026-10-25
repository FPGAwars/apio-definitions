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

  // The LEDs driven by the design.
  wire [7:0] leds;

  main dut (
      .sys_clk(sys_clk),
      .leds(leds)
  );

  // Models of the first pattern counter and BRAM address counter.
  reg [31:0] counter1 = 32'h1234_5678;
  reg [7:0] bram_addr1 = 8'h00;

  // The LEDs after the warm-up, and whether they changed since.
  reg [7:0] first_leds;
  reg leds_changed = 0;

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // The counters step by fixed amounts on every clock. After a 100
    // clock warm-up, while the pipelines fill, the LEDs are never X or Z,
    // and they change at least once.
    for (i = 1; i <= 2000; i = i + 1) begin
      @(posedge sys_clk);
      counter1   = counter1 + 32'h1_2345;
      bram_addr1 = bram_addr1 + 1;
      #1;
      `EXPECT_EQ(dut.counter1, counter1)
      `EXPECT_EQ(dut.bram_addr1, bram_addr1)
      if (i >= 100) `EXPECT_EQ(^leds === 1'bx, 1'b0)
      if (i == 100) first_leds = leds;
      if (i > 100 && leds != first_leds) leds_changed = 1;
    end
    `EXPECT_EQ(leds_changed, 1'b1)

    $display("End of simulation");
    $finish;
  end

endmodule
