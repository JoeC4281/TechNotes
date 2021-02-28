# Ascending and Descending Indexes

Q.  Is there any way in a complex index to combine an ascending sort on a character field  plus a descending sort on a date field?

A.  With a little effort, you can create an index that does the trick with the help of the new DTOS() function. Try this expression:
```dos
INDEX ON <character field> +
    STR(10**8-VAL(DTOS(<date field>))) TAG[/TO]
    <.NDX file/.MDX tag>
```
The logic of the above expression takes the value of 1000,000,000 and subtracts the converted value of the date field using VAL() and DTOS().
