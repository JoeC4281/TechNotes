This article is reprinted from the April 1990 edition of
TechNotes/dBASE IV.  Due to the limitations of this media, certain
graphic elements such as screen shots, illustrations and some tables
have been omitted.  Where possible, reference to such items has been
deleted.  As a result, continuity may be compromised.  

TechNotes is a monthly publication from the Ashton-Tate Software
Support Center.  For subscription information, call 800-545-9364.

# The Anatomy Of A dBASE IV Report Form
Mike Carlisle

In this article we'll take a look at the internal workings of a Report
Form in dBASE IV.  We will peruse the procedures and subroutines that
produce the Header, Report Intro, Group Intro, Detail, Group Summary,
Report Summary and Footer of a typical dBASE IV report.  We will also
look at how and where calculations are performed and how the report
form knows what records to print when a FOR or WHILE condition has
been specified.

I've taken a fairly generic report form file (Anatomy.FRG), added line
numbers and broken it up into sections for our discussion.

System Variables

When generating an .FRG file, the Report Form generator uses a number
of memory variables, called system variables because they are defined
by Report Form.  These system variable are listed in Table 1.

Table 1 Report Form system variables 

r_????????      Storage variable created by the Report Form Generator
                for passing field values to print  subroutines.
g?_???????      Report Form system variable defined by the report form
                generator
gl_???????      Report Form system variable that will contain a
                LOGICAL value.
gc_???????      Report Form system variable that will contain a
                CHARACTER value.
gn_???????      Report Form system variable that will contain a
                NUMERIC value.
gd_???????      Report Form system variable that will contain a DATE
                value.
_?????????      dBASE IV system variable.
??????????      User-defined variable.  Usually the name of a
                calculated field from the REPORT FORM definition.

Group Levels with gn_Level

One of the Report Form system variables you will see used frequently
throughout the .FRG file is gn_level.  This variable is used to keep
track of what stage of the report process the .FRG is at.  It is most
often referenced when the Group Intro and Group Summary print and
calculation routines are called.  Because we can have multiple group
breaks in a report definition, rather than have separate print and
calculation routines for each, we have routines that check the value
of gn_level to determine which group to calculate or print.

The first group break level is assigned a value of four, the second is
five, the third is six and so on.  The sub routines that print the
Group Intros and reset the summary variables for the group breaks,
test for these values.  The Group Footer (or summary) tests for the
value of 100 - gn_level (i.e. the first Group Footer would be 100 - 4
or 96, the second would be 100 - 5 or 95, the third 100 - 6 or 94 and
so on).  As we go through the example .FRG file you will see gn_level
in use.

Parameters

```dos
11 *-- Parameters
12 PARAMETERS gl_noeject, gl_plain, gl_summary, gc_heading, gc_extra
13 ** The first three parameters are of type Logical.
14 ** The fourth parameter is a string.  The fifth is extra.
15 PRIVATE _peject, _wrap
16
```


When issuing the dBASE IV REPORT FORM command from the dot prompt or
from within a program there are a few optional parameters.  They are: 

PLAIN   For continuous flow text with no page breaks and no headings
after the                first page.
NOEJECT Eliminate initial page advance before report printing begins.
SUMMARY Print GROUP and REPORT totals only.
HEADING Specify text to be printed at the top of each page in addition
to the           defined report header.

These parameters are accounted for in the .FRG file via the dBASE IV
PARAMETERS command.  When the report is run, dBASE IV passes the
appropriate values to the first PARAMETERS statement in the report
form.

The variables _peject and _wrap are dBASE IV system variables. 
_peject will contain any one of the words BEFORE, AFTER, BOTH or NONE
meaning that dBASE should perform a form feed either BEFORE or AFTER
the report is run, at BOTH times or (NONE) not at all.  The variable
_wrap will contain a .T. (TRUE) or .F. (FALSE).  If .T. then dBASE IV
will print all output as word wrapped text.  If .F., text will be
printed in the positions specified in the report form definition. 
Here both of these variables have been declared as PRIVATE so that any
changes made to their values will affect only the current report being
printed.

Test for Records

```dos
17 *-- Test for no records found
18 IF EOF() .OR. .NOT. FOUND()
19    RETURN
20 ENDIF
21
```


When executing a dBASE IV report form, dBASE internally issues a
LOCATE command using the FOR, WHILE and SCOPE information from the
REPORT FORM command as the conditions for the LOCATE.  If no
conditions were specified, it performs a LOCATE for the logical .T.
(TRUE).  This will position the record pointer at the first record in
the file.  The IF statement tests the result of the LOCATE command to
ensure there where records found to be printed.  If there where not,
execution of the report is terminated.

