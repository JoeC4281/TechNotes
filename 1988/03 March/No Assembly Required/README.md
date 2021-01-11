# TechNotes
March 1988<br>
Page 5

##### No Assembly Required

These four short .BIN programs for use with dBASE III PLUS can be entered with DEBUG, thus avoiding the need for an assembler.

by Chuck Litzell

If you want to interface dBASE III PLUS or the Developer's Release with assembly language programs, you use .BIN files. The LOAD and CALL commands are provided for this purpose. Once you have LOADed a .BIN file,  CALLing it executes the program and then returns to dBASE III PLUS. Information can be shared between shared between a dBASE program and a .BIN file by CALLing the .BIN file WITH a memory variable. The .BIN file can then read information it needs from the memory variable or store information in it to be passed back to dBASE III PLUS.

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

When you've completed these four steps, the first character of the memory variable will contain the value of the foreground attribute, and the second character will contain the value of the background attribute. The values are stored in CHR() format and have been offset by 1 to avoid CHR(0). This means each of the first two characters will contain values between CHR(1) and CHR(16).

The sample program, Getcolor.PRG, can be used to find the current color settings. It calls Attrib and translates the results to strings appropriate for the SET COLOR command.

##### Go Your own Way

Go.BIN is the longest of the DEBUG scripts because it has a lot of work to do. With this .BIN file you define a region of the display by naming the coordinates of the upper-left and bottom-right corners of a rectangle. The cursor can be moved anywhere within the rectangle using the four arrow keys, **Home**, **End**, **PgUp**, and **PgDn**. When you attempt to move the cursor outside of the defined rectangle, it wraps to the opposite edge. Go terminates when **Return** or **Esc** are pressed. It then stores the row, column, and exit key (**Return** or **Esc**) in the first three characters of the memory variable it is CALLed with.

Go is useful in programs for getting user input. By defining a rectangle around a list of selections, you can let the user select visually from a menu. Since it is written in assembly language, Go is much faster (and smaller) than the equivalent code written in dBASE.

The coordinates of the rectangle are established by CALLing Go with a four-character memory variable. Again, it is necessary to offset the coordinates by 1 since dBASE doesn't recognize CHR(0) as data.

```dos
Memvar = CHR(toprow    + 1) + CHR(leftcol  + 1) +;
         CHR(bottomrow + 1) + CHR(rightcol + 1)
```


If you want to establish a default position within the rectangle, put the cursor there before CALLing Go. This can be accomplished by using the @...SAY command to display SPACE(0).

```dos
@ toprow, leftcol SAY SPACE(0)
CALL Go WITH memvar
```

When Go returns, the first character of the memory variable contains the selected row, the second character contains the selected column, and the third byte contains CHR(13) if **Return** was pressed or CHR(27) if **Esc** was pressed. Again, the row and column are offset by 1.

##### Click...Click
Clickstr.BIN is basically for fun, but fun programs make users happy and keep programmers solvent. Clickstr displays a string with an audible click for each character, giving the appearance that the string is being typed out. It can be used when you want  the user to take special note of a message, such as an error or exception message.

The string is displayed beginning at the cursor position. The characters are displayed using the existing colors. Clickstr controls the delay between characters by monitoring the system clock. Though the pitch of the click will vary, the rate at which the string is displayed will be constant regardless of the speed of the CPU on which the program runs.

```dos
LOAD Clickstr
* ---Position cursor to starting column.
@ 10, 12 say ""
CALL Clickstr WITH "Welcome to WonderWizz"
RELEASE MEMORY Clickstr
```

##### Chart of Many Colors
Cchart.BIN is a program that meets a very specific need. It displays the 256 possible color comination in a 16-column by 16-row chart, with the upper-left column at the current cursor position. It was written specifically for use by Setcolor.PRG, the demonstration program that makes use of all four .BIN files.

Since Cchart is so specific, you might not want to bother creating it. Setcolor tests for the existence of Cchart.BIN. If it doesn't exist, the color chart will be drawn with dBASE III PLUS commands instead. Since there are 256 colors possible, 256 SET COLOR commands must be interpreted and executed, and the color chart may take as long as a minute to be drawn. On the other hand, if you create Cchart.BIN the chart is drawn almost instantly.

##### **Sample Programs**

To make practical use of Attrib, you'll need a way to translate the values it returns into SET COLOR commands. Colorutl.PRG is a procedure file that contains a pair of procedures--Getcolor and Decode--that take care of this task. Getcolor uses Attrib and Decode to determine the current color settings for both the normal colors and enhanced colors. These values are translated into a string that can be used with the SET COLOR command when your program completes. To use Getcolor, you need to create a character memory variable to hold the color list, then execute the program.

```dos
usercolor = ""
SET PROCEDURE TO Colorutl
DO Getcolor WITH usercolor
```

Getcolor uses the first position on the screen (0,0) to display a space with the enhanced colors, and then a space with the normal colors. Attrib reads the color values from the display. The program leaves a space in position (0,0) when it has finished. If some other character belongs in this position in your application, you will need to restore it when Getcolor has finished, or change the coordinates in Getcolor to a position that will not disturb the display.

The Decode procedure creates part of a SET COLOR string by translating two numbers, a foreground color and a background color, into the equivalent letter codes. Decode uses ISCOLOR() to determine if the display adatper is color or monochrome, and translates the numbers accordingly. There are 256 different color combinations when a color display adapter is in use, but a monochrome adapter can display only 16 combinations of white, black, blink, underline, and bright. Therefore, Decode uses two quite different algorithms to translate from numbers to letters. When a color display adapter is in use, Decode extracts the letters from a string. With a monochrome adapter, a DO CASE is used to test for specific attributes.

```dos
ATTRIB.DBG
NATTRIB.BIN
A100
PUSH AX
PUSH CX
PUSH BX
MOV AH,08
MOV BH,00
INT 10
MOV AL,AH
AND AL,0F
MOV CL,04
SHR AH,CL
INC AL
INC AH
POP BX
MOV [BX],AL
MOV [01+BX],AH
POP CX
POP AX
RETF

RCX
1E
W
Q
```
