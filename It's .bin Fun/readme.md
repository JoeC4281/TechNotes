# TechNotes
July 1990<br>
Page 2

Erik McBeth

You might have seen Curson.bin or GetDriv.bin in your samples directory and wondered, "Just what are "bin" files anyway?" Or perhaps you have used them and were curious about how they were created. In either case, this article should give insight into the wonderful world of .bin files and their creation using the language simply known as C.

Binary, or .bin, files are assembly language files that can be loaded into memory from within another program and then executed. Not to be confused with programs which are executed via the RUN command from inside of a dBASE IV program or from the dot prompt, .bin files almost become part of the dBASE IV program itself and have the luxury of speed because they are only loaded once into memory and from there, they can be executed quickly. Conversely, programs which are RUN from the dot prompt must be loaded each time you want to execute them.

dBASE IV has two special commands that it uses when handling .bin files: LOAD and CALL. The LOAD command does exactly what you'd think it would do, it loads the .bin file into a special area of memory that is reserved for this purpose. The CALL command (and the CALL() funciton) runs the .bin file with the parameters you supply, (that is, memory variables, strings, and so on). These parameters are palced in a special place in memoury so that the .bin file cna find and act upon them. You can pass up to seven parameters.

## Interfacing dBASE IV with C

Well you might have come to the conclusion that since we're loading assembly language routines into memory that we are forced into using that cryptic computer language known a Assembly with all it strange abbreviated commands. It's not quite that bad. Instead, you'll be shown how to write programs in the somewhat less crypitc language of C.

The C language has been around for about 20 years or so. It originally grew out of a research project and was subsequently used in the writing of the UNIX operating system. Numerous companies make C compilers including Borland International and Microsoft and the price for a compiler has come down substantially in the last few years. Add to this the large library of reference material available on C and you can see that C is a good choice for a language we can use to create our .bin files.

Those familiar with C might be saying "Well great, I'll just convert my 8000 line directory management C program into a .bin file!" Wrong! If you have this great program just run it from the dot prompt with the RUN command. Speaking from personal experience, most programs written in C probably can't be turned into a .bin file or, at worst, would take so much rewriting and dipping into assembler that it wouldn't be worth the effort. Most C functions supplied by the manufacturer of the compiler (printf for example) probably won't work in a .bin file. All I/O (input/output) operations for the most part must be handled in assembler.

## Reversing Character Strings

Now let's do a more in-depth study on how we put together a C file. We'll look at two sample C files to get an idea of what is involved when constructing C code which will eventually be used inside of dBASE IV. The first file, StrRev.C, reverses the order of the letters in a string. The second one, StrDct.C, is used in instances when you want to place data in true dictionary order (more on "dictionary" order later). This example illustrates how multiple parameters to a .bin file can be passed by referencing an array that contains up to seven parameter addresses. For this example, we keep it simple and just use the first address parameter in the array. The hooks are in there to allow for expansion to more parameters.

Let's start with StrRev.C (a function which reverses the characters in a string) because of its simplicity. We'll try to dissect this C program as much as possible so as to get a better understanding of all that is involved in making .bin files. Once you have a pretty good understanding of the various sections of a C file you can easily take this code and substitute in your own function in place of StrRev().

## Creating an .exe file

We start out by defining a constant known as EXE. Often times, it is easier to test your .bin file by first turning it into a small program that can be run from the DOS level; a file known as an executable file. In our StrRev example, we have constructed the file in such a way that if the constant EXE equals 1, we will then get our string parameter from the DOS prompt and print out its reverse using the C function Printf() (somewhat like the dBASE IV ? command). Since the size of your C program and other memory limitations can be weighing factors, there is no guarantee that your .exe program will run as a .bin file in dBASE IV, but at least you'll feel a little more confident of your coding.

