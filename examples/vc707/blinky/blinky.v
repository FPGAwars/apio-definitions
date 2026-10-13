`default_nettype none

//-- Blinking led (200 MHz differential clock -> ~1.5 Hz on LED0)
module main (
    input  sysclk_p,
    input  sysclk_n,
    output wire [7:0] leds
);

  //-- The VC707's system clock is a 200 MHz LVDS pair: receive it with a
  //-- differential input buffer and put it on a global clock buffer.
  wire clk_raw, clk;
  IBUFDS #(
      .DIFF_TERM("TRUE"),
      .IOSTANDARD("LVDS")
  ) ibufds (
      .I (sysclk_p),
      .IB(sysclk_n),
      .O (clk_raw)
  );
  BUFG bufg (
      .I(clk_raw),
      .O(clk)
  );

  //-- 28-bit counter
  reg [27:0] counter;
  always @(posedge clk) begin
    counter <= counter + 1;
  end

  //-- Show the counter's most significant bit on LED0
  assign leds[0]   = counter[27];

  assign leds[7:1] = 0;

  //-- This is for simulation
  //-- the counter should start in 0
  initial begin
    counter = 0;
  end

endmodule
