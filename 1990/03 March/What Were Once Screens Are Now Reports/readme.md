What Were Once Screens
Are Now Reports

BRYAN FLYNN

Editors Note:

Since this article discusses the use of .GEN files and Template
Language, you will need the Template Language compiler and
documentation which is included only with the Developer's
Edition of dBASE IV. For those with the standard edition, you
may take advantage of this new .GEN file, Scr2Frg.GEN, which
creates reports from existing screen forms without the need for
programming, by accessing the Ashton-Tate Bulletin Board.

One of the strengths of dBASE IV is the
What-You-See-Is-What-You-Get (WYSIWYG) approach of creating
Reports (.FRM files) and Screen Forms (.SCR files). Many times,
a report that duplicates a screen form is needed. For instance,
a hard copy of a data entry record is a typical example.

There are three ways to create a report from a screen form. One
way is to create a report that looks exactly like your screen
form. However, if your screen form is fairly complex, this
could be a redundant, time consuming affair. Another way is to
incorporate a copy of the .FMT code created when you saved your
screen form into a program. This requires programming knowledge
which could find you spending more time converting and less time
producing results.

You might ponder, "Wouldn't it be nice if dBASE IV did this for
me automatically?" Since the layout is already there, why
can't dBASE IV do it? Well, good news! It can! That's the
third and most desirable solution and the point of this article.

The easy solution to the above problem is to have a dBASE IV
template do the work for us. The template source code presented
at the end of this article will take an existing screen form
(.SCR) and generate a report form file (.FRG). This report file
can then be used in conjunction with the REPORT FORM command or
run from the Control Center.

A Brief Explanation of the Template Language

The Template Language takes dBASE IV design files (in our case
the .SCR file) and generates either documentation or program
versions of these objects via the Template Language Compiler.
Other design sources include .FRM, .LBL, .BCH, .APP, .POP and
.BAR files.

Consider each design file as a stack of items. For example, a
screen form can contain a stack of items consisting of fields,
boxes, text, memory variables, and calculated fields. Each of
these items have certain attributes such as row and column
position, display length, data type, and other specific
attributes. Attribute descriptions of these items are kept in
definition files (.DEF files). The definition file for screen
forms is called FORM.DEF.

The Template Language enables you to retrieve items from these
design files, examine them, and generate code depending upon the
items examined. When you create a screen form, dBASE IV
retrieves the stack of items contained in the .SCR file, passes
it through FORM.GEN and generates a .FMT file (called a format
file).

The Template Language contains tools, consisting of control
structures, file handling capabilities, and functions to scan
through a design file and determine what is outputted. These
tools are used to create Template Language programs. The source
code for Template Language programs are kept in .COD files.
These .COD files are then compiled into .GEN files. Using
Template Language, you can create your own custom made .GEN files
and control the dBASE IV code outputted when generating labels,
reports, APGEN Applications, and Screen Forms.

There are a number of existing .COD files in your DTL directory
that can be used freely as examples or building blocks for your
own .COD files. If you haven't installed them, check the
contents of your Template Language disks.

There are two basic steps to creating a .GEN file:

1. Write the source code (.COD file) for the .GEN file using
a text editor
2. Compile the .COD file into a .GEN file using the DTC.EXE
program. dBASE IV uses these default template names to
create the related code and object files for the
following:

*Labels: LABEL.GEN
*Reports: REPORT.GEN
* AppsGen: MENU.GEN
*Screens: FORM.GEN

The .COD files that generated these files are called LABEL.COD,
REPORT.COD, AS_MENU.COD and FORM.COD respectively.

Please note that any existing report file with the same name as
your screen form will be overwritten. If you have an existing
report with the same name as your screen, it is important to
first copy your .SCR file to a new name so that it will not
conflict with the similarly named report.

A more complete explanation of the Template Language can be found
in the Developer's Edition manual entitled Using the Template
Language.

How to use Scr2Frg.GEN

