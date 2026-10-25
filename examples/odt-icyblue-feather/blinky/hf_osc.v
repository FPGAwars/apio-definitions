// The FPGA's internal 48MHz oscillator (SB_HFOSC). SB_HFOSC can't be
// simulated, so simulations use a simple model instead.

`timescale 1ns / 1ps

module hf_osc (
    output clk  // The 48MHz clock.
);

`ifdef SYNTHESIS

  // The real oscillator. CLKHF_DIV "0b00" selects 48MHz.
  SB_HFOSC #(
      .CLKHF_DIV("0b00")
  ) osc (
      .CLKHFPU(1'b1),
      .CLKHFEN(1'b1),
      .CLKHF  (clk),

      // Unused.
      .TRIM0(),
      .TRIM1(),
      .TRIM2(),
      .TRIM3(),
      .TRIM4(),
      .TRIM5(),
      .TRIM6(),
      .TRIM7(),
      .TRIM8(),
      .TRIM9()
  );

`else

  // Simulation model: a clock with a 10ns period, the same as in the
  // other testbenches.
  reg sim_clk = 0;
  always #5 sim_clk = ~sim_clk;
  assign clk = sim_clk;

`endif

endmodule
