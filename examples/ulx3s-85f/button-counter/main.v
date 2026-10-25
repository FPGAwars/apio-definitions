// The LEDs show a counter and a button: leds[5:0] show the counter's top
// bits, leds[6] shows button FIRE1, and leds[7] is always on.

// N is the counter width. leds[5:0] show its top 6 bits, so leds[0]
// toggles every 2^(N-6) clocks. With the default N = 24 and a 25MHz
// clock, that's about every 0.01 seconds. The testbench uses a small N to
// run quickly.
module main #(
    parameter integer N = 24
) (
    input        sys_clk,    // 25MHz clock
    input        btn,        // Button FIRE1, active high.
    output [7:0] leds,       // Active high.
    output       wifi_gpio0  // Held high, see below.
);

  // Hold the ESP32's GPIO0 high, so it doesn't reset the board.
  assign wifi_gpio0 = 1'b1;

  // Pass the button through a two flip-flop synchronizer.
  reg [1:0] btn_sync = 2'b00;
  always @(posedge sys_clk) btn_sync <= {btn_sync[0], btn};

  // The counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // Show the counter's top bits, the button, and an always-on LED.
  assign leds = {1'b1, btn_sync[1], counter[N-1:N-6]};

endmodule