Begin by either typing in the listed template code at the end of
this article or retrieving it from the Ashton-Tate Electronic
Bulletin Board. Compile it by entering at the DOS prompt:

DTC -iScr2Frg.COD

DTC.EXE is the Template Compiler which comes with the dBASE IV
Developer's Edition.

The "-i" parameter prefaces the file being submitted to the
compiler, indicating it as the input file. Once Scr2Frg.COD is
successfully compiled, a file named Scr2Frg.GEN will exist.
Copy the .GEN file (Scr2Frg.GEN) into your dBASE IV directory, if
it doesn't already reside there.

You're now ready to generate a new .FRG file from an existing
screen form. At the DOS prompt enter:

SET DTL_FORM=Scr2Frg.GEN

This specifies dBASE IV to use the Scr2Frg.GEN file instead of
the default FORM.GEN. Now go into dBASE IV and modify the
screen form from which you want to create a report. Once you're
in the layout screen, press Ctrl-End. This will force
regeneration of your design screen and create a new .FRG file by
the same name as that screen.

It is important that the SET DTL command, which sets a DOS
environmental variable, not be executed while in a DOS access of
a dBASE IV session. A DOS access is a copy of the environment
and not a return to the original DOS environment which exists
before and after a dBASE IV session. Therefore, any SET command
would be eliminated upon the return to dBASE IV via the DOS
access.

Points to consider

If the screen you're regenerating does not have an existing .FMT
file, the error message "File could not be found" will appear.
The error appears because dBASE IV tries to compile a .FMT file
any time you save a screen. If one doesn't exist, the above
error message appears which may be ignored.

After generation, you can then run the .FRG file from either the
Control Center or the dot prompt as if it were a regular
report. If you want to place the new report in the Control
Center, you must first run the report initially from the dot
prompt. The reason for this is that the Control Center will
only let you add .FRM or .FRO (the interface and object) files
and the Scr2Frg.GEN template file creates only a .FRG (program
code) file. Running the report with the REPORT FORM command
will automatically create a .FMO file.

One point that may not be obvious to newer users is that no
design file (.FRM) is created. The report you create using the
Scr2Frg.GEN file cannot be modified via MODIFY REPORT since the
initial design data was from the screen form.

Scr2Frg.COD Usage Notes
* Scr2Frg will create a report that looks exactly like your
screen (except for the status bar). This also includes
memos in windows looking exactly the same.
* After each record, a page eject will occur.
* A screen will always take up a minimum of either 25 or 43
lines depending upon what display mode dBASE IV was in
when the screen report was generated. Consequently, even
a screen with one line of information will generate 25
to 43 lines when printed.
* If you would like to print more than one screen per
page, you'll need to adjust the system memory variables
_plength and _padvance. _plength specifies your page
length and _padvance specifies whether to advance the
paper with either line feeds or a form feed.

Example: Your screen is 25 lines in length and your
physical page length is 66 lines. To place two screens
per page, set plength to 33 and _padvance to "Linefeeds"
(instead of the default "Formfeed"). This will place
one screen for each 33 lines.

These two variables can either be set from the dot
prompt, in a program, or from the Print menu. When
setting these from the Print menu, page length would be
set under the Print: Page dimensions menu. The method
of advancing a page (formfeed vs. linefeeds) would be
set from the Print: Control of printer menu.
* The line number on which item numbers are placed when
creating a screen is respected. This means that an item
on the 26th line of a two screen screen form will print
on the 26th line of the report and not on a separate
page.
* A heading can be specified with the REPORT FORM command,
using the HEADING parameter, and will appear at the top
of each page. The number of lines in the heading will
be added on to the screen size. Suppose you have a three
line header and you're printing a 25 line screen. The
total number of lines needed to print each record would
then be 28.
* The PLAIN and SUMMARY options of the REPORT FORM command
are ignored except where PLAIN is included with the
HEADING option. These two options are mutually
exclusive with the PLAIN option taking precedence.
* An optional page break will be inserted on whatever line
desired if that line has .PB in the first column. This
feature could be helpful if, for instance, you have a
four page screen form and you'd like everything after a
certain line to appear on a new page. To use, simply
type .PB in the first column on the line you want to
begin the next page. The next time you regenerate your
screen with the Scr2Frg.GEN template active, a report
will be generated with a page break at that point. Do
not specify a page break while a box is printing as
defined boxes will not respect a page break.
* When finished generating reports from screen forms by
using Scr2Frg.GEN, make sure to set your form template
back to its default. This is done by entering at the DOS
prompt:

SET DTL_FORM=

Since nothing is specified after the equal sign, DTL_FORM is
erased from memory and the default FORM.GEN will now be assumed.

The Scr2Frg.GEN file is just one example of how a feature can be
added to the product simply by using the appropriate template
and represents a very useful flexibility of dBASE IV. Remember
that custom made templates can be as simple or complex as you
wish and while it might take some time to write a template, the
time saved in developing a system or the added flexibility to a
system could more than compensate.



//
// Module Name: SCR2FRG.COD
// Description: This file will convert .SCR files to .FRG files,
// Enabling the user to print Screen Forms with the
// REPORT FORM command.
//
//

FORMAT to REPORT (.scr -> .frg) File Template
----------------------------------------------------
Written by Bryan Flynn, Ashton-Tate Software Support

Notes: o The SUMMARY option is not supported and has no effect if specified.
o ".PB" in the first column of a screen line will insert a page break
at that point.
{
include "form.def"; // Form selectors
include "builtin.def"; // Builtin functions
//
enum wrong_class = "This .GEN file can only be used on SCREEN FORM files. ",
window_limit = 26;
//

if Frame_class != form then // We are not processing a form object
pause(wrong_class + any_key);
goto NoGen;
endif

var frg_name, // Format file name
crlf, // line feed
temp, // tempory work variables
line_cnt, // Count for total lines processed
default_drv,// dBASE default drive
scrn_size, // Screen size when generation starts
scrn_size2, // = 43 or 25
display, // Type of display screen we are on
dB_status, // dBASE status bar (on|off) before entering designer
maxrow, // Used for blank lines
box_ht, // HEIGHT of DEFINEd BOXes
is_memo, // How many memos w/ windows are currently being printed
no_AT, // Don't print AT location if memo marker
avail_stck, // Stack to hold which set of memo variables is available
used_stck, // Stack to hold which set of memo variables is being used
// memo#_1 = Holds expression for printout of memos
// memo#_2 = What line of memo to print
// memo#_3 = How many lines of memo to print
// Screen can have up to 26 memo windows next to each other at any one time.
// Arrays not supported in the Template Language
memo1_1, memo1_2, memo1_3, memo2_1, memo2_2, memo2_3, memo3_1, memo3_2,
memo3_3,
memo4_1, memo4_2, memo4_3, memo5_1, memo5_2, memo5_3, memo6_1, memo6_2,
memo6_3,
memo7_1, memo7_2, memo7_3, memo8_1, memo8_2, memo8_3, memo9_1, memo9_2,
memo9_3,
memo10_1, memo10_2, memo10_3,memo11_1, memo11_2, memo11_3,memo12_1, memo12_2,
memo12_3,
memo13_1, memo13_2, memo13_3,memo14_1, memo14_2, memo14_3,memo15_1, memo15_2,
memo15_3,
memo16_1, memo16_2, memo16_3,memo17_1, memo17_2, memo17_3,memo18_1, memo18_2,
memo18_3,
memo19_1, memo19_2, memo19_3,memo20_1, memo20_2, memo20_3,memo21_1, memo21_2,
memo21_3,
memo22_1, memo22_2, memo22_3,memo23_1, memo23_2, memo23_3,memo24_1, memo24_2,
memo24_3,
memo25_1, memo25_2, memo25_3,memo26_1, memo26_2, memo26_3;

//-----------------------------------------------
// Assign default values to some of the variables
//-----------------------------------------------
is_memo = 0;
avail_stck=" 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21," +
"22,23,24,25,26,";
used_stck="";

crlf = chr(10);
temp = "";
line_cnt = 0;

//-------------------------------
// Test screen size if display > 2 screen is 43 lines
//-------------------------------
display = numset(_flgcolor);
if display > ega25 then scrn_size = 39 else scrn_size = 21 endif;
scrn_size2 = scrn_size + 4;
dB_status = numset(_flgstatus); // _flgstatus defined in BUILTIN.DEF
if scrn_size == 21 and !dB_status then
scrn_size = 24;
endif
//else
if scrn_size == 39 and !dB_status then // STATUS is off
scrn_size = 42;
endif

//-------------------------------
// Create .FRG file
//-------------------------------
default_drv = strset(_defdrive); // Grab default drive from dBASE

frg_name = FRAME_PATH + NAME;
if not fileok(frg_name) then
if !default_drv then
frg_name = NAME;
else
frg_name = default_drv + ":" + NAME;
endif
endif
frg_name = upper(frg_name);
if not create(frg_name+".FRG") then
pause(fileroot(frg_name) +".FRG" + read_only + any_key);
goto nogen;
endif
if not fileexist(frg_name+".FMT") then
cursor_pos(2, 1);
cput("You don't have a FORMAT file by this name. Ignore 'File does not
exist' error");
endif
}
//
*--- Name....: {filename(frg_name)}FRG
*--- Date....: {ltrim(SUBSTR(date(),1,8))}
*--- Version.: dBASE IV, Format {Frame_ver}.0x
*
*--- Parameters
PARAMETERS m_NoEject, m_Plain, m_Summary, m_Heading, m_Extra
*--- NOT USED: m_Summary
*--- The first three parameters are of type logical.
*--- The fourth parameter is a string. The fifth is extra.
PRIVATE _peject, _wrap, _box, m_Talk, m_Width, m_Prntflg, m_PSpace, m_Atline

*--- Report file initialization code -------------------------------------------
-

*--- Test for no records found
IF EOF() .OR. .NOT. FOUND()
RETURN
ENDIF

*--- Turn wrap mode off
_wrap = .F.

*--- Set _box to true so DEFINEd BOXes will print
_box = .T.

*--- Start printing at line zero of page.
_plineno=0

*--- Set NOEJECT parameter of the REPORT FORM command.
if m_NoEject
IF _peject = "BEFORE"
_peject = "NONE"
ENDIF
IF _peject = "BOTH"
_peject = "AFTER"
ENDIF
ENDIF

*--- Set-up environment
ON ESCAPE DO PrnAbort &&Do procedure PRNABORT if ESC is pressed when
printing.
IF SET("TALK") = "ON" &&Save status of TALK so it can be restored later.
SET TALK OFF
m_Talk = "ON"
ELSE
m_Talk = "OFF"
ENDIF
m_Width = SET("MEMOWIDTH") &&Save current memowidth setting.
SET MEMOWIDTH TO 65 &&When printing memos, memowidth must be 65.
m_Prntflg = .T. &&Set to FALSE when user presses ESCAPE.

*--- Set up when to page break.
IF _pspacing > 1
m_Atline= _plength - (_pspacing + 1)
ELSE
m_Atline= _plength - 1
ENDIF
ON PAGE AT LINE m_Atline EJECT PAGE

*--- Print Report.
PRINTJOB

IF .NOT. m_Plain .AND. LEN(m_Heading) > 0
?? m_Heading FUNCTION "I;V80"
?
ENDIF

ON PAGE AT LINE m_Atline DO Pgfoot

*--- File Loop
DO WHILE m_Prntflg && FOUND() .AND. .NOT. EOF() .AND. m_Prntflg
DO __Detail
CONTINUE
IF FOUND() .AND. .NOT. EOF() .AND. m_Prntflg .AND. _pageno <= _pepage
EJECT PAGE && EJECT occurrs after each record
ELSE && Don't want to print HEADING after last record
ON PAGE
EJECT PAGE
EXIT
ENDIF
ENDDO

IF .NOT. m_Prntflg && User pressed the escape key while printing
DO RESET
RETURN
ENDIF

ENDPRINTJOB

DO Reset
RETURN
*--- EOP: {filename(frg_name)}FRG

*--- Executed when user presses ESCAPE while report is running.
PROCEDURE Prnabort
m_Prntflg = .F.
RETURN
*--- EOP: Prnabort

*--- Reset dBASE environment prior to calling report.
*--- Note that any ON ESCAPE or ON PAGE routine user had before
*--- running the REPORT FORM command will be cleared.
PROCEDURE Reset
SET TALK &m_Talk
SET MEMOWIDTH TO m_Width
ON ESCAPE
RETURN
*--- EOP: Reset

PROCEDURE __Detail
{maxrow = line_cnt = 0;
FOREACH ELEMENT form_object
if ROW_POSITN - line_cnt > scrn_size then
line_cnt = line_cnt + scrn_size + 1;
endif
nextline:
if maxrow < ROW_POSITN then
outmemo();}
?
{ ++maxrow;
goto nextline;
endif
no_AT=0; // "?? ... AT ## " should not be outputted if item is a memo with
a window
case ELEMENT_TYPE of
@TEXT_ELEMENT:
if asc(TEXT_ITEM) < 32 then // Control character - use CHR()
if len(TEXT_ITEM) == 1 then}
?? CHR({asc(TEXT_ITEM)}) AT {nul2zero(COL_POSITN)}
{ else}
?? REPLICATE(CHR({asc(TEXT_ITEM)}), {len(TEXT_ITEM)}) AT
{nul2zero(COL_POSITN)}
{ endif
else
if nul2zero(COL_POSITN) == 0 and len(TEXT_ITEM) >=3 and
upper(substr(TEXT_ITEM, 1, 3)) == ".PB" then
// User specified page break}
EJECT PAGE
{ if len(TEXT_ITEM) > 3 then}
?? "{substr(TEXT_ITEM, 4)}" AT 3
{ endif
else // no page break specified}
?? "{TEXT_ITEM}" AT {nul2zero(COL_POSITN)}
{ endif
endif
@BOX_ELEMENT:
outbox(form_object)
@FLD_ELEMENT:
case FLD_FIELDTYPE of
calc:}
* Calculated field - {FLD_DESCRIPT}
?? \
{ foreach FLD_EXPRESSION fcursor in form_object
FLD_EXPRESSION}
{ next} \
{ dbf:
if not (chr(FLD_VALUE_TYPE) == "M") then //Not type memo}
?? \
{ lower(FLD_FIELDNAME)} \
{ else //Item is memo field
if (FLD_MEM_TYP == 2) or
(is_memo == window_limit) then //No window for memo}
?? IIF(LEN({FLD_FIELDNAME}) = 0, "memo", "MEMO") \
{ else //Memo is in a window
++is_memo;

// Determine how wide memo line should be
if BOX_WIDTH - 2 > 65 then
temp = 65;
else
temp = BOX_WIDTH - 2;
endif

// Expression used when outputting memo in a window
// TEMP is assigned to memo#_1 in find_empty_memo()
temp = FLD_FIELDNAME + space(10-
len(alltrim(FLD_FIELDNAME))) +
alltrim(str(temp)) + "), '') AT " +
alltrim(str(BOX_LEFT + 1));
outbox(form_object) // Define memo window box
find_empty_memo(); // Assign memo expression

no_AT=1; // Don't print AT location
endif
endif
memvar:}
* Memory variable
?? \
{ lower("m->"+FLD_FIELDNAME)} \
{ endcase //FLD_FLDTYPE of}\
{ if not no_AT}AT {COL_POSITN} {endif}\
{ if FLD_TEMPLATE and not (chr(FLD_VALUE_TYPE) == "M") then}
PICTURE "{ if FLD_PICFUN and not AT("M",FLD_PICFUN) then
if not at("S",FLD_PICFUN) then}\
@{FLD_PICFUN} {FLD_TEMPLATE}"
{ else //Scroll field
substr(FLD_TEMPLATE,1,FLD_PIC_SCROLL)}"
{ endif
else //No picture clause, just template}
{FLD_TEMPLATE}"
{ endif
else}
{ if not no_AT then print(crlf) endif //If memo marker or no template
endif}
{ otherwise: //Non ELEMENT
endcase //ELEMENT of
next form_object;
outmemo();

nextline2:
if ((maxrow + 1) % scrn_size2) != 0 then // Fill out remainder of screen with
?'s
outmemo();}
?
{ ++maxrow;
goto nextline2;
endif}
RETURN
*--- EOP: __Detail

PROCEDURE Pgfoot
EJECT PAGE
IF .NOT. m_Plain .AND. LEN(m_Heading) > 0
?? m_Heading FUNCTION "I;V80"
?
ENDIF
RETURN
*--- EOP: Pgfoot

{fileerase(frg_name+".FRO");
nogen:
return 0;

//---------------------------------------
// Template user defined functions below
//---------------------------------------

define nul2zero(numbr);
// If number is null and we are expecting a zero - convert the null to 0
if !numbr then numbr=0 endif;
return numbr;
enddef

define outbox(cur)
var temp;}
DEFINE BOX FROM {nul2zero(cur.BOX_LEFT)} TO \
{ nul2zero(cur.BOX_LEFT) + cur.BOX_WIDTH - 1} HEIGHT \
{ temp = nul2zero(cur.BOX_TOP) + cur.BOX_HEIGHT - line_cnt - 1;
if temp > scrn_size then
box_ht = (scrn_size - cur.BOX_TOP + 1);
else
box_ht = (temp - cur.BOX_TOP + 1);
endif
// box_ht is defined in main program and is needed if the box is
// to be used with a memo window
box_ht} \
{ case cur.BOX_TYPE of
0: // Single}
SINGLE
{ 1: // Double}
DOUBLE
{ 2: // Defined}
CHR({cur.BOX_SPECIAL_CHAR})
{ endcase
enddef

define outmemo()
// There can be up to 26 memo windows next to eachother in Screen Form
var temp_stck;
temp_stck = used_stck;
do while temp_stck
outmemo2(val(substr(temp_stck, 1, 2)))
temp_stck = substr(temp_stck, 4);
enddo
return;
enddef

define outmemo2(whch_memo)
case whch_memo of
1: outmemo3(memo1_1, memo1_2, memo1_3, " 1")
2: outmemo3(memo2_1, memo2_2, memo2_3, " 2")
3: outmemo3(memo3_1, memo3_2, memo3_3, " 3")
4: outmemo3(memo4_1, memo4_2, memo4_3, " 4")
5: outmemo3(memo5_1, memo5_2, memo5_3, " 5")
6: outmemo3(memo6_1, memo6_2, memo6_3, " 6")
7: outmemo3(memo7_1, memo7_2, memo7_3, " 7")
8: outmemo3(memo8_1, memo8_2, memo8_3, " 8")
9: outmemo3(memo9_1, memo9_2, memo9_3, " 9")
10: outmemo3(memo10_1, memo10_2, memo10_3, "10")
11: outmemo3(memo11_1, memo11_2, memo11_3, "11")
12: outmemo3(memo12_1, memo12_2, memo12_3, "12")
13: outmemo3(memo13_1, memo13_2, memo13_3, "13")
14: outmemo3(memo14_1, memo14_2, memo14_3, "14")
15: outmemo3(memo15_1, memo15_2, memo15_3, "15")
16: outmemo3(memo16_1, memo16_2, memo16_3, "16")
17: outmemo3(memo17_1, memo17_2, memo17_3, "17")
18: outmemo3(memo18_1, memo18_2, memo18_3, "18")
19: outmemo3(memo19_1, memo19_2, memo19_3, "19")
20: outmemo3(memo20_1, memo20_2, memo20_3, "20")
21: outmemo3(memo21_1, memo21_2, memo21_3, "21")
22: outmemo3(memo22_1, memo22_2, memo22_3, "22")
23: outmemo3(memo23_1, memo23_2, memo23_3, "23")
24: outmemo3(memo24_1, memo24_2, memo24_3, "24")
25: outmemo3(memo25_1, memo25_2, memo25_3, "25")
26: outmemo3(memo26_1, memo26_2, memo26_3, "26")
endcase
return;
enddef


define outmemo3(expr, what_line, maximum_lines, whch_memo)
// Don't print out anything if printing top or bottom line of box
if (what_line != 1) and (what_line != maximum_lines) then}
?? IIF('' <> MLINE({alltrim(substr(expr, 1, 10))}, {what_line - 1}), \
SUBSTR(MLINE({alltrim(substr(expr, 1, 10))}, {what_line - 1}), 1, {substr(expr,
11)}
{ endif
++what_line;
if what_line > maximum_lines then // Done printing memo
--is_memo;
// Take this reference off active stack
used_stck = substr(used_stck, 1, at(whch_memo, used_stck) - 1) +
substr(used_stck, at(whch_memo, used_stck) + 3);
// Put this memo back on available stack so the corresponding memo
// variables can be used again.
avail_stck = whch_memo + "," + avail_stck;
endif
return;
enddef

define assign_vals(expr, what_line, maximum_lines)
// Called when memo with window is encountered
expr = temp; // temp is from main program
what_line = 1; // First line to print of memo
maximum_lines = box_ht;
return;
enddef

define find_empty_memo()
used_stck = substr(avail_stck, 1, 3) + used_stck;
avail_stck = substr(avail_stck, 4);
case val(substr(used_stck, 1, 2)) of
1: assign_vals(memo1_1, memo1_2, memo1_3)
2: assign_vals(memo2_1, memo2_2, memo2_3)
3: assign_vals(memo3_1, memo3_2, memo3_3)
4: assign_vals(memo4_1, memo4_2, memo4_3)
5: assign_vals(memo5_1, memo5_2, memo5_3)
6: assign_vals(memo6_1, memo6_2, memo6_3)
7: assign_vals(memo7_1, memo7_2, memo7_3)
8: assign_vals(memo8_1, memo8_2, memo8_3)
9: assign_vals(memo9_1, memo9_2, memo9_3)
10: assign_vals(memo10_1, memo10_2, memo10_3)
11: assign_vals(memo11_1, memo11_2, memo11_3)
12: assign_vals(memo12_1, memo12_2, memo12_3)
13: assign_vals(memo13_1, memo13_2, memo13_3)
14: assign_vals(memo14_1, memo14_2, memo14_3)
15: assign_vals(memo15_1, memo15_2, memo15_3)
16: assign_vals(memo16_1, memo16_2, memo16_3)
17: assign_vals(memo17_1, memo17_2, memo17_3)
18: assign_vals(memo18_1, memo18_2, memo18_3)
19: assign_vals(memo19_1, memo19_2, memo19_3)
20: assign_vals(memo20_1, memo20_2, memo20_3)
21: assign_vals(memo21_1, memo21_2, memo21_3)
22: assign_vals(memo22_1, memo22_2, memo22_3)
23: assign_vals(memo23_1, memo23_2, memo23_3)

24: assign_vals(memo24_1, memo24_2, memo24_3)
25: assign_vals(memo25_1, memo25_2, memo25_3)
26: assign_vals(memo26_1, memo26_2, memo26_3)
endcase
return;
enddef
}
// EOP SCR2FRG.COD