Next we "#include" the header file known as StrLib.H which contains various definitions that we'll be using in our program, most notably the register variable BX, CX, and so on. Our StrLib.H file also contains a C macro called MK LONG() which is critical to the success of the bin file creation. If we were constructing an .exe file instead of a .bin we would also need to read in the header file known as stdio.H. Our "#if EXE" statement would take care of this automatically.

The next few lines deal with what would be required to make our .exe file so it could run from DOS. I'll leave out the details of what these lines are doing so we can quickly jump into what we're here for: .bin file creation.

Starting after the "#else" statement we see:

`void far main()`

This is declaring the main starting point of our program. It is very important that we declare main() in this way. The use of the keyword "far" causes the compiler to issue a far return (RETF) at the end of the program. This type of return is needed so that dBASE IV can jump back to what it was doing before it called your .bin file. Some C enthusiasts may have noticed that we are declaring our main function as "void", which usually means we don't want to return anything to the function/program that called the routine. In this case, we are not returning anything, just jumping back to dBASE.

## 1010 Memory Lane

In the next three lines of code, we grab the string that dBASE IV has passed to the .bin file. dBASE sends a string to a .bin file by passing the address of where the string is stored in memory.

Memory addresses are composed of two parts, a segment and the offset into the segment. Think of this as a street and an address number. The street is the segment, and the offset is the address number. The segment address of the string is passed to the DS register and the offset to the BX register.

Registers are special memory locations within the computer's processor that programs use to pass information back and forth. In our .bin file, we cannot directly access the various registers so we need some kind of bridge which will allow us to do so. The assembly language procedure Getregs() does just this. It takes the various registers (DS, BX, and so on) and copies them into variables that the C program can use. The DS and BX registers that you see in StrRev are actually program variables. Our MK_LONG macro then takes these two variables/registers and converts them into a memory address that the C program can use. This address is then assigned to our variable "p" which can then be processed by a string function such as StrRev(). If all of this sounds complicated just remember that all you really need to do in the future is copy in these first few lines into your own .bin file and you'll be set!

Well, the hard part is over. All we need to do now is write the string function that we'll be using with our "p" variable. In this case we have the StrRev function but you could just as easily have a function which selectively alters upper or lower case, opens access to non-dBASE files or even encrypts it for security. Use your imagination. Our StrRev function reverses the order of the characters in a string by exchanging characters from the two ends until they meet each other in the middle. Any changes we make in our string function will be reflected in the string that is returned to dBASE IV. For this reason do not shorten or lengthen the string in any way because unpredictable results might follow.

## Sorting in Dictionary Order

We've looked at a rather simple example of a C program that we can use to create a .bin routine. Now lets look at a slightly more complicated example which has the ability to pass multiple parameters (a maximum of seven) to a .bin file. Our example will still only use one parameter though, just to keep it simple. The example in question is StrDct.C, a rudimentary translating function which we can use to place a data file in "dictionary order".

We start out the C program in much the same way as our previous example. We "#include" some information and make sure that we generate a far return by declaring the main() function "void far main()". We then declare two variables, argc and argv (seasoned C programmers will no doubt recognize these old standbys). Argc will contain the number of parameters passed plus one, and argv will be an array containing the parameters with the first parameter being in argv[1]. These values are in keeping with more traditional non-bin programming.

Remember when we talked about memory registers and how dBASE IV communicates with .bin files? dBASE IV can talk with .bin files in either the traditional dBASE III PLUS way (through the DS:BX register pair) or in its extended mode which allows multiple parameters and a special register to tell us how many actual parameters were passed. With this flexibility we can even write .bin files which take a variable number of parameters, something we can't do in UDFs.

dBASE III PLUS passed its parameter into a BX register. Since dBASE IV passes an array or table of parameters into a ES:DI register pair, an additional parsing routine in the C program is required.

