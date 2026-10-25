// Shows the effect of Yosys's -dsp option. The design multiplies two 32 bit
// words. With -dsp, set in apio.ini, Yosys uses the FPGA's DSP blocks
// (ICESTORM_DSP cells) for the multiplier, and without it, logic cells
// (ICESTORM_LC). Compare 'apio report' with and without the option.

module main (

    input  sys_clk,  // 48MHz clock
    input  user_1,  // Touch pad 1, the serial data in.
    output reg    user_2,  // Touch pad 2, the parity of the product.

    // USB Pins (which should be statically driven if not being used).
    output usb_dp,
    output usb_dn,
    output usb_pu
);

  // Prevent the host from trying to connect to this design.
  assign usb_dp = 1'b0;
  assign usb_dn = 1'b0;
  assign usb_pu = 1'b0;

  // The size of each of the serial registers.
  localparam N = 32;

  // The two words we multiply.
  reg [N-1:0] reg1 = 0;
  reg [N-1:0] reg2 = 0;

  always @(posedge sys_clk) begin
    // Shift user_1 through reg1 and then reg2, as one 2 x N bit register.
    reg1   <= {reg1[N-2:0], user_1};
    reg2   <= {reg2[N-2:0], reg1[N-1]};
    // Multiply the words, and output the inverted parity of the product.
    user_2 <= ~^(reg1 * reg2);
  end

endmodule