Word Wrap Mode

```dos
22 *-- turn word wrap mode off
23 _wrap=.F.
24
```


As mentioned earlier, dBASE IV has the option of printing Word Wrapped
Text.  In other words, any characters that exceed the right margin
would be wrapped to the next line.  Here, the dBASE IV System Variable
_wrap is being set to .F. (FALSE), thereby disabling the Word Wrap
feature.

Page length test

```dos
25 IF _plength < 4
26    SET DEVICE TO SCREEN
27    DEFINE WINDOW gw_report FROM 7,17 TO 11,62 DOUBLE
28    ACTIVATE WINDOW gw_report
29    @ 0,1 SAY "Increase the page length for this report."
30    @ 2,1 SAY "Press any key ..."
31    x=INKEY(0)
32    DEACTIVATE WINDOW gw_report
33    RELEASE WINDOW gw_report
34    RETURN
35 ENDIF
36
```


A typical report would at least consist of PAGE HEADER, REPORT INTRO,
DETAIL and REPORT SUMMARY bands.  Each of these bands has a default
height or size of one line.  The sum of the size of each of these
bands would be four.  If a page length less than four were specified,
not all of these bands would fit on one page.  This test checks to see
that we have allowed enough lines per page to print at least these
bands.  If not, it requests that we change our setting.

Page advance BEFORE, AFTER, BOTH, NONE?

```dos
37 _plineno=0          && set lines to zero
38 *-- NOEJECT parameter
39 IF gl_noeject
40    IF _peject="BEFORE"
41       _peject="NONE"
42    ENDIF
43    IF _peject="BOTH"
44       _peject="AFTER"
45    ENDIF
46 ENDIF
47
```


As I mentioned earlier, dBASE IV makes use of a system variable called
_peject to determine whether a page should be ejected at the
beginning, the end or both ends of a report form printout.  At the
same time the syntax of the REPORT FORM command allows us to specify
the option NOEJECT which eliminates the initial page eject before
printing.  The test here is to determine whether or not to perform the
initial page advance and then set the system variable _peject
accordingly.

The Environment

```dos
48 *-- Set-up environment
49 ON ESCAPE DO prnabort
50 IF SET("TALK")="ON"
51    SET TALK OFF
52    gc_talk="ON"
53 ELSE
54    gc_talk="OFF"
55 ENDIF
56 gc_space=SET("SPACE")
57 SET SPACE OFF
58 gc_time=TIME()      && system time for predefined field
59 gd_date=DATE()      && system date  "    "    "     "
60 gl_fandl=.F.        && first and last page flag
61 gl_prntflg=.T.      && Continue printing flag
62 gl_widow=.T.        && flag for checking widow bands
63 gn_length=LEN(gc_heading)  && store length of the HEADING
64 gn_level=2          && current band being processed
65 gn_page=_pageno     && grab current page number
66 
67
```


This section defines the environment settings for the report.  
The first item defined is the user way-out.  The Escape key is set up
so that when pressed, the report process is canceled.

Next, TALK is set OFF so that talk-back resulting from the execution
of some dBASE IV commands and the storing of values to memory
variables does not display on the screen.
Because the "?" and "??" commands are used exclusively for producing
the report output, SPACE is set OFF so that extra spaces are not
generated between printed fields in the report.

In addition, a number of program variables are assigned their default
values.  Study the "&&" notes that follow the assignments for an
explanation of these variables.

Initialize Calculated Variables

```dos
68 *-- Initialize calculated variables.
69 CALC1=FLOAT(0)
70
```


Here is where user-defined calculated fields are initialized.  The
actual calculations are performed elsewhere.  The variables are
created here so that they will be available as PUBLIC variables to all
other sub-routines.

Determining the Page Break

```dos
71 *-- Set up procedure for page break
72 IF _pspacing > 1
73    gn_atline=_plength - (_pspacing + 1)
74 ELSE
75    gn_atline=_plength - 2
76 ENDIF
77 ON PAGE AT LINE gn_atline EJECT PAGE
78
```


The set up procedure for determining the page break is used to define
the variable gn_atline.  This variable holds the line number at which
a page break should occur on every page.   The variable itself is used
in conjunction with the ON PAGE command.  The ON PAGE command
determines what steps to process when the desired page length has been
reached.

