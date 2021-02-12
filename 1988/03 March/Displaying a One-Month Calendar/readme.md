# Displaying a One-Month Calendar
Drawing a calendar on the screen with a dBASE III PLUS program is surprisingly challenging, in spite of the date functions available. The difficulty involves finding the first and last days of the month, and what weekdays they fall on. Once these tasks are completed, it wouldn't be difficult to print each day of the month under the proper day name.

A DO WHILE loop that prints one day of the month each time it loops is easy to implement, but it isn't as efficient or fast as it could be.

Calendar.PRG is a program that displays a calendar for a given month on the screen. It begins by storing the numbers 1 to 31 in a character memory variable. Then it adds blanks to the beginning of the string to adjust for the weekday on which the first day of the month falls and removes up to the last days of the month from the end of the string. Finally, the string is printed, one week's worth at a time directly to the screen. All the days of a month are displayed with six @...SAY commands, instead of up to 31.

To create Calendar, enter the code into a text file named Calendar.PRG using MODIFY COMMAND or another text editor.

Calendar can be used at the dot prompt, or could be called from your program's main menu as a convenience item. It requires one parameter, which must be a date that falls in the month of the calendar to be displayed. For example, to print the calendar for the current month, enter

```dos
DO Calendar WITH DATE()
```

To display a calendar for December 1948, enter

```dos
DO Calendar WITH CTOD("12/01/48")
```


##### Calendar.PRG
```dos
* Program ...: Calendar.PRG
* Author ....: Chuck Litzell
* Date ......: March 1, 1988
* Versions ..: dBASE III PLUS
* Notes .....: Displays a one-month calendar on the screen.
*
*    DO Calendar WITH <date>
*
*    Date must be a dBASE III PLUS date-type.
*
PARAMETERS date
*
SET TALK OFF
SET ESCAPE OFF

* ---The string stored in days will be adjusted for the
* ---days in the month.
days = "  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15" + ;
       " 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"
       
* ---row and col point to the upper left corner of the calendar.
* ---You can change them to display the calendar anywhere you like.
* ---The maximum row is 13 (on a 25-line display) and the maximum
* ---column is 56.
row = 1
col = 54

* ---Draw the Calendar's Frame.
@ row +  1, col CLEAR TO row + 10, col + 23
@ row +  1, col TO row + 10, col + 23
@ row, col + 2 TO row + 2, col + 21 DOUBLE
@ row + 1, col + 3 CLEAR TO row + 1, col + 20
@ row + 3, col + 2 SAY "Su Mo Tu We Th Fr Sa"

* ---Construct a title for the calendar.
cmonth = UPPER(CMONTH(date)) + ", " + STR(YEAR(date), 4)
cmonth = STUFF(SPACE(18), (20 - LEN(cmonth)) / 2, ;
         LEN(cmonth), cmonth)

* ---Calculate the first day of the month.
wdate = date - DAY(date) + 1

* ---And the number of days in the month.
last = DAY((wdate + 31) - DAY(wdate + 31))

* ---Add enough blanks to beginning of days string to make
* ---the first fall on the correct day, and enough blanks to 
* ---the end to fill out six weeks.
days = SPACE((DOW(wdate) - 1) * 3) + LEFT(days, 3 * last)
days = days + SPACE(126 - LEN(days))

* ---Display  the results
@ row + 1, col + 3 SAY cmonth
@ row + 4, col + 1 SAY LEFT(days, 21)
@ row + 5, col + 1 SAY SUBSTR(days, 22, 21)
@ row + 6, col + 1 SAY SUBSTR(days, 43, 21)
@ row + 7, col + 1 SAY SUBSTR(days, 64, 21)
@ row + 8, col + 1 SAY SUBSTR(days, 85, 21)
@ row + 9, col + 1 SAY RIGHT(days, 21)
RETURN
* EOP: Calendar.PRG
```
