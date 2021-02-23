? LDM( MONTH (DATE() ) )
RETURN

FUNCTION LDM
  ** This function returns the last day of the month for
  ** the numeric 1-12 entered.
  
  PARAMETER monum
  SET TALK OFF
  
  IF MONUM <= 13
    theMonth = LTRIM( STR( ABS( monum ) + 1 ) )
    theDay   = '/01/'
    theYear  = LTRIM( STR( YEAR( DATE() ) ) )
    ldm      = CTOD( theMonth + theDay + theYear ) - 1
  ELSE
    ldm = CTOD('  /  /  ')
  ENDIF
  
  SET TALK ON
  
RETURN(ldm)