The Heart Of The Report Form

```dos
79 *-- Print Report
80 
81 PRINTJOB
82
```


This is where the report processing takes place.  The section starts
off with the PRINTJOB command.  Issuing this command causes the
printer initialization codes from the selected printer driver and the
Starting Control Codes from the "Print" menu and/or dBASE IV system
variables to be sent to the printer.  In addition, the dBASE IV
internal line and page counters are reset.

Initialize Group Break Variables

```dos
83 *-- Initialize group break vars.
84 r_mvar4=FNAME
85
```

Here is where the group break variables are initialized.  As with the
variables for calculated fields the Group Break variables are
initialized here so as to make them available as PUBLIC variables to
all other sub-routines.  In addition, the initial grouping values for
the first group are stored to the Group Break Variables.

Initialize Summary Variables

```dos
86 *-- Initialize summary variables.
87 GRPSUM1=0
88 GRPSUM2=0
89 GRPSUM3=0
90 RPTSUM1=0
91 RPTSUM2=0
92 RPTSUM3=0
93
```


Here the Summary Variables for both the Group and Report summaries are
initialized.  Again the variables are initialized here to make them
PUBLIC.

Assign Initial Values to Calculated Variables (Fields)

```dos
94 *-- Assign initial values to calculated variables.
95 CALC1=AMOUNT*COST
96
```


Here, the values for the user-defined calculated fields are assigned
for the first record to be printed.  After this first assignment
further calculation will be handled in the UpdVars sub-routine which I
will discuss later.

Start First Physical Page

```dos
97 IF gl_plain
98    ON PAGE AT LINE gn_atline DO Pgplain
99 ELSE
100    ON PAGE AT LINE gn_atline DO Pgfoot
101 ENDIF
102 
103 DO Pghead
104 
105 gl_fandl=.T.        && first physical page started
106 
107 DO Rintro
108 
109 DO Grphead
110
```


The report is ready to begin printing.  A final check is made to see
if the PLAIN option was supplied with the REPORT FORM command and the
ON PAGE command is set accordingly.

Next the page heading is printed.  The First Page flag is then set to
.T. (TRUE).  The Report Intro is printed as well as the first Group
Heading.  The next step is what I called the Pace Maker.  That's the
File Loop where the records themselves are processed.
The Pace Maker

```dos
111 *-- File Loop
112 DO WHILE FOUND() .AND. .NOT. EOF() .AND. gl_prntflg
113    DO CASE
114    CASE .NOT. (FNAME = r_mvar4)
115       gn_level=4
116    OTHERWISE
117       gn_level=0
118    ENDCASE
119    *-- test whether an expression didn't match
120    IF gn_level <> 0
121       DO Grpfoot WITH 100-gn_level
122       DO Grpinit
123    ENDIF
124    *-- Repeat group intros
125    IF gn_level <> 0
126       DO Grphead
127    ENDIF
128    DO Upd_Vars
129    *-- Detail lines
130    IF .NOT. gl_summary
131       DO Detail
132    ENDIF
133    CONTINUE
134 ENDDO
135
```


The first line of the File Loop is a DO WHILE command.  The conditions
for the DO WHILE are
 
```dos
FOUND()         is there a record to be processed
.NOT. EOF()     make sure the record pointer is not at the End Of File
                mark 
gl_prntflg      the print flag is set to .T. (TRUE) [if the user
                presses the Escape key to cancel the report this flag
                is set to .F. (FALSE)].
```

The next step is to test the current record to insure that it is a
member of the group of records being printed.  If it is not,
indicating that the group has changed, the report variable gn_level is
set to the value of four.  If the record is of the same group, the
report variable is set to a value of zero.  These values are
meaningful to the tests that follow.

If the variable gn_level has been set to a value other than zero (in
this case it has been set to four) then the Group Footer (better known
as the Group Summary) information is printed and the Group Summary
variables are initialized for the next group.

The Group Heading is then printed for the next group, again only if
gn_level is anything other than zero.

The routine Upd_Vars is called to calculate the values of any User
Defined calculated fields for the current record and to update the
Group and Report Summary fields.

NOTE: Unnamed calculated fields are not calculated in the Upd_Vars
routine.  Because these fields have no name against which to store
their value they are calculated at the time of being printed in a
direct print statement (refer to the March '89 issue of
TechNotes/dBASE IV, "Using dBASE IV" on page 28 for more information
on the order of precedence for calculated fields).

Next the .FRG checks to see if this is to be a summary report only. 
If not, the Detail routine is called and the information for the
current record is printed.

