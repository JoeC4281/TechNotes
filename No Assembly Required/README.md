# TechNotes
March 1988<br>
Page 5

##### No Assembly Required

These four short .BIN programs for use with dBASE III PLUS can en entered with DEBUG, thus avoiding the need for an assembler.

by Chuck Litzell

If you want to interface dBASE III PLUS or the Developer's Release with assembly language programs, you use .BIN files. The LOAD and CALL commands are provided for this purpose. Once you have LOADedd a .BIN file,  CALLing it executes the program and then returns to dBASE III PLUS. Information can be shared between shared between a dBASE program and a .BIN file by CALLing the .BIN file WITH a memory variable. The .BIN file can then read information it needs from the memory variable or store information in it to be passed back to dBASE III PLUS.
