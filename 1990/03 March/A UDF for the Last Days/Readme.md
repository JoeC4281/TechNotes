# A UDF for the Last Days

Some times, it is convenient to know before hand, the last day of the month before a reporting period. Here is a means of accomplishing that feat with the help of a UDF.

```dos
FUNCTION LDM
  ** This function returns the last day of the month for
  ** the numeric 1-12 entered.
  
  PARAMETER monum
  SET TALK OFF
  
  IF MONUM <= 13
    ldm = CTOD(LTRIM(STR(ABS(monum) + 1 )) + '/01/' '
        + LTRIM(STR(YEAR(DATE))))) -1
  ELSE
    ldm = CTOD('  /  /  ')
  ENDIF
  
  SET TALK ON
  
RETURN(ldm)
```
Suppose you are preparing a report in which you need to give the full reporting period using the exact days. Let's also assume that you are running your report in the starting month and that the ending period is the last day of the following month. Also assume that the starting date is the computer system date (returned by the DATE() function).

Using the UDF above, your expression would look somethhing like this:

```dos
LDM(MONTH(DATE()))
```

Since this function employs the ABS() function, negative numbers will be implied as positive. The IF clause will not act on numbers greater than the number of months in a year. However, there may be instances where using a greater number would be appropriate. Since any number greater than 12 translates to the applicable month in the following year (i.e. 14 would be February), you may want to modify the UDF by removing the IF clause to expand the data entry range.
