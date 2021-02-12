When Memos
Go Bad

CHARLES C. LYNCH

If you are having problems with dBASE IV memo files,what follows
may help you to first of all, determine the possible cause of
the corruption and secondly, recognize signs of corruption. Then
finally, we will offer a technique with which you may be able to
recover a majority of the data from your memo file if your
back-ups are corrupted, not up to date, or worse yet, non-
existent. The technique will be most useful in cases where the
corrupted file is isolated to a small group of records. No
miracles are promised here but, with a little luck, the steps
outlined will help you get your files back into a usable
condition.

Causes of Memo Corruption

Memo file corruption is most often caused by power failures,
turning off the machine while in dBASE IV and DOS environment
factors. dBASE IV 1.0 is known to corrupt memo files in a few
rare cases which are listed below.

Anomalies

The following dBASE IV Anomalies are also known to cause memo
corruption: In BROWSE mode only, if more than 512K bytes of data
are added to a memo field that already contains data, the memo
changes are saved and the BROWSE mode is exited by hitting
Escape, the memo field will become corrupted. This happens only
when the record pointer is not moved before escaping from BROWSE
mode. In some cases, the error message "Disk full" is
returned.

Do not let your computer idle in a memo edit screen. If you are
called away, save your data and return to the Control Center or
dot prompt. It is a good idea to close the file as well to avoid
the possibility of files being open (and possibly corrupted) if
a power failure should occur.