The CONTINUE command is the compliment to the internal LOCATE that
dBASE IV performed prior to executing the report.  It will cause the
record pointer to move to the next record matching the condition
supplied to the REPORT FORM command (i.e.  A FOR, WHILE or SCOPE
condition) or, if no condition was specified, to the next record in
the file.

The ENDDO takes us back to the DO WHILE command and the process is
repeated for the next record.

Ending the Report

```dos
136 IF gl_prntflg
137    gn_level=3
138    DO Grpfoot WITH 97
139    DO Rsumm
140    IF _plineno <= gn_atline
141       EJECT PAGE
142    ENDIF
143 ELSE
144    gn_level=3
145    DO Rsumm
146    DO Reset
147    RETURN
148 ENDIF
149 
150 ON PAGE
151 
152 ENDPRINTJOB
153 
154 DO Reset
155 RETURN
156 * EOP: C:\DB4\MIKE.FRG
157
```


Once all of the records have been processed or if the user has pressed
the Escape key, the conditions for the DO WHILE loop become no longer
true.  Process continues with the commands following the ENDDO
statement.

If the user had pressed the Escape key the variable gl_prntflg would
have been set to .F. (FALSE).  The IF statement here checks for that
occurrence.  Assuming the Escape key has not been pressed and all of
the records have been processed, the Grpfoot routine is called and the
Group Summary is printed for the last group.  Then the Rsumm routine
is called to print the summaries for the entire report.

The current line number is then checked to see if a forced page
advance will be necessary to print out the page footer on the final
page of the report.

Had the user pressed the Escape key the Report Summary would be output
for those records already printed.  The environment would be reset and
the report terminated.

Assuming the report has completed naturally, the ON PAGE definition is
cleared so as not to interfere with any other printing that may
occur.  Then the ENDPRINTJOB is executed.

The ENDPRINTJOB is similar to the PRINTJOB we saw earlier.  In this
case the ENDPRINTJOB sends the ending reset codes from the currently
selected printer driver as well as any Ending Control Codes that may
have been specified in the PRINT menu or the dBASE IV system
variables.

The Reset routine is then called to set the environment back to the
state it was prior to running the report. Control is then passed back
to the calling program, the DOT prompt or the Control Center depending
on where the report was called from.

Now lets look at the sub-routines that are called throughout the
.FRG.  We will look at these in the order in which they appear in the
.FRG file.

Updating of Variables: Upd_Vars

```dos
158 *-- Update summary fields and/or calculated fields in the detail
band.
159 PROCEDURE Upd_Vars
160 CALC1=AMOUNT*COST
161 *-- Summary calculation - Sum
162 GRPSUM1=GRPSUM1+AMOUNT
163 *-- Summary calculation - Sum
164 GRPSUM2=GRPSUM2+COST
165 *-- Summary calculation - Sum
166 GRPSUM3=GRPSUM3+CALC1
167 *-- Summary calculation - Sum
168 RPTSUM1=RPTSUM1+AMOUNT
169 *-- Summary calculation - Sum
170 RPTSUM2=RPTSUM2+COST
171 *-- Summary calculation - Sum
172 RPTSUM3=RPTSUM3+CALC1
173 RETURN
174 * EOP: Upd_Vars
175
```


The first subroutine is the Upd_Vars or Update Variables routine.  As
mentioned earlier, this routine performs all of the Group and Report
Summary calculations as well as calculated fields defined by the user
in the report definition.

Aborting the Print Routine: PrnAbort

```dos
176 *-- Set flag to get out of DO WHILE loop when escape is pressed.
177 PROCEDURE prnabort
178 gl_prntflg=.F.
179 RETURN
180 * EOP: prnabort
181
```


The next routine is the PrnAbort or Print Abort routine.  This routine
is called when the user presses the Escape key to cancel the running
of the report form.  It sets the print flag variable (gl_prntflg) to
.F. (FALSE) causing the DO WHILE loop to stop processing records (see
"The Pace Maker" on page 7).

Resetting Group Break Variables: Grpinit

```dos
182 *-- Reset group break variables.  Reinit summary
183 *-- fields with reset set to a particular group band.
184 PROCEDURE Grpinit
185 IF gn_level <= 4
186    GRPSUM1=0
187    GRPSUM2=0
188    GRPSUM3=0
189 ENDIF
190 IF gn_level <= 4
191    r_mvar4=FNAME
192 ENDIF
193 RETURN
194 * EOP: Grpinit
195
```


