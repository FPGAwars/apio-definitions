#------------------------------------------------------------------------------
#-- Generates the tables with the frequencies and the divider
#-- values for playing all the musical notes on the iCEstick.
#--
#-- It prints all the constants in Verilog, so the table can be
#-- included directly in our designs.
#------------------------------------------------------------------------------
#-- (C) BQ. September-2015. Written by Juan Gonzalez (Obijuan)
#------------------------------------------------------------------------------
import math as m

#---------------------------------------------
#-- Octaves: 0 - 10
#-- Notes: 1 - 12, in solfege (DO is C, RE is D, and so on)
#--    1 - DO
#--    2 - DO#
#--    3 - RE
#--    4 - RE#
#--    5 - MI
#--    6 - FA
#--    7 - FA#
#--    8 - SOL
#--    9 - SOL#
#--    10 - LA
#--    11 - LA#
#--    12 - SI

##-- Dictionary with the note names.
nname = {1: 'DO',   2: 'DOs', 3: 'RE',   4 : 'REs',
         5: 'MI',   6: 'FA',  7: 'FAs',  8: 'SOL',
         9: 'SOLs', 10: 'LA', 11: 'LAs', 12: 'SI'};

#-- Compute the frequency of a note in an octave.
def freq(note, octave = 4):
	return 440.0 * m.exp(((octave-4)+(note-10)/12.0) * m.log(2))
	
#-- Compute the divider value for playing the note on the FPGA
#-- of the iCEstick board.
def divisor(note, octave = 4):
	return int(round(12000000 / (2*freq(note, octave))))

#-- Print the table, as Verilog.
def print_table(octave = 4):
	print("//-- Octave: {}".format(octave))
	for note in range(12):
		#-- Print table in verilog sintax
		print("`define {:7} 'h{:05X}  //-- {:.3f} Hz".format(
		       f"{nname[note + 1]}_{octave}", 
		       divisor(note+1, octave), 
		       freq(note+1, octave)))
	print("\n")

#-- Programa principal
#-- Print the table on the screen.
for oct in range(11):
	print_table(oct)