If you are working with a file and you encounter a power failure,
or you turn the machine off while dBASE IV is executing, it is
possible the files that were open at the time of the failure may
become corrupted. The first thing to do after restoring power to
the computer is to run a CHKDSK/F from the DOS prompt on the
drive(s) where dBASE IV and your data file reside. (You cannot
run a CHKDSK/F on a network drive, therefore network users should
ignore the references made to CHKDSK mentioned here and later in
the article. The best safeguards here would include providing
your machine with an uninterrupted power supply and to always
exit dBASE IV by entering QUIT at the dot prompt or choosing QUIT
to DOS from the Control Center Exit menu. dBASE IV will
properly close all files before exiting to DOS. DOS environment
factors that become issues when working with memos include hard
disk corruption and DOS memory allocation both of which are
reported by a CHKDSK/F. Hard disk corruption comes in the form
of lost clusters, bad allocation units and cross-linked files.

The /F switch fixes the disk corruption within DOS but does not
guarantee that your files are completely repaired for dBASE IV.
CHKDSK/F is the first step in your attempt at memo file
recovery.

Fragmentation of a hard disk, caused by excessive reads and
writes can cause the once contiguous groups of data to become
scattered about, causing more read write activity for the drive
heads and consequently, for margin for error.

dBASE IV 1.0 has a memory requirement of 516K which translates to
approximately 530,000 bytes free (the last number reported from
a CHKDSK diagnostic screen) before starting dBASE IV. If the
number of bytes free is lower than the minimum required for dBASE
IV, you should disable memory resident software (TSRs) loaded
in your AUTOEXEC.BAT or your CONFIG.SYS files when working with
dBASE IV memo files. Such TSRs include mouse drivers, disk
caching mechanisms, screen savers, menuing systems, network
shells, print spoolers, keyboard macro software, etc. Don't be
fooled by the size of a TSR and it's ability to conflict with
dBASE IV. A relatively small TSR, if positioned in an area of
memory which dBASE IV needs to use, can be like David with a
sling shot. If your problems with corruption seem to reoccur,
it may be necessary to reboot your computer using a configuration
that is free from all TSRs.

There also seems to be a high correlation between memo file
corruption and high DOS buffer settings. The buffer setting in
your CONFIG.SYS file should be set to 15 when running dBASE IV.
Settings higher than those recommended can open the door for
potential corruption with your dBASE IV especially in a network
environment where you'd deprive your workstation of precious
RAM that is already low due to the presence of the network shell.

What's so special about buffer settings anyway? A buffer is a
special cache area of memory used for reading and writing of
data. By default, each buffer is 512 bytes plus a few extra
bytes for overhead. When buffers are set too high, it takes
longer for these buffers to fill up and be written back to disk.
dBASE IV may determine that data has already been written and
updated before it actually has. When buffers are set too low,
the buffers fill up faster and therefore require more disk
access which slows down performance. Any type of cache will
generally improve performance but also decreases the assurance
that data has actually been written to disk in the event of a
computer lock up or power failure.

Telltale Signs

Now that you have an idea of what usually causes memo corruption
you need to be able to recognize a corrupted memo when you see
one, or when you can't see it whatever the case. If you have
certain memos that give you a "Disk full, delete old files Y/N?"
error when trying to edit or view the memo when, in fact, you
have plenty of available disk storage, you can be assured that
you have a corrupt memo attached to that record. If you encounter
the "Disk full" error, try to get out of the situation without
having to reboot the machine. In some cases of severe disk
corruption your only ticket out of the "Disk full" message is to
reboot the computer, certainly not the preferred way to end an
dBASE IV operation but when your left without a choice, you have
to bite the bullet and hope for the best.

Another sign of a corrupted memo is embedded control codes in the
file. If you view or edit a memo and you see happy faces, music
notes or any other peculiar looking characters, the memo is
corrupted.

While displaying the memo, the data may appear to loop and
redisplay.Usually, you can press Escape to break out of this
cycling effect.

Another obvious sign of memo corruption occurs when you try to
view or edit the memo and the computer hangs while the hard disk
works feverishly. In a sense, the corrupt memo is "vacuuming"
up free space on your hard drive which will eventually result in
a "Disk full" message. In any of the cases mentioned, if you
have to reboot the computer, be sure and run CHKDSK/F on the
drive(s) where dBASE IV and your data are stored before
continuing or you may end up compounding your problems.

On the Road to Recovery

Now that you know what possibly caused the corruption and how to
recognize corruption, you need to clean out any records that
have corrupted memos. To find out which records have corrupt
memos, go to the dot prompt and use the data base in question,
then list out the memo field. Follow the sequence of commands
below, substituting the actual name of the file name and memo
field for the markers in angle brackets.

. USE
. GO TOP
. DISPLAY

Once the display begins, have a pencil and paper ready so that
you can keep track of the record numbers that may have corrupt
memos. Look for memos that have signs of corruption:
unwarranted disk full errors, the presence of embedded control
characters, endless looping of any one memo, and system lock
ups. Take note of the record number for any such records. If
the machine locks up on you and you have to reboot again you
should run CHKDSK/F before retrying the recovery attempt. After
a lockup, avoid the record(s) that cause the system to hang. For
example if the DISPLAY command hangs or loops on record five,
skip record five when continuing the hunt for memos gone bad:

. SKIP
. DISPLAY REST

If you're lucky, you won't have to reboot your computer at all.
Now that you've got all the record numbers for records that
appear to have corrupt memos attached, you need to mark these
records for deletion either by editing the data base and pressing
Ctrl-U on the records with corrupt memos, or by typing the
record number from the dot prompt followed by the DELETE
command:

. 2500 &&Go to record 2500.
. DELETE && Delete this record.

Once you get all the records with corrupt memos marked for
deletion, you need to copy all records that are NOT marked for
deletion to a new file, leaving the corrupt memos behind. Do
not PACK a data base that has memo fields as the memo file still
retains all the memos for the deleted records internally. You
can't get the bad records out of a file and make it good again.

You have to pack up all your good records and move and then
"nuke" the old file. Use the COPY TO command to secure the
records in a new file, delete the original .DBF and .DBT and
rename the new file .DBF and .DBT back to the original name.

. SET DELETED ON
. COPY TO NewFile1 && Copy the records not marked for deletion.
. SET DELETED OFF

Now close all data bases and erase the corrupted .DBT file for
the original data base leaving the original .DBF file intact.

. CLOSE ALL
. ERASE OrigFile.DBT && Erase the corrupted memo file.

When you go to use the original file again you will receive a
message "Memo file not found, OK to create an empty one?
Yes/No". Answer by typing Y and a new empty memo file for the
original database will be created.

. USE && Answer YES to create a new empty memo file

At this point, copy records that are marked for deletion to a
second new file, ZAP the original data base file and append your
data from the NewFile1 and NewFile2 data bases. If your data
base has indexes you will have to recreate your indexes. The
records in NewFile2 will have to have the memo fields re-entered
but data from fields other than memos is preserved.

. COPY TO NewFile2 FOR DELETED() && Recs marked w/ empty memos
. ZAP && Erase all records in the original data base
. APPEND FROM NewFile1 && Copied recs w/good memos
. APPEND FROM NewFile2 && Copied recs which had corrupted memos
. ERASE NewFile1.DBF && Clean up work files
. ERASE NewFile1.DBT && Data is recovered in OrigFile.dbf
. ERASE NewFile2.DBF && and OrigFile.DBT
. ERASE NewFile2.DBT

Home Free

Now, hopefully, your data is nearly recovered and you can
continue working with your data base or better yet, go out and
enjoy life. Don't forget, you will have to re-enter memo
information for the records that previously contained corrupt
memo data. Remember to keep reliable and current backups. To
neglect to do so could be as much of a nightmare as being hit
while driving without insurance or being audited by the IRS
or..well, you get the idea.

If you have continuing problems with memo files you should
contact the Ashton-Tate Software Support line and speak to a
Support Technician to help determine the possible cause and
solution to your continuing corruption problems. If you have a
modem, you can dial up the Ashton-Tate BBS, now toll free in most
areas. See the masthead information on the back page of this
magazine for phone numbers and available hours of these services.