The Grpinit or Group Initialization routine resets the summary field
variables for the Group Summary bands of the report form.   It uses
the report form system variable gn_level to determine which Group
Summary needs resetting (as discussed in the introduction).

The Group Header (Intro) Routine: Grphead

```dos
196 *-- Process Group Intro bands during group breaks
197 PROCEDURE Grphead
198 IF EOF()
199    RETURN
200 ENDIF
201 gl_widow=.T.         && enable widow checking
202 IF gn_level <= 4
203    DO Head4
204 ENDIF
205 gn_level=0
206 RETURN
207 * EOP: Grphead.PRG
208
```


The Grphead or Group Header routine is used to determine which Group
Heading (Intro) is to be printed (in case there is more than one group
break).

First the routine tests to see if the report has reached the end of
the database file.  If it has, there is no need to print a Group
Heading.  Instead, the routine is exited.

If the End Of File has not been reached, the routine continues
processing.  The report system variable gl_widow is set to .T. (TRUE)
which enables widow and orphan checking.  Widow and Orphan checking
insures that a section of a report (i.e. Group Intro, Detail, Report
Heading, etc...) does not get broken between two pages.

Next the report form system variable gn_level is tested to see which
Group Heading is to be printed.  The corresponding print routine is
then called.

gn_level is set to 0 to indicate that the new group has been started. 
Control is then passed back to the main loop ("The Pace Maker", page
7).

The Group Footer (Summary) Routine: Grpfoot

```dos
209 *-- Process Group Summary bands during group breaks
210 PROCEDURE Grpfoot
211 PARAMETER ln_level
212 IF ln_level >= 96
213    DO Foot96
214 ENDIF
215 RETURN
216 * EOP: Grpfoot.PRG
217
```


The Grpfoot or Group Footer routine performs the same function as the
Grphead routine for the Group Summary bands.

Here the routine checks for a value passed as a parameter to determine
which print routine is to be called for the current Group.  The value
tested is equal to 100 - gn_level as described in the introduction.

The Page Header Routine: Pghead

```dos
218 PROCEDURE Pghead
219 ?? "This is the PAGE HEADER" AT 26
220 ?
221 *-- Print HEADING parameter ie. REPORT FORM <name> HEADING <expC>
222 IF .NOT. gl_plain .AND. gn_length > 0
223    ?? gc_heading FUNCTION "I;V"+LTRIM(STR(_rmargin-_lmargin))
224    ?
225 ENDIF
226 RETURN
227 * EOP: Pghead
228
```


The Pghead or Page Header routine prints the page header defined in
the report form definition.  In addition it prints the text passed to
the report form from the HEADING portion of the REPORT FORM command
(i.e. REPORT FORM <name> HEADING "This is a heading").

The Report Intro Routine: Rintro

```dos
229 PROCEDURE Rintro
230 ?? "This is the REPORT INTRO" AT 26
231 ?
232 RETURN
233 * EOP: Rintro
234
```


The Rintro, or Report Intro, procedure is the routine that prints the
text specified in the Report Intro Band of the Report Form definition.

A Group Intro Print routine: Head4

```dos
235 PROCEDURE Head4
236 IF gn_level=1
237    RETURN
238 ENDIF
239 IF 1 < _plength
240    IF (gl_widow .AND. _plineno+1 > gn_atline)
241       EJECT PAGE
242    ENDIF
243 ENDIF
244 ?? FNAME FUNCTION "T" AT 0,
245 ?? "Group Intro Band Grouped on The Database Field Fname" AT 18
246 ?
247 RETURN
248
```


Head4 is one example of many possible print routines for outputting
the text of the Group Intro Bands.  Called by the Grphead routine,
Head4 specifically prints the Group Intro text for the first defined
group of the report form definition (in this example .FRG there is
only one Group break defined).

In the second IF statement we can see the Widow and Orphan checking
(described earlier) being performed.  The embedded IF statement is
checking for gl_widow to be set to .T. (TRUE) and for the current line
number + 1 to be greater than the line number at which a page break
would normally occur.  If this condition is true then a page break is
forced before attempting to print the text of the Group Intro.

The Group Intro text is then output.

The Detail Print Routine: Detail

```dos
249 PROCEDURE Detail
250 ?? AMOUNT PICTURE "99999.99" AT 0,
251 ?? COST PICTURE "99.99" AT 9,
252 ?? ARRIVE AT 16,
253 ?? CALC1 PICTURE "9999999.99" AT 26
254 ?
255 RETURN
256 * EOP: Detail
257
```


