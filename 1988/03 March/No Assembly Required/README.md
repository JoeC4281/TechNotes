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

Decode is used by Getcolor and Setcolor, the sample program. It has three parameters; foreground color, background color, and a character memory variable to hold the result. The color numbers must be between 0 and 15.

```dos
mycolor = ""
SET PROCEDURE TO Colorutl
DO Decode WITH 7, 1, mycolor
```

Mycolor will contain "W/B" when these lines have been executed.

Setcolor.PRG is a program that demonstrates all four of the .BIN files, as well as the two procedures in Colorutil (Figure 1). With Setcolor a user can interactively select normal and enhanced colors from a display. Though it performs the same function as the SetScreen menu, Setcolor can be called directly from a program, and can be used with dBRUN III PLUS, in which the Set menu is not available.

Setcolor uses Attrib to identify the current color settings. With Cchart, it displays the 256 possible combinations of foreground and background colors, and then lets the user select a combination from the display with Go. Instructions are delivered to the user with Clickstr. Go is used a second time to select from a menu of program exit choices.

Before you execute Setcolor, the following five files must exist on the current drive and directory or in the dBASE path:

* Setcolor.PRG
* Colorutl.PRG
* Attrib.BIN
* Go.BIN
* Clickstr.BIN

If Cchart.BIN exists and can be found, it too will be used. Execute Setcolor by typing

```dos
DO Setcolor
```

at the dot prompt, or by including this line in your own program.

##### Creating the .BIN Files

DEBUG.COM, which you will find on the DOS Supplemental Programs Diskette, should be in the current directory or available in the DOS path. If it isn't, copy it to the appropriate directory. To create a DEBUG script file, you'll need an ASCII text editor, or you can use MODIFY FILE and the filename at the dot prompt. Enter the lines for the script file from the end of this article into the text file. The script files have been given a .DBG file extension in order to identify them more easily.

More than ever before, it is important to copy the script lines *exactly*. If lines are omitted or duplicated, DEBUG will probably not catch the error, and the resulting .BIN file will almost certainly hang your computer when called from dBASE III PLUS. There is a common format to all of the script files:

```dos
Nxxxxxxx.BIN
A100
.
. (Assembler instructions)
.

RCX
xxxx
W
Q
```

The first line, beginning with N, names the .BIN file. The second line tells DEBUG to begin accepting assembly language instructions. Following the assembler instructions is a blank line, which tells DEBUG to stop assembling. If this line is omitted, DEBUG will attempt to assemble the remaining lines as assembly instructions (which they are not) and errors will occur.

The RCX line, and the line that follows, tell DEBUG how many bytes are in the .BIN file. The W command writes the new .BIN file to disk and the Q command quits DEBUG. Make sure you place a carriage return after the  Q or you will be left hanging in DEBUG after the .BIN file has been created.

Once you've created a script file, you can create the .BIN file with the command:

```dos
DEBUG < SCRIPT.DBG
```

where SCRIPT.DBG is the name of the script file you've created. If everything goes well, the DEBUG session will be scrolled across the screen, the .BIN file will be created and you will be returned to the DOS prompt.

##### Creating the Sample Programs

Create Getcolor and Colorutl by entering the source code into the two .PRG files. You can use MODIFY COMMAND or another text editor.

