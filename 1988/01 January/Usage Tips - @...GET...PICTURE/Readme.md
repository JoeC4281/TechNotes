# TechNotes
January 1988<br>
Page 31

When the PICTURE clause of an @...GET...PICTURE command contains conflicting variable length, template, or function arguments, the template may override the function or the value may override the template.

Table 1 includes some possibilities.

```
mem  = 'AAAA'
mem1 = 100
mem2 = 0
SET DELIMITERS ON

     Picture
mvar clause        Display   Comment
mem  'xx'          :AA:      Template overrides length.
mem  'xxxxxxxx'    :AAAA:    Length overrides template.
mem  '@S2 xxxx'    :AA:      Scrolls.
mem  '@S3 xxxx'    :AAA:     Scrolls.
mem  '@S5 xxxxxxx' :AAAA:    Length overrides arguments.
mem  '@S5 x'       :A:       No scroll, template overrides all.
mem1 '@B *******'  :100*    :Function puts value over template
                               and template incorrectly puts
                               spaces where the value would
                               have been placed if there were
                               no function.
mem2 '@Z *******'  :*******:   Template overrides function.
```