Multiple arguments are accomplished in dBASE IV by sending our .bin file the address of a table in memory which in turn contains the individual addresses of our parameters. You can think of this as an usher who directs us to the betting windows at a horse track. Once we find the betting area, we only have to go up to a specific window to place our bet or get our parameter. dBASE passes the address of the "betting windows" in the ES:DI register pair and the number of windows/parameters in the CX register. We learned earlier of segment and offset and how they pertain to memory addresses. Each betting window is four bytes away from its neighbor with the address of the first window starting at zero. Thus, the address of the first window is in the ES segment with an offset of DI plus zero and its neighbor has an offset of four greater (DI plus four). You see, you don't really have to understand everything about .bin files in order to make and use them.

After we assign memory locations to the elements in argv we are ready to call our StrDct function. We first check to see that the value of argc is greater than one (remember that the ARGument Count is one greater than the number of parameters passed by dBASE) so that we know that we have a string to play with before calling StrDct(). StrDct rearranges the sorting sequence of letters from normal alphabetical order (which is used by dBASE IV) to dictionary order. Dictionary
order is generally defined as an order in which special symbols (#, &) are placed first, then letters and then numbers, much like a dictionary. This dictionary sequencing is borrowed from Framework III, which places words in this order instead of the ASCII ordering which dBASE uses by default (some special symbols, then numbers, then letters). The ordering presented in StrDct is NOT case sensitive; upper case does not necessarily come before lower case.

We should now examine how we turn our completed and presumably tested C programs into .bin files. I'll demonstrate the construction process with the two compilers and assemblers from Borland and Microsoft; other compilers/assemblers should be fairly similar. Remember, besides the assemblers and compilers, you will need LINK.exe and EXE2BIN.exe, both of which come with most versions of DOS. The process will involve:

1. Compiling the C program to an object file.
2. Assembling the Getregs.ASM file to an object file.
3. Linking these two object file into one .exe file.
4. Running EXE2BIN on the resulting .exe file.

The specific steps for the two compilers mentioned are detailed below:\

| Borland | Microsoft | 
|---------|-----------|
|1. ALT-F9 in editor | cl -c .C|
|2. TASM Getregs.asm  | MASM Getregs.asm,,,,|
|3. LINK filename+Getregs,,,,|  |
|4. EXE2BIN|    |

The filename reference would be either StrDct, StrRev, or StrFlp and you should end up with a file like StrDct.bin, and so on. You can mix and match assemblers and compilers since they all produce the same kind of object format. You'll know something went wrong if either LINK gives an error (other than the Warning no stack message) or EXE2BIN says, File can't be converted. All these examples work so you shouldn't have any problems. One small note, if you use TURBO C and set TURBOC to 1 in Strlib.H you can eliminate steps 2 and 3 above.

## Running the Routine from dBASE IV

Now the real fun begins, we get to try out our .bin files in dBASE. We'll look at three different ways that we can use our .bin files with dBASE. All three ways can be mixed and matched with other .bin files.

Let's first use our simplest .bin file, StrRev, since it is fairly easy to tell if a string has been reversed or not. From the dBASE IV dot prompt, type
```
LOAD StrRev && loads StrRev into memory
x="John" && test string
CALL StrRev WITH x && call Strrev
? x && what is the value now?
```
You should have seen "nhoJ" displayed if everything went ok. Repeat steps two through four with different values to make sure our STRing REVersal is working.

We can go ahead and create a UDF that will CALL StrRev with whatever string we gave it and then return the reversed string, but let's not. Instead, let's create a UDF called Strflp() which calls our StrFlp.bin file. StrFlp is a .bin file which "flips" ASCII characters. Those characters which have an ASCII value of 127 and below will have the value of 128 added (the letter 'A' which has a value of 65 would end up with a value of 193) and those above 127 will have 128 subtracted (160 becomes 32 or the space character).

Enter the dBASE IV text editor by typing MODIFY COMMAND from the dot prompt. The code for our UDF is shown below.
```
FUNCTION StrFlp
* Strflp should have already been LOADed.
PARAMETER str
temp = str
CALL Strflp WITH temp
RETURN temp
```
After compiling this function, from the dot prompt, type:

`? StrFlp("flip")`

The result should look something like mq . Remember that StrFlp flips the value of the characters in a string so that characters which use to come at the start of the ASCII table now come at the end and vice-versa. If we do something like:

`? StrFlp("mq")`

we get "flip" back again since now the characters at the end of the ASCII table are transposed into characters at the beginning.

Note that on page 9 is a section of code with extensive repetitive array assignments. At first glance, it would appear as if this could and should be done more concisely and programmatically. Indeed, this is the approach you would take if you were creating a stand-alone .exe program. Unfortunately, this approach does not work when constructing .bin files. The reason is that most C compilers place array tables into the uninitialized data segment, also known as the BSS. dBASE IV
could not consistently deal with data in the BSS and would return bad values intermittently. Therefore, it was necessary to create a table on the fly by assigning values to the array elements explicitly.

The program is available on the Ashton-Tate BBS if you wish to download it.

Now for our final example involving StrDct and putting database files in dictionary order. One of the advantages of .bin files is that they have the capability of being used for indexing via the CALL() function (as opposed to CALL command) in dBASE IV. If we have a database file that we decide we want in dictionary order, or StrRev order, or StrFlp order, all we need to do is the following:
```
USE Datafile
LOAD Strdct
INDEX ON CALL("Strdct",fieldname + "") TO Indexfile
```
dBASE IV will then call StrDct for each record so that it can place our data in dictionary order. It is important to remember that whenever we use this datafile and index in the future to LOAD StrDct first. This indexing feature works well with StrFlp also. Suppose you wanted to put your file in order by last name plus first name but the first names needed to be in descending order, you could try this:
```
LOAD StrFlp
USE Namefile
INDEX ON lastname+CALL("StrFlp",firstname+"") TO Lfname
```
This puts the last names in ascending order but the first names in descending order. You might be wondering why we need to add the + "" to the firstname field. This prevents dBASE IV from permanently changing the contents of the firstname field to whatever StrFlp would return.

Well that about wraps up our journey into the world of C and dBASE .bin files. I hope you've seen that .bin files are really not that complicated once you understand a few of the guidelines and principles involved in their creation. .bin files provide for useful and powerful extensions to the dBASE language that in turn allow programmers to develop and code more extensive and powerful programs.

```StrRev.C
/* Program ...: Strrev.C
Author ....: Erik A McBeth
Version ...: dBASE III Plus 1.0, 1.1
             dBASE IV 1.0, 1.1
             (Tested compilers/assemblers)
             Turbo C 1.5, 2.0 TASM 1.0
             Microsoft C 5.1 MASM 5.1
*/

#define EXE 0 /* Set to 1 if we want to create an exe,
                If we have an exe then run from DOS like this
                STRREV string and you'll see your string reversed */

#include "strlib.h" /* Various definitions */

#if EXE
#include "stdio.h"

main(argc,argv)
int argc;
char *argv[];
{
    unsigned char *p;

    p = (unsigned char *)argv[1];

#else /* Creating BIN file */

void far main() /* Need a FAR return */
{
    unsigned char *p;
    
    Getregs(); /* Get our memory registers */
    
    p = (unsigned char *)MK_LONG(DS,BX); /* Get our string */
#endif /* If EXE */

    if (p)
        Strrev(p); /* Same operation if we do a bin or an exe */
#if EXE
    printf("%s\n",p);
#endif
}

Strrev(str)
unsigned char *str;
{
    unsigned char *p=str,ch;

/*  Go to the end of the string and stop */
    while(*++p);

/*  Now swap the letters until we come to the middle of the string
*/
    for(--p;p>str;p--,str++) {
        ch = *p;
        *p = *str;
        *str = ch;
    }
}
```
```StrDct.C
/* Program ...: Strdct.C
Version ...: dBASE III Plus 1.0, 1.1
            dBASE IV 1.0, 1.1
            (Tested compilers/assemblers)
            Turbo C 1.5, 2.0 TASM 1.0
            Microsoft C 5.1 MASM 5.1
*/

#include "strlib.h"

void far main() /* very important, make sure we get a far return */
{

/*  Tried to make this look familiar to 'C' programmers, Notice the
    use of argc and argv, I've set argc to have a value of 2 to
    simulate the routine being called from the DOS prompt */

    int argc;
    unsigned char *argv[6];

    Getregs(); /* Assign memory registers */

/*  Translate the parameter passed by dBASE IV into something we
    can use, The argv[2] and argv[3] are placed here to show
    you how to read multiple parameters */

    argc = CX+1; /* Number of arguments */
    argv[1] = (unsigned char *)*((int *)MK_LONG(ES, DI + 0));
    argv[2] = (unsigned char *)*((int *)MK_LONG(ES, DI + 4));
    argv[3] = (unsigned char *)*((int *)MK_LONG(ES, DI + 8));

    if (argc>1) /* Do we have a string to use? */
        Strdct(argv[1]);

}

Strdct(str)
unsigned char *str;
{

/*  Had to do it this way, couldn't do "trnslt[]={" */

/*  Read from AMENG.SO (Framework III). Table is case insensitive */
    static unsigned char trnslt[256];

    trnslt[ 0]= 0; trnslt[ 1]= 1; trnslt[ 2]= 2; trnslt[3]= 3;
    trnslt[ 4]= 4; trnslt[ 5]= 5; trnslt[ 6]= 6; trnslt[7]= 7;
    trnslt[ 8]= 8; trnslt[ 9]= 9; trnslt[ 10]= 10; trnslt[11]= 11;
    trnslt[ 12]= 12; trnslt[ 13]= 13; trnslt[ 14]= 14; trnslt[15]= 15;
    trnslt[ 16]= 16; trnslt[ 17]= 17; trnslt[ 18]= 18; trnslt[19]= 19;
    trnslt[ 20]= 20; trnslt[ 21]= 21; trnslt[ 22]= 22; trnslt[23]= 23;
    trnslt[ 24]= 24; trnslt[ 25]= 25; trnslt[ 26]= 26; trnslt[27]= 27;
    trnslt[ 28]= 28; trnslt[ 29]= 29; trnslt[ 30]= 30; trnslt[31]= 31;
    trnslt[' ']=' '; trnslt['!']='!'; trnslt['\"']='\"';trnslt['#']='#';
    trnslt['$']='$'; trnslt['%']='%'; trnslt['&']='&';trnslt['\'']='\'';
    trnslt['(']='('; trnslt[')']=')'; trnslt['*']='*';trnslt['+']='+';
    trnslt[',']=','; trnslt['-']='-'; trnslt['.']='.';trnslt['/']='/';
    trnslt['0']='k'; trnslt['1']='l'; trnslt['2']='m';trnslt['3']='n';
    trnslt['4']='o'; trnslt['5']='p'; trnslt['6']='q';trnslt['7']='r';
    trnslt['8']='s'; trnslt['9']='t'; trnslt[':']='0';trnslt[';']='1';
    trnslt['<']='2'; trnslt['=']='3'; trnslt['>']='4';trnslt['?']='5';
    trnslt['@']='6'; trnslt['A']='7'; trnslt['B']='>';trnslt['C']='?';
    trnslt['D']='A'; trnslt['E']='B'; trnslt['F']='G';trnslt['G']='H';
    trnslt['H']='I'; trnslt['I']='J'; trnslt['J']='O';trnslt['K']='P';
    trnslt['L']='Q'; trnslt['M']='R'; trnslt['N']='S';trnslt['O']='U';
    trnslt['P']='['; trnslt['Q']='\\'; trnslt['R']=']';trnslt['S']='^';
    trnslt['T']='_'; trnslt['U']='`'; trnslt['V']='e';trnslt['W']='f';
    trnslt['X']='g'; trnslt['Y']='h'; trnslt['Z']='j';trnslt['[']='u';
    trnslt['\\']='w'; trnslt[']']='x'; trnslt['^']='y';trnslt['_']='z';
    trnslt['`']='{'; trnslt['a']='7'; trnslt['b']='>';trnslt['c']='?';
    trnslt['d']='A'; trnslt['e']='B'; trnslt['f']='G';trnslt['g']='H';
    trnslt['h']='I'; trnslt['i']='J'; trnslt['j']='O';trnslt['k']='P';
    trnslt['l']='Q'; trnslt['m']='R'; trnslt['n']='S';trnslt['o']='U';
    trnslt['p']='['; trnslt['q']='\\'; trnslt['r']=']';trnslt['s']='^';
    trnslt['t']='_'; trnslt['u']='`'; trnslt['v']='e';trnslt['w']='f';
    trnslt['x']='g'; trnslt['y']='h'; trnslt['z']='j';trnslt['{']='|';
    trnslt['|']='}'; trnslt['}']='~'; trnslt['~']=127;trnslt[127]=128;
    trnslt[128]='@'; trnslt[129]='a'; trnslt[130]='C';trnslt[131]=':';
    trnslt[132]='8'; trnslt[133]=';'; trnslt[134]='9';trnslt[135]='@';
    trnslt[136]='D'; trnslt[137]='E'; trnslt[138]='F';trnslt[139]='K';
    trnslt[140]='L'; trnslt[141]='M'; trnslt[142]='8';trnslt[143]='9';
    trnslt[144]='C'; trnslt[145]= 0; trnslt[146]= 0;trnslt[147]='W';
    trnslt[148]='V'; trnslt[149]='X'; trnslt[150]='b';trnslt[151]='c';
    trnslt[152]='i'; trnslt[153]='V'; trnslt[154]='a';trnslt[155]=129;
    trnslt[156]=130; trnslt[157]=131; trnslt[158]=132;trnslt[159]=133;
    trnslt[160]='<'; trnslt[161]='N'; trnslt[162]='Y';trnslt[163]='d';
    trnslt[164]='T'; trnslt[165]='T'; trnslt[166]='=';trnslt[167]='Z';
    trnslt[168]=134; trnslt[169]=135; trnslt[170]=136;trnslt[171]=137;
    trnslt[172]=138; trnslt[173]=139; trnslt[174]=140;trnslt[175]=141;
    trnslt[176]=142; trnslt[177]=143; trnslt[178]=144;trnslt[179]=145;
    trnslt[180]=146; trnslt[181]=147; trnslt[182]=148;trnslt[183]=149;
    trnslt[184]=150; trnslt[185]=151; trnslt[186]=152;trnslt[187]=153;
    trnslt[188]=154; trnslt[189]=155; trnslt[190]=156;trnslt[191]=157;
    trnslt[192]=158; trnslt[193]=159; trnslt[194]=160;trnslt[195]=161;
    trnslt[196]=162; trnslt[197]=163; trnslt[198]=164;trnslt[199]=165;
    trnslt[200]=166; trnslt[201]=167; trnslt[202]=168;trnslt[203]=169;
    trnslt[204]=170; trnslt[205]=171; trnslt[206]=172;trnslt[207]=173;
    trnslt[208]=174; trnslt[209]=175; trnslt[210]=176;trnslt[211]=177;
    trnslt[212]=178; trnslt[213]=179; trnslt[214]=180;trnslt[215]=181;
    trnslt[216]=182; trnslt[217]=183; trnslt[218]=184;trnslt[219]=185;
    trnslt[220]=186; trnslt[221]=187; trnslt[222]=188;trnslt[223]=189;
    trnslt[224]=190; trnslt[225]= 0; trnslt[226]=192;trnslt[227]=193;
    trnslt[228]=194; trnslt[229]=195; trnslt[230]=196;trnslt[231]=197;
    trnslt[232]=198; trnslt[233]=199; trnslt[234]=200;trnslt[235]=201;
    trnslt[236]=202; trnslt[237]=203; trnslt[238]=204;trnslt[239]=205;
    trnslt[240]=206; trnslt[241]=207; trnslt[242]=208;trnslt[243]=209;
    trnslt[244]=210; trnslt[245]=211; trnslt[246]=212;trnslt[247]=213;
    trnslt[248]=214; trnslt[249]=215; trnslt[250]=216;trnslt[251]=217;
    trnslt[252]=218; trnslt[253]=219; trnslt[254]=221;trnslt[255]=222;

/*  Go through the string and substitute the new value based on the
    value of the old character */

   for(;*str;str++) {
      *str = trnslt[(int)*str];
   }

}
```
```
StrFlp.C
/* Program ...: Strflp.C
Version ...: dBASE III Plus 1.0, 1.1,
             dBASE IV 1.0, 1.1
             (Tested compilers/assemblers)
             Turbo C 1.5, 2.0 TASM 1.0
             Microsoft C 5.1 MASM 5.1
*/

