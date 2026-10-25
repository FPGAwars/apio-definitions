// Tests the speed of a WIDTH bit adder: a counter that adds 7 on every
// clock. 'apio report' shows the highest clock frequency it can run at.
// To run:
//   apio report -e width-256
//   apio report -e width-128
//   apio report -e width-64
//   apio report -e width-32
//   apio report -e width-16
//   apio report -e width-8

module main #(
    parameter integer WIDTH = `WIDTH
) (
    input  sys_clk,  // 27MHz clock
    output led_n     // The counter's top bit, on an LED, active low.
);

  // The counter. It starts at 0 when the FPGA is configured.
  reg [WIDTH-1:0] counter = 0;

  // Add 7 on every clock.
  always @(posedge sys_clk) counter <= counter + 7;

  // Show the counter's top bit, so the design keeps the whole adder.
  assign led_n = ~counter[WIDTH-1];

endmodule