The routine Detail is where the text from the Detail Band of the
Report Form is output.  This routine is called from the main loop
("The Pace Maker", page 7).

A Group Summary Print routine: Foot96

```dos
258 PROCEDURE Foot96
259 ?? GRPSUM1 PICTURE "99999.99" AT 0,
260 ?? GRPSUM2 PICTURE "99.99" AT 9,
261 ?? GRPSUM3 PICTURE "9999999.99" AT 26
262 ?
263 RETURN
264
```


Like Head4, Foot96 is one example many possible print routines for
outputting the text of the Group Summary Bands.  Called by the Grpfoot
routine, Foot96 specifically prints the Group Summary text for the
first defined group of the report form definition (in this example
.FRG there is only one Group break defined).

The Report Summary Routine: Rsumm

```dos
265 PROCEDURE Rsumm
266 ?? RPTSUM1 PICTURE "99999.99" AT 0,
267 ?? RPTSUM2 PICTURE "99.99" AT 9,
268 ?? RPTSUM3 PICTURE "9999999.99" AT 26
269 gl_fandl=.F.        && last page finished
270 ?
271 RETURN
272 * EOP: Rsumm
273
```


The Rsumm, or Report Summary, procedure is the routine that outputs
the totals, averages, etc... specified in the Report Summary Band of
the Report Form definition.

The Page Footer Routine: Pgfoot

```dos
274 PROCEDURE Pgfoot
275 PRIVATE _box
276 gl_widow=.F.         && disable widow checking
277 ?
278 IF .NOT. gl_plain
279 ?? "This is the PAGE FOOTER" AT 26
280 ENDIF
281 EJECT PAGE
282 *-- is the page number greater than the ending page
283 IF _pageno > _pepage
284    GOTO BOTTOM
285    SKIP
286    gn_level=0
287 ENDIF
288 IF .NOT. gl_plain .AND. gl_fandl
289    DO Pghead
290 ENDIF
291 IF gn_level = 0 .AND. gl_fandl
292    gn_level=1
293    DO Grphead
294 ENDIF
295 gl_widow=.T.         && enable widow checking
296 RETURN
297 * EOP: Pgfoot
298
```


The Pgfoot or Page Footer routine performs four functions.  First and
foremost it prints the footer text defined in the Report Footer Band
of the Report Form definition and then performs a form feed to put us
at the top of the next page.

One of the options we have available to us from the Print menu or
through the dBASE IV system variables is to print a specific range of
pages (i.e. page 10 to page 20).  The Page Footer routine's second
task then is to check to see whether all of the requested pages have
been printed and if so, force the record pointer to the EOF (End Of
File) marker.  Doing so will cause the main DO WHILE loop ("The Pace
Maker") to be exited and the report to stop printing.

The third activity for the Page Footer routine is to call the Pghead
or Page Header routine to print the Page Heading on the next page.

The fourth activity is to call the Grphead or Group Header routine to
print the text for the Group Header band.  However this will only be
done if gn_level is equal to 0 meaning that we are in the process of
printing the records of the current group and not at the end of a
group where the Group Intro text would be printed anyway.

Some of the code seen here may or may not appear in all report form
.FRG files.  It is dependent on whether or not these sections have
been included in the Report Form definition. for example, if no Group
breaks had been defined, the code testing for the Group Intro would
not have been included.

Page Break Routine for a Plain Page Report: Pgplain

```dos
299 *-- Process page break when PLAIN option is used.
300 PROCEDURE Pgplain
301 PRIVATE _box
302 EJECT PAGE
303 IF gn_level = 0 .AND. gl_fandl
304    gn_level=1
305    DO Grphead
306 ENDIF
307 RETURN
308 * EOP: Pgplain
309
```


If the option PLAIN had been included when issuing the REPORT FORM
command, the Pgplain or Page Plain routine would be called to handle
page breaks.  The Page Plain routine causes a form feed and then
returns control to the main report loop without repeating the Page
Header or printing a Page Footer.

Resetting the Environment: Reset

```dos
310 *-- Reset dBASE environment prior to calling report
311 PROCEDURE Reset
312 SET SPACE &gc_space.
313 SET TALK &gc_talk.
314 ON ESCAPE
315 ON PAGE
316 RETURN
317 * EOP: Reset
```

The last routine is Reset.  Reset is used to put the dBASE IV
environment back to the state it was at prior to running the
report. 