#include "strlib.h" /* Some definitions */

void far main() /* Need a FAR return */
{
    unsigned char *p;

    Getregs(); /* Get our memory registers */

    p = (unsigned char *)MK_LONG(DS,BX); /* Get our string */

    if (p)
        Strflp(p);

}

Strflp(str)
unsigned char *str;
{
/* Go through the string and subtract character ASCII value from 255 */
    for(;*str;str++) {
        *str = (unsigned char) (((int)*str+128) % 256);
    }

}
```
```
StrLib.H
/* Program ...: Strlib.H
Version ...: Use with
            Strdct.C
            Strflp.C
            Strrev.C

    Header file which contains various definitions and information
    on how functions are called.

*/

#define TURBOC 0 /* Set true if compiler supports "pseudoregisters" like
                    Turbo C, this way you don't have to link in getregs.obj */

#define MK_LONG(hi,low) (((unsigned long)(hi) << 16) | (unsigned)(low))
#define isdigit(ch) (ch >= '0' && ch <= '9')
#define isspace(ch) (ch==' ' || ch=='\t' || ch=='\r')

/*  These are function "prototypes", some compilers don't like
    these so you can delete them if they give a problem */
int Strdct(unsigned char *str);
int Strflp(unsigned char *str);
int Strrev(unsigned char *str);
int Getregs(void);