##### SETCOLOR.PRG
```dos
* Program ...: Setcolor.PRG
* Author ....: Chuck Litzell
* Date ......: March 1, 1988
* Versions ..: dBASE III PLUS or Developer's Release.
* Notes .....: Sample program to demonstrate use of Attrib.BIN,
*              Go.BIN, Clickstr.BIN and cChart.BIN.
*              Setcolor is an interactive program to set the normal
*              and enhanced colors in dBASE III PLUS. It uses
*              Attrib.BIN to find the current settings, then uses
*              Go.BIN to control selection of the new colors from a
*              color chart on the screen. Go.BIN is also used to
*              select from a "pop-up" exit menu. Clickstr is used to
*              display the prompts. If you don't want to use Clickstr
*              you could collapse the @...SAY and CALL Clickstr lines
*              into one and eliminate the CALL.
*
SET TALK OFF
SET STATUS OFF
SET PROCEDURE TO Colorutl
LOAD Go
LOAD Clickstr
binchart = FILE("Cchart.BIN")
IF binchart
  LOAD Cchart
ENDIF
* ---Find out current color settings.
original = ""
DO Getcolor WITH original
* ---Separate out foreground and background.
onorm = LEFT(original, AT(",", original) - 1)
oenha = STUFF(original, 1, AT(",", original), "")
* ---Draw background screen.
SET COLOR TO
CLEAR
@   3,  5 TO 17, 74 DOUBLE
@   2,  8 TO  4, 28 DOUBLE
@   3,  9 CLEAR TO 18, 47
@   2, 31 TO 19, 48 DOUBLE
@   3, 32 CLEAR TO 18, 47
@   3, 14 SAY "SET COLOR"
* ---Draw sample box for normal colors.
*
SET COLOR TO &onorm
@   6,   7 CLEAR TO 15, 29
@   6,   8 TO 15, 28 DOUBLE
@  10,   9 SAY "    N O R M A L   "
@  11,   9 SAY "    C O L O R S   "
SET COLOR TO
@ 16,  7 CLEAR TO 16, 29
@ 16, (22 - LEN(onorm)) / 2 + 7 SAY onorm
* ---Draw sample box for enhanced colors.
SET COLOR TO &oenha
@  6, 50 CLEAR TO 15, 72
@  6, 51 TO 15,  71 DOUBLE
@ 10, 52 SAY "  E N H A N C E D  "
@ 11, 52 SAY "    C O L O R S    "
SET COLOR TO
@ 16, 51 CLEAR TO 16, 71
@ 16, (22 - LEN(oenha)) / 2 + 51 SAY oenha
IF binchart
   * ---Use the bin solution, if it's available.
   @ 3, 32 SAY ""
   CALL Cchart
ELSE
  * ---dBASE Code to draw color chart.
  * ---The outside DO WHILE loop controls the rows, and the
  * ---inside loop controls the columns. Background varies by
  * ---row and foreground varies by column.
  rowndx = 1
  temp = ""
  DO WHILE rowndx < 17
    colndx = 1
    @ rowndx + 2, 32 SAY SPACE(0)
    DO WHILE colndx < 17
      DO Decode WITH rowndx - 1, colndx - 1, temp
      SET COLOR TO &temp
      @ ROW(), COL() SAY CHR(4)
      colndx = colndx + 1
    ENDDO
    rowndx = rowndx + 1
  ENDDO
ENDIF
* ---Set up default colors.
ncolor = onorm
ecolor = oenha
* ---Initial cursor position.
lastr = 3
lastc = 33
* ---Main input loop.
DO WHILE .T.
  @ 14,  10 SAY ""
  CALL Clickstr WITH "SET NORMAL COLORS"
  * ---Confine cursor to region from 3, 32 TO 18, 47
  * ---Since we can't pass a CHR(0) to Go.BIN, the coordinates
  * ---are offset by 1.
  temp = CHR(3 + 1) + CHR(32 + 1) + CHR(18 + 1) + CHR(47 + 1)
  @ lastr, lastc SAY ""
  CALL Go WITH temp
  IF ASC(SUBSTR(temp, 3)) = 13
    * ---If Return was pressed to exit, extract row and
    * ---column indices and adjust for color numbers.
    lastr = AC(temp) - 1
    lastc = ASC(SUBSTR(temp, 2)) - 1
    DO Decode WITH lastc - 32, Lastr - 3, nocolor
  ENDIF
  * ---Display new sample for normal colors.
  SET COLOR TO &ncolor
  @  6,  7 CLEAR TO 15, 29
  @  6,  8 TO 15, 28 DOUBLE
  @ 10,  9 SAY "    N O R M A L    "
  @ 11,  9 SAY "    C O L O R S    "
  SET COLOR TO
  @ 16,  7 CLEAR TO 16, 29
  @ 16, (22 - LEN(ncolor)) / 2 + 7 SAY ncolor
  *
  * ---Select enhanced colors in the same way.
  *
  @ 14, 52 SAY ""
  CALL Clickstr WITH "SET ENHANCED COLORS"
  temp = CHR(3 + 1) + CHR(32 + 1) + CHR(18 + 1) + CHR(47 + 1)
  @ lastr, lastc SAY ""
  CALL Go WITH temp
  IF ASC(SUBSTR(temp, 3)) = 13
     * ---If Return was pressed to exit, set up new
     * ---enhanced colors.
     lastr = ASC(temp) - 1
     lastc = ASC(SUBSTR(temp, 2)) - 1
     DO Decode WITH lastc - 32, lastr - 3, ecolor
  ENDIF
  * ---Display new sample for normal colors.
  SET COLOR TO &ecolor
  @  6, 50 CLEAR TO 15, 72
  @  6, 51 TO 15, 71 DOUBLE
  @ 10, 52 SAY "  E N H A N C E D "
  @ 11, 52 SAY "    C O L O R S   "
  SET COLOR TO
  @ 16, 51 CLEAR TO 16, 71
  @ 16, (22 - LEN(ecolor)) / 2 + 51 SAY ecolor
  * ---Draw the "popup" menu.
  SET COLOR TO
  @ 17, 58 TO 21, 66 DOUBLE
  @ 18, 59 CLEAR TO 18, 65
  @ 18, 60 SAY "Set"
  @ 19, 60 SAY "Redo"
  @ 20, 60 SAY "Cancel"
  * ---Confine cursor to the three rows and the single column to
  * ---the left of the three menu selections.
  temp = CHR(18 + 1) + CHR(59 + 1) + CHR(20 + 1) + CHR(59 + 1)
  CALL Go WITH temp
  * ---Erase the popup menu.
  @ 17, 58 CLEAR TO 21, 69
  @ 17, 58 TO 17, 69 DOUBLE
  * ---Process the menu selection.
  DO CASE
  CASE ASC(temp) = 21 .OR. ASC(SUBSTR(temp, 3)) = 27
       * ---Return was pressed on Row 20, "Cancel",
       * ---or Escape was pressed.
       * ---Restore original colors and quit.
       SET COLOR TO &original
       EXIT
  CASE ASC(temp) = 19
       * ---Return was pressed on Row 18, "Set".
       * ---Set the new colors and quit
       SET COLOR TO &ncolor, &ecolor
       EXIT
  CASE ASC(temp) =20
       * ---Cursor was pressed on Row 19, "Redo"
       * ---Go back to top of loop.
       LOOP
  ENDCASE
ENDDO
CLEAR
RELEASE MODULE Go
RELEASE MODULE Clickstr
IF binchart
  RELEASE MODULE CChart
ENDIF
CLOSE PROCEDURE
RETURN
* EOP: Setcolor.PRG
```
##### COLORUTL.PRG
```dos
PROCEDURE Getcolor
* Notes(s) ...: Returns a string as appropriate for SET COLOR TO...
*               which represents current color settings. Uses Attrib.BIN
*               to read attributes from the screen. Alters the display
*               cell at row 0, column 0.
*
PARAMETERS colornow
LOAD Attrib
* ---A space for testing colors.
test = SPACE(1)
* ---Strings to pass to Attrib.BIN
normal   = SPACE(2)
enhanced = SPACE(2)
* ---Display test space with enchanced color setting.
@ 0, 0 GET test
CLEAR GETS
* ---Put cursor on the space.
@ 0, 0 SAY SPACE(0)
CALL Attrib WITH enhanced
* ---Display test space with normal color setting.
@ 0, 0 SAY test
* ---Put cursor on the space.
@ 0, 0 SAY SPACE(0)
CALL Attrib WITH normal
DO Decode WITH ASC(normal) - 1,   ASC(SUBSTR(normal, 2)) - 1, normal
DO Decode WITH ASC(enhanced) - 1, ASC(SUBSTR(enhanced, 2)) - 1, enhanced
colornow = normal + "," + enhanced
RELEASE MODULE Attrib
RETURN
* EOP: Getcolor

```
##### ATTRIB.DBG
```dos
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
##### CCHART.DBG
```dos
NCCHART.BIN
A100
PUSH AX
PUSH BX
PUSH CX
PUSH DX
CALL 0131
MOV CX,0010
MOV BL,00
PUSH CX
MOV CX,0010
CALL 013C
MOV AL,04
MOV AH,09
MOV BH,00
INT 10
INC BL
INC DL
LOOP 0110
POP CX
AND BL,F0
SUB DL,10
INC DH
LOOP 010C
POP DX
POP CX
POP BX
POP AX
RETF
PUSH AX
PUSH BX
MOV AH,03
MOV BH,00
INT 10
POP BX
POP AX
RET
PUSH AX
PUSH BX
PUSH DX
MOV AH,02
MOV BH,00
INT 10
POP DX
POP BX
POP AX
RET

