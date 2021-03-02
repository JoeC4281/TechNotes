# &

In dBASE III PLUS, a macro function referencing an undefined memory variable is used literally in commands that create files. For example,

```dos
*----Release all memory variables.
CLEAR MEMORY
mem = 93459.34
SAVE TO &mvar
```


creates a disk file called "&memvar.MEM" on the default drive. Other dBASE III PLUS commands that create files behave identically. This is true for every version of dBASE III PLUS.
