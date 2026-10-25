// Sets the colors of the RGB LED with three switches.
module main (
    input  [2:0] sws,       // Switches sw0 to sw2, polarity unknown.
    output [2:0] rgb_led_n  // RGB LED, active low. [0]=red, [1]=green, [2]=blue.
);

  // Each color pin follows a switch: red sw2, green sw1, blue sw0.
  assign rgb_led_n = {sws[0], sws[1], sws[2]};

endmodule