RCX
49
W
Q
```
##### CLICKSTR.DBG
```dos
NCLICKSTR.BIN
A100
PUSH AX
PUSH BX
PUSH SI
MOV SI,BX
LODSB
OR AL,AL
JZ 0116
MOV AH,0E
INT 10
CALL 011A
CALL 0137
JMP 0105
POP SI
POP BX
POP AX
RETF
PUSH AX
PUSH CX
CLI
IN AL,61
AND AL,FE
OR AL,02
OUT 61,AL
MOV CX,01F4
LOOP 0128
AND AL,FD
OUT 61,AL
MOV CX,01F4
LOOP 0131
STI
POP CX
POP AX
RET
PUSH AX
PUSH BX
PUSH DX
XOR AX,AX
INT 1A
ADD DX,01
MOV BX,DX
INT 1A
CMP DX,BX
JNZ 0143
POP DX
POP BX
POP AX
RET

RCX
4D
W
Q
```
GO.DBG
```dos
NGO.BIN
A 100
PUSH AX
PUSH CX
PUSH DX
PUSH BX
MOV DH,[BX]
MOV DL,[BX+1]
MOV CH,[BX+2]
MOV CL,[BX+3]
DEC DH
DEC DL
DEC CH
DEC CL
MOV BX,DX
CALL 019F
CALL 01A8
CMP AL,0D
JZ 0191
CMP AL,00
JNZ 0119
CMP AH,4B
JNZ 0131
DEC DL
JMP 0177
NOP
CMP AH,4D
JNZ 013B
INC DL
JMP 0177
NOP
CMP AH,48
JNZ 0145
DEC DH
JMP 0177
NOP
CMP AH,50
JNZ 014F
INC DH
JMP 0177
NOP
CMP AH,47
JNZ 0159
MOV DL,BL
JMP 0177
NOP
CMP AH,4F
JNZ 0163
MOV DL,CL
JMP 0177
NOP
CMP AH,49
JNZ 016D
MOV DH,BH
JMP 0177
NOP
CMP AH,51
JNZ 0119
MOV DH,CH
JMP 0177
NOP
CMP DH,BH
JGE 017D
MOV DH,CH
CM DL,BL
JGE 0183
MOV DL,CL
CMP DH,CH
JLE 0189
MOV DH,BH
CMP DL,CL
JLE 018F
MOV DL,BL
JMP 0119
POP BX
INC DH
INC DL
MOV [BX],DH
MOV [BX+1],DL
POP DX
POP CX
POP AX
RETF
PUSH BX
MOV BH,0
MOV AH,2
INT 10
POP BX
RET
MOV AH,0
INT 16
RET

RCX
AD
W
Q
```
