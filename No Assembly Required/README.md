# TechNotes
March 1988<br>
Page 5

##### No Assembly Required

These four short .BIN programs for use with dBASE III PLUS can en entered with DEBUG, thus avoiding the need for an assembler.

by Chuck Litzell

If you want to interface dBASE III PLUS or the Developer's Release with assembly language programs, you use .BIN files. The LOAD and CALL commands are provided for this purpose. Once you have LOADedd a .BIN file,  CALLing it executes the program and then returns to dBASE III PLUS. Information can be shared between shared between a dBASE program and a .BIN file by CALLing the .BIN file WITH a memory variable. The .BIN file can then read information it needs from the memory variable or store information in it to be passed back to dBASE III PLUS.

In previous months, ***TechNotes*** has published many assembly language programs that can be used with dBASE III PLUS. They require the use of the MASM.EXE, LINK.EXE, and EXE2BIN.EXE programs. MASM, the Microsoft Macro Assembler program, creates an object file (.OBJ extension) from assembly language source programs. LINK processes the .OBJ file, resulting in an .EXE file. The EXE2BIN program creates a .BIN file, which dBASE III PLUS can use, from the .EXE file.

LINK and EXE2BIN are included with DOS. MASM, however, must be purchased from Microsoft. If you don't do much assembly language programming, you probably don't want to buy MASM. Fortunately, other methods of creating .BIN files for dBASE III PLUS are available. One of the simplest methods is to use DEBUG.COM, which is also included with DOS. You can enter assembly language instructions directly into DEBUG and then save the result as a .BIN file.
