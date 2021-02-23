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
