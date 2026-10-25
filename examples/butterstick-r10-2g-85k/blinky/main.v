//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

// N is the counter width. led toggles every 2^(N-1) clocks.
// With the default N = 25 and a 30MHz clock, it toggles about
// every 0.6 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 25
) (
    input        sys_clk,   // 30MHz clock
    output       led,       // The blinking LED, active high.
    output [2:0] led_color  // Selects the LED color, active high.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The LED follows the counter's top bit.
  assign led = counter[N-1];

  // Select the blue color.
  assign led_color = 3'b010;

endmodule
