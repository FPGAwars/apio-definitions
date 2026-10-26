//-----------------------------------------------------------------------------
//-- Generic frequency divider.
//-- (c) BQ. August 2015. written by Juan Gonzalez (obijuan)
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------

`include "divider.vh"

//-- Input: clk_in, the original signal.
//-- Output: clk_out, a signal at 1/M of the original frequency.
module divider (
    input  wire clk_in,
    output wire clk_out
);

  //-- Default divider value.
  //-- Lo ponemos a 1 Hz
  parameter  integer M = `F_2KHz;

  //-- Number of bits to hold the divider.
  //-- It's computed with the Verilog function $clog2, which returns the 
  //-- number of bits needed to represent the number M.
  //-- It's a local parameter, which can't be changed when instantiating.
  localparam integer N = $clog2(M);

  //-- Register for the modulo M counter.
  reg [N-1:0] divcounter = 0;

  //-- The counter's last value. Compared through [N-1:0], to match the
  //-- counter's width.
  localparam integer LAST = M - 1;

  //-- Modulo M counter.
  always @(posedge clk_in) divcounter <= (divcounter == LAST[N-1:0]) ? 0 : divcounter + 1;

  //-- Output the most significant bit on clk_out.
  assign clk_out = divcounter[N-1];

endmodule

//-- Modulo M counter: another way to write it.
/*
always @(posedge clk_in)
  if (divcounter == M - 1) 
    divcounter <= 0;
  else 
    divcounter <= divcounter + 1;
*/

