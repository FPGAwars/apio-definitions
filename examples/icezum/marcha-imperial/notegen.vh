//-- Constants with the divider values for the wanted
//-- frequencies.
//-- Note: these constants only work with the 
//-- notegen.v module.

//------- Frequencies of musical notes

// verilog_format: off

//-- Octave: 0
`define DO_0    'h59959  //-- 16.352 Hz
`define DOs_0   'h548E6  //-- 17.324 Hz
`define RE_0    'h4FCF7  //-- 18.354 Hz
`define REs_0   'h4B54C  //-- 19.445 Hz
`define MI_0    'h471A6  //-- 20.602 Hz
`define FA_0    'h431CC  //-- 21.827 Hz
`define FAs_0   'h3F587  //-- 23.125 Hz
`define SOL_0   'h3BCA5  //-- 24.500 Hz
`define SOLs_0  'h386F4  //-- 25.957 Hz
`define LA_0    'h35446  //-- 27.500 Hz
`define LAs_0   'h32470  //-- 29.135 Hz
`define SI_0    'h2F74A  //-- 30.868 Hz


//-- Octave: 1
`define DO_1    'h2CCAC  //-- 32.703 Hz
`define DOs_1   'h2A473  //-- 34.648 Hz
`define RE_1    'h27E7C  //-- 36.708 Hz
`define REs_1   'h25AA6  //-- 38.891 Hz
`define MI_1    'h238D3  //-- 41.203 Hz
`define FA_1    'h218E6  //-- 43.654 Hz
`define FAs_1   'h1FAC4  //-- 46.249 Hz
`define SOL_1   'h1DE52  //-- 48.999 Hz
`define SOLs_1  'h1C37A  //-- 51.913 Hz
`define LA_1    'h1AA23  //-- 55.000 Hz
`define LAs_1   'h19238  //-- 58.270 Hz
`define SI_1    'h17BA5  //-- 61.735 Hz


//-- Octave: 2
`define DO_2    'h16656  //-- 65.406 Hz
`define DOs_2   'h1523A  //-- 69.296 Hz
`define RE_2    'h13F3E  //-- 73.416 Hz
`define REs_2   'h12D53  //-- 77.782 Hz
`define MI_2    'h11C69  //-- 82.407 Hz
`define FA_2    'h10C73  //-- 87.307 Hz
`define FAs_2   'h0FD62  //-- 92.499 Hz
`define SOL_2   'h0EF29  //-- 97.999 Hz
`define SOLs_2  'h0E1BD  //-- 103.826 Hz
`define LA_2    'h0D511  //-- 110.000 Hz
`define LAs_2   'h0C91C  //-- 116.541 Hz
`define SI_2    'h0BDD2  //-- 123.471 Hz


//-- Octave: 3
`define DO_3    'h0B32B  //-- 130.813 Hz
`define DOs_3   'h0A91D  //-- 138.591 Hz
`define RE_3    'h09F9F  //-- 146.832 Hz
`define REs_3   'h096A9  //-- 155.563 Hz
`define MI_3    'h08E35  //-- 164.814 Hz
`define FA_3    'h08639  //-- 174.614 Hz
`define FAs_3   'h07EB1  //-- 184.997 Hz
`define SOL_3   'h07795  //-- 195.998 Hz
`define SOLs_3  'h070DE  //-- 207.652 Hz
`define LA_3    'h06A89  //-- 220.000 Hz
`define LAs_3   'h0648E  //-- 233.082 Hz
`define SI_3    'h05EE9  //-- 246.942 Hz


//-- Octave: 4
`define DO_4    'h05996  //-- 261.626 Hz
`define DOs_4   'h0548E  //-- 277.183 Hz
`define RE_4    'h04FCF  //-- 293.665 Hz
`define REs_4   'h04B55  //-- 311.127 Hz
`define MI_4    'h0471A  //-- 329.628 Hz
`define FA_4    'h0431D  //-- 349.228 Hz
`define FAs_4   'h03F58  //-- 369.994 Hz
`define SOL_4   'h03BCA  //-- 391.995 Hz
`define SOLs_4  'h0386F  //-- 415.305 Hz
`define LA_4    'h03544  //-- 440.000 Hz
`define LAs_4   'h03247  //-- 466.164 Hz
`define SI_4    'h02F75  //-- 493.883 Hz


