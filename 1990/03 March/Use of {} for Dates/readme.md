# Use of {} for Dates

dBASE IV introduced the ability to use curly braces "{}" to create dates from literals. This is similar to the CTOD(), Character TO Date function, which will convert a character string to a date. The CTOD() will accept either a literal or a character expression such as the name of a memory variable or database field.

The most useful form of the {} is to create blank dates. For instance,

```dos
blank_date={}
```
will create an empty date variable called "blank_date" that can now be used in a @...GET to accept values as date expression for the "blank_date" memory variable.

The following lists a few more comparisons of CTOD() and {}:

```dos
CTOD(<expC>)        A date variable
{<expC>}            An error since {} only accepts literals
{01/08/90}          The date 01/08/90
{}                  A blank date value
{}=mdatevar         Checking for a blank date in mdatevar
.NOT. {}=mdatevar   Check for a non-blank date
```
