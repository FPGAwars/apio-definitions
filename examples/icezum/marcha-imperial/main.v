//-----------------------------------------------------------------------------
//-- Plays a melody stored in a ROM.
//-- The note's 8 least significant bits are shown on the LEDs.
//-----------------------------------------------------------------------------
//-- (C) BQ. October 2015. Written by Juan Gonzalez
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------

//-- Include the divider module's constants.
`include "divider.vh"

//-- Parameteros:
//-- sys_clk: The board's input clock.
//-- buzzer: The output channel.
module main (
    input wire sys_clk,  // 12MHz clock
    output wire [7:0] leds,  // Active high.
    output wire buzzer
);

  //-- Parameters
  //-- Note duration.
  parameter DUR = `T_150ms;

  //-- File with the notes to load into the ROM.
  parameter ROMFILE = "imperial.list";

  //-- Width of the ROM's address bus.
  parameter AW = 8;

  //-- Width of the notes.
  parameter DW = 16;

  //-- The channels' outputs.
  wire ch0, ch1, ch2;

  //-- The multiplexer's channel select.
  reg [AW-1:0] addr = 0;

  //-- Pulses that mark each note's duration.
  wire clk_dur;
  reg rstn = 0;

  wire [DW-1:0] note;

  //-- The ROM.
  genrom #(
      .ROMFILE(ROMFILE),
      .AW(AW),
      .DW(DW)
  ) ROM (
      .sys_clk(sys_clk),
      .addr(addr),
      .data(note)
  );


  //-- The note generator.
  notegen CH0 (
      .sys_clk(sys_clk),
      .rstn(rstn),
      .note(note),
      .clk_out(buzzer)
  );

  //-- Show the note's 8 low bits on the LEDs.
  assign leds = note[7:0];

  //-- Inicializador
  always @(posedge sys_clk) rstn <= 1;


  //-- Counter that selects the note.
  always @(posedge sys_clk) if (clk_dur) addr <= addr + 1;

  //-- Divider that marks each note's duration.
  dividerp1 #(DUR) TIMER0 (
      .sys_clk(sys_clk),
      .clk_out(clk_dur)
  );


endmodule



