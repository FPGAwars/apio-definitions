//----------------------------------------------------------------------------
//-- Generic ROM.
//------------------------------------------
//-- (C) BQ. October 2015. Written by Juan Gonzalez (Obijuan)
//-- GPL license
//----------------------------------------------------------------------------
//-- A memory with these parameters:
//--  * AW: Number of address bits.
//--  * DW: Number of data bits.
//--  * ROMFILE: The file to load into the memory.
//--
//-- With this module we can make ROMs of any size.
//----------------------------------------------------------------------------

module genrom #(  //-- Parameters
    //-- Parameter: name of the file with the ROM's contents.
    parameter ROMFILE = "rom1.list",
    parameter AW = 5,  //-- Address bits (address width).
    parameter DW = 4
)  //-- Data bits (data width).

(  //-- Puertos
    input                sys_clk,  //-- The global clock.
    input  wire [AW-1:0] addr,     //-- Address.
    output reg  [DW-1:0] data
);  //-- Output data.

  //-- Compute the total number of memory locations.
  localparam NPOS = 2 ** AW;

  //-- The memory.
  reg [DW-1:0] rom[0:NPOS-1];

  //-- Read the memory.
  always @(posedge sys_clk) begin
    data <= rom[addr];
  end

  //-- Load the file ROMFILE into the memory.
  //-- The values must be in hexadecimal.
  initial begin
    $readmemh(ROMFILE, rom);
  end


endmodule



