# Work Surface Shortcuts

MITRA TOOSSI

It seems like there's so much to keep account of these days.
The more hectic life becomes, the uphill battle of simply
managing our time and affairs seems like a dream that is
continually unfulfilled. Were it not for the wonders of the
personal computer and database management software, the endless
drudgery of keeping track of a simple mailing list with all the
adding, deleting, updating, sorting, printing and locating tasks
associated with it would still be a vivid reality . Piles of
index cards, manilla folders and drawers filled with sharpened
pencils, erasers and white-out that were the tools of the trade
have been replaced by video screen, keyboard and mouse.

Even with the advent of technological advances to make our lives
easier, there were still a mass of folks out there who weren't
too crazy about learning how to program that which could still
be more quickly typed or written out. Some tasks eventually
became less painful as automated label and report generating
came into play. But anything less than the simplest report or
query sent you back to manuals, learning how to build a program.

In dBASE IV, you can more easily move from one work surface to
another without exiting the current work surface you are working
on. This is one of the best features of dBASE IV that's not
been touted enough: the power to spring from one work surface to
other in the WYSIWYG environment with only one keystroke and
then back again. The power is in the use of Shift-F2.

##### What is a Work Surface?

The menu system of dBASE IV consists of the Control Center and
screens you can reach either from the Control Center or dot
prompt. When you need to add, edit, display and manage your
data, a different work surface is used to carry out the task you
want. All work surfaces share a basic approach to navigation
and editing. Even though the approach might be slightly
different form one to another, you can easily design and work
with each one of them to create labels, reports, queries, and
screen forms.

##### How to Use Work Surfaces

To accomplish any part of a database task, you need to either
display certain records or use a particular design to determine
the way data should appear. F2 Data and Shift-F2 are the two
navigational keys that tie all the above fuctions together. With
these two keys you can easily switch between any of these tasks.

Suppose you have a database file consisting of names and
addresses of your friends and family members to whom you wish to
send a birthday card. You are in the Reports design work
surface and have arranged the way you'd like your data to be
displayed. While you are designing your report, you decide that
you only wish to recall all the people who were born past a
certain time period. All you need do is press Shift-F2. This
will take you to the query design without having to exit the
report screen.

In the query design screen, define the condition you are
interested in. For example, in order to set a filter for the
people whose birthday is past January 1, 1960, go to the birth
date field in the file skeleton and beneath the field name type
">{01/01/60}". In order to see if there are any matches to this
condition, press F2 to view the selected records.

After you are done viewing the data, pressing Shift-F2 (not
Escape) will take you back to the Query design screen. Pressing
Shift-F2 one more time, will take you back to the Report design
screen. At this point, you have done two things without even
having to exit the Report design screen. You created a
condition so that the report you created can accurately reflect
the condition that you had in mind. In order to make sure that
there are records matching the interested condition, pressing F2
allowed display of data in Browse/Edit format. This is the
power of Shift-F2.

The availability of this "quick key" allows you to make queries
"on the fly" that are possibly only needed one time and do not
require being saved to disk, thereby cluttering up your disk
directory and your dBASE IV catalog.

The following chart illustrates where you can go from one screen
design to another with either F2 or Shift-F2 (illustrated on the
opposite page).

|          |                                          |
|----------|------------------------------------------|
| F2       | From Data, Query, Form, Report, or Label panel displays Browse/Edit screen. |
| Shift-F2 | Takes you to one of the design screens (Modify/Create structure, Forms, Queries, Reports, Labels, or Applications.) |
| Shift-F2 | From Report, Label, or Form design screens, takes you to Query design screen. Shift-F2 again takes you back to the design screen from which the process originated. |