//-- Octave: 5
`define DO_5    'h02CCB  //-- 523.251 Hz
`define DOs_5   'h02A47  //-- 554.365 Hz
`define RE_5    'h027E8  //-- 587.330 Hz
`define REs_5   'h025AA  //-- 622.254 Hz
`define MI_5    'h0238D  //-- 659.255 Hz
`define FA_5    'h0218E  //-- 698.456 Hz
`define FAs_5   'h01FAC  //-- 739.989 Hz
`define SOL_5   'h01DE5  //-- 783.991 Hz
`define SOLs_5  'h01C38  //-- 830.609 Hz
`define LA_5    'h01AA2  //-- 880.000 Hz
`define LAs_5   'h01924  //-- 932.328 Hz
`define SI_5    'h017BA  //-- 987.767 Hz


//-- Octave: 6
`define DO_6    'h01665  //-- 1046.502 Hz
`define DOs_6   'h01524  //-- 1108.731 Hz
`define RE_6    'h013F4  //-- 1174.659 Hz
`define REs_6   'h012D5  //-- 1244.508 Hz
`define MI_6    'h011C7  //-- 1318.510 Hz
`define FA_6    'h010C7  //-- 1396.913 Hz
`define FAs_6   'h00FD6  //-- 1479.978 Hz
`define SOL_6   'h00EF3  //-- 1567.982 Hz
`define SOLs_6  'h00E1C  //-- 1661.219 Hz
`define LA_6    'h00D51  //-- 1760.000 Hz
`define LAs_6   'h00C92  //-- 1864.655 Hz
`define SI_6    'h00BDD  //-- 1975.533 Hz


//-- Octave: 7
`define DO_7    'h00B33  //-- 2093.005 Hz
`define DOs_7   'h00A92  //-- 2217.461 Hz
`define RE_7    'h009FA  //-- 2349.318 Hz
`define REs_7   'h0096B  //-- 2489.016 Hz
`define MI_7    'h008E3  //-- 2637.020 Hz
`define FA_7    'h00864  //-- 2793.826 Hz
`define FAs_7   'h007EB  //-- 2959.955 Hz
`define SOL_7   'h00779  //-- 3135.963 Hz
`define SOLs_7  'h0070E  //-- 3322.438 Hz
`define LA_7    'h006A9  //-- 3520.000 Hz
`define LAs_7   'h00649  //-- 3729.310 Hz
`define SI_7    'h005EF  //-- 3951.066 Hz


//-- Octave: 8
`define DO_8    'h00599  //-- 4186.009 Hz
`define DOs_8   'h00549  //-- 4434.922 Hz
`define RE_8    'h004FD  //-- 4698.636 Hz
`define REs_8   'h004B5  //-- 4978.032 Hz
`define MI_8    'h00472  //-- 5274.041 Hz
`define FA_8    'h00432  //-- 5587.652 Hz
`define FAs_8   'h003F6  //-- 5919.911 Hz
`define SOL_8   'h003BD  //-- 6271.927 Hz
`define SOLs_8  'h00387  //-- 6644.875 Hz
`define LA_8    'h00354  //-- 7040.000 Hz
`define LAs_8   'h00324  //-- 7458.620 Hz
`define SI_8    'h002F7  //-- 7902.133 Hz


//-- Octave: 9
`define DO_9    'h002CD  //-- 8372.018 Hz
`define DOs_9   'h002A4  //-- 8869.844 Hz
`define RE_9    'h0027E  //-- 9397.273 Hz
`define REs_9   'h0025B  //-- 9956.063 Hz
`define MI_9    'h00239  //-- 10548.082 Hz
`define FA_9    'h00219  //-- 11175.303 Hz
`define FAs_9   'h001FB  //-- 11839.822 Hz
`define SOL_9   'h001DE  //-- 12543.854 Hz
`define SOLs_9  'h001C3  //-- 13289.750 Hz
`define LA_9    'h001AA  //-- 14080.000 Hz
`define LAs_9   'h00192  //-- 14917.240 Hz
`define SI_9    'h0017C  //-- 15804.266 Hz


//-- Octave: 10
`define DO_10   'h00166  //-- 16744.036 Hz
`define DOs_10  'h00152  //-- 17739.688 Hz
`define RE_10   'h0013F  //-- 18794.545 Hz
`define REs_10  'h0012D  //-- 19912.127 Hz
`define MI_10   'h0011C  //-- 21096.164 Hz
`define FA_10   'h0010C  //-- 22350.607 Hz
`define FAs_10  'h000FD  //-- 23679.643 Hz
`define SOL_10  'h000EF  //-- 25087.708 Hz
`define SOLs_10 'h000E2  //-- 26579.501 Hz
`define LA_10   'h000D5  //-- 28160.000 Hz
`define LAs_10  'h000C9  //-- 29834.481 Hz
`define SI_10   'h000BE  //-- 31608.531 Hz

// verilog_format: on
