TechNotes
July 1990
Page 2

Erik McBeth

You might have seen Curson.bin or GetDriv.bin in your samples directory and wondered, "Just what are "bin" files anyway?" Or perhaps you have used them and were curious about how they were created. In either case, this article should give insight into the wonderful world of .bin files and their creation using the language simply known as C.

Binary, or .bin, files are assembly language files that can be loaded into memory from within another program and then executed. Not to be confused with programs which are executed via the RUN command from inside of a dBASE IV program or from the dot prompt, .bin files almost become part of the dBASE IV program itself and have the luxury of speed because they are only loaded once into memory and from there, they can be executed quickly. Conversely, programs which are RUN from the dot prompt must be loaded each time you want to execute them.

dBASE IV has two special commands that it uses when handling .bin files: LOAD and CALL. The LOAD command does exactly what you'd think it would do, it loads the .bin file into a special area of memory that is reserved for this purpose. The CALL command (and the CALL() funciton) runs the .bin file with the parameters you supply, (that is, memory variables, strings, and so on). These parameters are palced in a special place in memoury so that the .bin file cna find and act upon them. You can pass up to seven parameters.

Interfacing dBASE IV with C

Well you might have come to the conclusion that since we're loading assembly language routines into memory that we are forced into using that cryptic computer language known a Assembly with all it strange abbreviated commands. It's not quite that bad. Instead, you'll be shown how to write programs in the somewhat less crypitc language of C.

The C language has been around for about 20 years or so. It originally grew out of a research project and was subsequently used in the writing of the UNIX operating system. Numerous companies make C compilers including Borland International and Microsoft and the price for a compiler has come down substantially in the last few years. Add to this the large library of reference material available on C and you can see that C is a good choice for a language we can use to create our .bin files.

Those familiar with C might be saying "Well great, I'll just convert my 8000 line directory management C program into a .bin file!" Wrong! If you have this great program just run it from the dot prompt with the RUN command. Speaking from personal experience, most programs written in C probably can't be turned into a .bin file or, at worst, would take so much rewriting and dipping into assembler that it wouldn't be worth the effort. Most C functions supplied by the manufacturer of the compiler (printf for example) probably won't work in a .bin file. All I/O (input/output) operations for the most part must be handled in assembler.

Reversing Character Strings

Now let's do a more in-depth study on how we put together a C file. We'll look at two sample C files to get an idea of what is involved when constructing C code which will eventually be used inside of dBASE IV. The first file, StrRev.C, reverses the order of the letters in a string. The second one, StrDct.C, is used in instances when you want to place data in true dictionary order (more on "dictionary" order later). This example illustrates how multiple parameters to a .bin file can be passed by referencing an array that contains up to seven parameter addresses. For this example, we keep it simple and just use the first address parameter in the array. The hooks are in there to allow for expansion to more parameters.

Let's start with StrRev.C (a function which reverses the characters in a string) because of its simplicity. We'll try to dissect this C program as much as possible so as to get a better understanding of all that is involved in making .bin files. Once you have a pretty good understanding of the various sections of a C file you can easily take this code and substitute in your own function in place of StrRev().

Creating an .exe file

We start out by defining a constant known as EXE. Often times, it is easier to test your .bin file by first turning it into a small program that can be run from the DOS level; a file known as an executable file. In our StrRev example, we have constructed the file in such a way that if the constant EXE equals 1, we will then get our string parameter from the DOS prompt and print out its reverse using the C function Printf() (somewhat like the dBASE IV ? command).