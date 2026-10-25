// Cycles the RGB LED through red, green, blue and off. The clock comes
// from the FPGA's internal 48MHz oscillator, so the design needs no clock
// pin.

// N is the counter width. The colors change every 2^(N-2) clocks.
// With the default N = 26 and a 48MHz clock, they change about
// every 0.35 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 26
) (
    // The RGB LED pins, active low. [0]=red, [1]=green, [2]=blue.
    output [2:0] rgb_led
);

  // The 48MHz clock from the internal oscillator.
  wire sys_clk;
  hf_osc hf_osc (.clk(sys_clk));

  // The counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The counter's top 2 bits select the color: 11 red, 10 green, 01 blue,
  // 00 no color.
  wire [1:0] sel = counter[N-1:N-2];
  wire red = (sel == 2'b11);
  wire green = (sel == 2'b10);
  wire blue = (sel == 2'b01);

  // Drive the RGB LED.
  rgb_driver rgb_driver (
      .on  ({blue, green, red}),
      .pins(rgb_led)
  );

endmodule
