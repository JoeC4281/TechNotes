# TechNotes
March 1988<br>
Page 5

##### No Assembly Required

These four short .BIN programs for use with dBASE III PLUS can be entered with DEBUG, thus avoiding the need for an assembler.

by Chuck Litzell

If you want to interface dBASE III PLUS or the Developer's Release with assembly language programs, you use .BIN files. The LOAD and CALL commands are provided for this purpose. Once you have LOADedd a .BIN file,  CALLing it executes the program and then returns to dBASE III PLUS. Information can be shared between shared between a dBASE program and a .BIN file by CALLing the .BIN file WITH a memory variable. The .BIN file can then read information it needs from the memory variable or store information in it to be passed back to dBASE III PLUS.

In previous months, ***TechNotes*** has published many assembly language programs that can be used with dBASE III PLUS. They require the use of the MASM.EXE, LINK.EXE, and EXE2BIN.EXE programs. MASM, the Microsoft Macro Assembler program, creates an object file (.OBJ extension) from assembly language source programs. LINK processes the .OBJ file, resulting in an .EXE file. The EXE2BIN program creates a .BIN file, which dBASE III PLUS can use, from the .EXE file.

LINK and EXE2BIN are included with DOS. MASM, however, must be purchased from Microsoft. If you don't do much assembly language programming, you probably don't want to buy MASM. Fortunately, other methods of creating .BIN files for dBASE III PLUS are available. One of the simplest methods is to use DEBUG.COM, which is also included with DOS. You can enter assembly language instructions directly into DEBUG and then save the result as a .BIN file.

This month, we present four small .BIN files, with source code in a format sutable for input with DEBUG. DEBUG is normally an interactive program, that is, you enter commands into DEBUG and the results are displayed on the screen. However, you can enter all your commands into a text file, and then use the DOS input redirection symbol (<) to tell DEBUG to take input from a file rather than the keyboard. In this way, DEBUG can be used to mimic the behavior of an assembler. The files listed at the end of this article are DEBUG *scripts*, conntaining the DEBUG commands necessary to create .BIN files.

##### Reading Display Attributes

The first .BIN program, Attrib.BIN, reads the attribute of the character on which the cursor is resting when it is CALLed, making the color available to your dBASE program.

Why would you want to find the attribute on a display character? dBASE III PLUS lets you change the colors of the screen with the SET COLOR command or with a COLOR= line in the CONFIG.DB file. Application programs that use SET COLOR replace any color combinations the user may have established. Programming etiquette, however, dictates that we should, as much as possible, leave the computer in the condition we found it. Attrib makes this possible.

When dBASE III PLUS is running, each displayed character requires two bytes of the display adapter's memory. The first byte contains the ASCII value of the character displayed, and the second contains the attribute. The attribute byte is in two parts. The lower half (four bits), holds the attribute for the foreground character, and the upper half holds the attribute for the background. Each half of the attribute byte can hold 16 values, 0 through 15. Thus, there are 256 (16 * 16) possible attribute combinations.

To use Attrib, you need to follow these steps:

1. LOAD Attrib.

2. Position the cursor to a spot on the screen that has the attribute you want to read.

3. Create a memory variable with a t least two characters in it.

4. CALL Attrib WITH the memory variable.
