// The ECP5's internal oscillator (OSCG), about 2.4MHz. OSCG can't be
// simulated, so simulations use a simple model instead.

`timescale 1ns / 1ps

module osc (
    output clk  // About 2.4MHz.
);

`ifdef SYNTHESIS

  // The real oscillator. It runs at about 310MHz / DIV.
  OSCG #(.DIV(128)) oscg (.OSC(clk));

`else

  // Simulation model: a clock with a 10ns period, the same as in the
  // other testbenches.
  reg sim_clk = 0;
  always #5 sim_clk = ~sim_clk;
  assign clk = sim_clk;

`endif

endmodule
