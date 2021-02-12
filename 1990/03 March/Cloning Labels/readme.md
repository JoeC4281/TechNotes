Cloning Your Labels
Variations on a Theme
A Suite in Two Parts for Printer and Label

FARIVAR ROSHANIAN

When it comes to printing labels, a common need that leaves some
users in a quandary, is the ability to print multiple copies of
the data in one particular record. The task is quite simple;
when you print on one-across labels, all you have to do is:

1. Create a query that would select the one record you want,
2. Create the label the way you normally would, and
3. From the Print menu, set the number of copies to the desired value.

You can create a query design to select one particular record by
adding a condition box with the expression

RECNO()= x

where x is the desired record number.

Variation One

However, if you try to repeat this procedure with labels that are
two or three across, only the first label column will be used.
To explain the reason behind this, you have to understand how
multiple copy printing is handled in dBASE IV.

Basically, the data is printed once to a spool file as if only
one copy is desired. That spool file is then printed the number
of times indicated by the Print: Output options: Number of
copies. Now, if you think about it, since you are printing only
one record there is only enough data to fill the first column
of the label on the spool file. Of course, no matter how many
times the spool file is printed, only the first column of labels
would be printed.

Now that we understand the limitation and the subsequent problems
which arise, we can devise a method to get around it. Follow
the steps listed below to print labels that have multiple
columns.

1. Create a query that would select that one record you want.
2. Create a label with the following dimensions as shown in Table 1.
3. Lay out the label on the left hand side of the screen.
4. Press F6 Select, then use arrow keys to highlight the
area that contains the label on the layout. Press
Return to confirm selection.
5. Move the cursor to the column that corresponds to the
starting position of the next column of labels on the
printed page. For example, if the label width is 26,
then the starting position of the second column of
labels would be 27.
6. Press F8 Copy to duplicate the selected area to the position pointed by the cursor.
7. Repeat steps five and six until the number of labels on
the screen matches the number of labels on the label
sheet.
8. From the Print menu, set the number of copies equal to
the number of labels per sheet divided by the number of
columns of labels.
9. Select Begin from the Print menu to commence printing.
===========================================

Width of label The width of the page, (normally 80)

Height of label Max. number of lines of the label

Indentation 0

Lines between labels Usually 0 or 1

Spaces between labels 0

Column of labels 1*

* Yes, this is correct. To dBASE IV, it will be one long column of labels, although your label information will be
repeated successive times.

========================= Table 1 ==============================

The Second Variation

Another variation on this concept is the case when you want to
print labels where the data is not taken from a database but
rather, typed directly onto the layout. For example, you may
want to print 100 labels containing your own name and address.
Here are the steps to follow to accomplish the task:

1. Create a label with the dimensions specified in step #2 of the previous example.
2. Type the text for each line of the label just as you want it to appear in printed form.
3. Press F6 Select to highlight the area that contains the
text just typed. Press Return to confirm selection.
4. Move the cursor to the column that corresponds to the
starting position of the next column of labels on the
label sheet. For example, if the label width is 25, (2.5
inches wide), then the starting position of the second
column of labels would be 26.
5. Press F8 Copy to duplicate the labels across the layout
screen to match the label sheet you are using.
6. From the Print menu, set the options as in Table 2.
7. Select Begin from the Print menu to commence printing .

Control of printer: New page NONE

Control of printer: Advance page using LINE FEEDS

Output options: Begin on page 1

Output options: End after page 1

Output options: Number of copies # of copies

Page dimensions: Length of page Height of label + lines between labels

======================= Table 2 ========================

Remember that the number of copies is not the number of actual
labels but rather the number of rows of labels.

By default, your printer will output characters at 10 characters
per inch. Adjust accordingly for compressed or elite settings
by taking the width of the label and multiplying by the number of
characters per inch you have set. Elite is equal to 12,
compressed is 17.1 (most dot matrix) or 16.66 (most laser/page
printers). Consult your manual to be sure.

A database must be in use to create a label. You can use any
.DBF file you wish since the text being inserted is not
intrinsic to any particular data base.

Right now, you're probably thinking how simple this was. Well,
you're right. It often happens with a program as multi-faceted
as dBASE IV that we can sometimes complicate an otherwise, easy
solution.


