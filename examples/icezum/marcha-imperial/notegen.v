//-----------------------------------------------------------------------------
//-- Frequency divider that generates musical notes.
//-- (c) BQ. October 2015. written by Juan Gonzalez (obijuan)
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------
//-- It's made of two dividers in a chain. The first one makes a pulse
//-- 1 clock cycle wide, at twice the note's frequency.
//-- That signal goes through a divide-by-2, which makes a signal with
//-- a 50% duty cycle at the note's frequency.
//-----------------------------------------------------------------------------

module notegen (
    input  wire        sys_clk,  //-- The global clock.
    input  wire        rstn,     //-- Reset
    input  wire [15:0] note,     //-- Divider.
    output reg         clk_out
);  //-- Output signal.

  wire clk_tmp;

  //-- Register for the modulo note counter.
  reg [15:0] divcounter = 0;

  //-- Modulo note counter.
  always @(posedge sys_clk)

    //-- Reset
    if (rstn == 0)
      divcounter <= 0;

    //-- If the note is 0, don't count.
    else if (note == 0) divcounter <= 0;

    //-- On reaching the top, go back to 0.
    else if (divcounter == note - 1) divcounter <= 0;

    //-- Count up.
    else
      divcounter <= divcounter + 1;

  //-- Output a pulse 1 clock cycle wide when the counter
  assign clk_tmp = (divcounter == 0) ? 1 : 0;

  //-- Divide the frequency by 2, to output a signal
  //-- with a 50% duty cycle.
  always @(posedge sys_clk)
    if (rstn == 0) clk_out <= 0;

    else if (note == 0) clk_out <= 0;

    else if (clk_tmp == 1) clk_out <= ~clk_out;

endmodule



