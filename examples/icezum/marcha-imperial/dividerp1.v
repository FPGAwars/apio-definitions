//-----------------------------------------------------------------------------
//-- Clock divider.
//-- A signal with the given period.
//-- The high pulse is 1 clock cycle wide.
//--
//-- (c) BQ. September 2015. written by Juan Gonzalez (obijuan)
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------
`include "divider.vh"

//-- ENTRADAS:
//--     -sys_clk: The system clock (12MHz on the iCEstick).
//
//-- SALIDAS:
//--     - clk_out: The output pulses, one every M clocks.
//--                Each is 1 sys_clk period wide. NOT A REGISTERED OUTPUT.
module dividerp1 (
    input  wire sys_clk,
    output wire clk_out
);

  //-- Default period, in clocks.
  parameter  M = `T_100ms;

  //-- Number of bits to hold the divider.
  localparam N = $clog2(M);

  //-- Register for the modulo M counter.
  reg [N-1:0] divcounter = 0;

  //-- Modulo M counter.
  always @(posedge sys_clk) divcounter <= (divcounter == M - 1) ? 0 : divcounter + 1;

  //-- Output a pulse 1 clock cycle wide when the counter
  assign clk_out = (divcounter == 0) ? 1 : 0;


endmodule