unsigned DS, BX, ES, DI, CX;

#if TURBOC

#define Getregs() (DS=_DS, BX=_BX, ES=_ES, DI=_DI, CX=_CX)

#endif
```
```
; Program ...: GetRegs.asm
; Version ...: dBASE III Plus 1.0, 1.1
;              dBASE IV 1.0, 1.1
;              (Tested assemblers)
;              TASM 1.0
;              MASM 5.1
; File loads global variables with the values of the actual memory registers.

_DATA SEGMENT PUBLIC 'DATA'

EXTRN _BX:WORD ; These variables are in 'C' file
EXTRN _CX:WORD
EXTRN _ES:WORD
EXTRN _DI:WORD
EXTRN _DS:WORD

PUBLIC __acrtused,__chkstk ; Microsoft C needs to find these
__acrtused = 9876h
__chkstk = 0
_DATA ENDS
DGROUP GROUP _DATA

_TEXT SEGMENT PUBLIC 'CODE'
ASSUME CS:_TEXT,DS:DGROUP,ES:DGROUP,SS:DGROUP

PUBLIC _Getregs
_Getregs PROC NEAR
MOV _BX,BX
MOV _CX,CX
MOV _ES,ES
MOV _DI,DI
MOV _DS,DS
RET
_Getregs ENDP

_TEXT ENDS
CGROUP GROUP _TEXT
END
```
