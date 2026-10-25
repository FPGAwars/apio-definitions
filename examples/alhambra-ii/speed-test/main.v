// Tests the speed of a WIDTH bits adder. Each env in apio.ini
// sets another width. To see the max clock speed, run e.g.
//   apio report -e width-256

module main #(
    // The adder width. The default comes from the macro WIDTH that
    // apio.ini defines for each env.
    parameter integer WIDTH = `WIDTH
) (
    input  sys_clk,  // 12MHz clock
    output led       // The counter's top bit, active high.
);

  // The counter. It starts at 0 when the FPGA is configured.
  reg [WIDTH-1:0] counter = 0;

  // Add 7 on every clock.
  always @(posedge sys_clk) counter <= counter + 7;

  // Output the top bit so the adder is not optimized away.
  assign led = counter[WIDTH-1];

endmodule
