// Blinks an LED at a rate set by the env in apio.ini. Each env passes a
// different DIV to the design with its 'defines' option.
module main #(
    // Clocks between LED toggles, set by the env's DIV define.
    parameter integer DIV = `DIV
) (
    input        sys_clk,  // 50MHz clock
    output [3:0] leds_n    // LEDs 3 and 2 alternate, the rest are off. Active low.
);

  // Counts clocks from 0 to DIV-1. It starts at 0 when the FPGA is
  // configured.
  reg [31:0] counter = 0;

  // The blinking LED. It starts off.
  reg led = 0;

  // Toggle the LED every DIV clocks.
  always @(posedge sys_clk)
    if (counter == DIV - 1) begin
      counter <= 32'd0;
      led <= ~led;
    end else begin
      counter <= counter + 1;
    end

  // LEDs 3 and 2 alternate, the others are off.
  wire [3:0] leds = {led, ~led, 2'b00};

  // The LEDs are active low, so invert them.
  assign leds_n = ~leds;

endmodule
