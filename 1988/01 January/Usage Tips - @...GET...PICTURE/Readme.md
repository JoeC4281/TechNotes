# Usage Tips - APPEND FROM ... SDF/DELIMITED and Dates

Text files in the SDF or DELIMITED formats can be brought into a dBASE III PLUS database file using the commands
```dos
APPEND FROM <filename> TYPE SDF
```
or
```dos
APPEND FROM <filename> TYPE DELIMITED
```
If the source file includes dates, you may need to bring the date into a character or numeric field and then perform a conversion process to create a valid dBASE date.

In dBASE III and dBASE III PLUS database files, dates are stored as a string of eight digits:
```dos
YYYYMMDD
```
For example, January 15, 1988 would be stored as 19880115. If the dates in your text file are in this format, you can bring them directly into a date field. All eight digits must be present for this to work correctly.

If your date is in any other format, you will need to perform at least one conversion step to remformat the date.

If the date in the source text file is stored as "MM/DD/YY" or "MM/DD/YYYY", establish a character field with a field length of eight or ten characters, depending on whether the dates have a two- or four-digit year. After you have APPENDed the text file, MODIFY STRUCTURE and change the character field to a date field.

dBASE III PLUS will correctly convert the character date to a date field. For dates stored in other formats, follow these general steps:

1. APPEND into a temporary numeric or character field, as appropriate.

2. Add a new date field with MODIFY STRUCTURE.

3. Use the REPLACE command in combination with a dBASE expression that will convert the numeric or character field to a date.

4. Remove the temporary field with MODIFY STRUCTURE.
