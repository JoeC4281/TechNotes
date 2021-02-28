# Disabling the Cursor Keys

Q.  Is there any way to disable the arrow keys (specifcally, the right and left arrow keys) when I am in a popup?

A.  Using the ON KEY LABEL command and the appropriate key references (See the Language Reference manual for a complete list of key names), you can reference a procedure in your program that does nothing but issue a RETURN which would simply direct back to the part of the program being executed when the trapped keystroke was detected. Place these two statements at the beginning of your program.
```dos
ON KEY LABEL RIGHTARROW DO NOTHING
ON LEY LABEL LEFTARROW DO NOTHING
```
Then at the end of your program, place this "uneventful" procedure.
```dos
PROCEDURE NOTHING
RETURN
```
Now when a user presses the right or left arrows, nothing will occur.
