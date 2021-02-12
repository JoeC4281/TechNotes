# Linking with EVERY

Joe Stolz

It's not uncommon to need to link two files together. It's also not uncommon to have data in those files related one-to-many; with one record in one file matching and relating to several in the second file. In fact, one of the added features of relating files in dBASE IV is this very ability to show a one-to-many relationship. By default, this is the manner in which a query will display data.

An example of a one-to-many relation is the organization of students in high school to their classes. Each student has perhaps six classes per day. For class registration purposes, there need be only two data files involved, one containing each student and his personal data, and the other containing six records per child, one for each class period that the student attends.

In reality, there is, often, data in both files that has no match in the other file. In the above example, there are students that have not been assigned to classes yet. Further, there are free slots (i.e. empty chairs) in some classes that have not yet been assigned to a student.

When you use QBE in dBASE IV to create a query showing all related records between these two files, you will see only those students that have classes, and conversely, only those classes that have been assigned to the student names being displayed. This is the default methodology used by QBE when displaying data related between two files.

What if you want to see all records in one of the files, regardless of whether or not there are matches in the other file? QBE provides a means of doing this with the keyword EVERY. The EVERY option will show you every record in the file under which it is placed, regardless of whether there is match for it. An example will show this clearly. Imagine two files, one containing names and the other containing class codes and the name of the student assigned to the class. The data in both files is as in Figure 1.

| In Names.DBF   | in Classes.DBF          |
|----------------|-------------------------|
| John Furkes    | A3A Burroughs           |
| Mark Burroughs | A1A Song                |
| Sam Song       | B2B (unassigned)        |
| Fido Rover     | B3B Song<br>A3B Burroughs |

*Figure 1  The data in Names and Classes before linking*

When performing a simple link operation in dBASE IV, you place a linking variable (e.g. the word LINK) underneath the field in common between the two file skeletons that are to be linked on the query design surface. After pressing F2 to display the data, you will see what is shown in Figure 2.

| In Names.DBF   | in Classes.DBF |
|----------------|----------------|
| Mark Burroughs | A3A Burroughs  |
| Mark Burroughs | A3B Burroughs  |
| Sam Song       | A1A Song       |
| Sam Song       | B3B Song       |

*Figure 2  Names and Classes after linking*

As we can see, John Furkes and Fido Rover are left out of the resultant table. Further, class slot A3A, not yet assigned to a name, has also been left out of the picture. The mechanics of how dBASE IV does this are not too complicated. First let's examine the basic assumption that dBASE IV makes. When you are linking two files, you are going to want to see each record in the parent (the "one" file) and all of the records that match it
in the child (the "many" file). If a record has no match, either from parent to child or from child to parent, it is excluded. To understand how dBASE IV does this, we should examine the file that is created from the query process, the .QBE file. In that file we will find the statement, SET FILTER TO FOUND(2). This sets up a filter that excludes records that do not match a record in the child file. On record #1 of the Names file (John Furkes) the filter is evaluated. dBASE IV tests the Classes file to see if there is a record associated with John Furkes. If there isn't one, FOUND(2) returns FALSE. In our example, since the filter is being tested from the first file, Names, John Furkes is excluded from the resultant data table. A child record without a parent record is excluded because only parent records with valid matches are allowed to be shown with this filter expression. Consequently, both non-matching parent and child records are excluded in this query.

Accordingly, dBASE IV offers a way to include records into a view, even though they lack a match in a related file. You do this by adding the EVERY operator to the linking variable under the file skeleton from which you want to display every record regardless of whether it matches another or not. Figure 3 shows what happens if we place EVERY LINK under the Names.DBF file skeleton.

| In Names.DBF   | in Classes.DBF |
|----------------|----------------|
| John Furkes    |                |
| Fido Rover     |                |
| Mark Burroughs | A3B  Burroughs |
| Mark Burroughs | A3B  Burroughs |
| Sam Song       | A1A  Song      |
| Sam Song       | B3B  Song      |

*Figure 3  After EVERY LINK is placed under the Names skeleton*

We see that all of the names have been copied to the resultant table, but that not all the classes are shown. The class that is un-assigned has still been left out of the table.

The .QBE file that results from this scenario is very similar to the one that resulted from the first example. You may have guessed that the only difference between these two is that the second query is lacking the SET FILTER TO FOUND(2) statement. This means that each record in the parent file (Names.DBF) will have a match in the second file, or will be matched with the "End of file" record. By definition, a record that has no match in a
related file will cause the second file to point to the end of file, where the dBASE IV functions EOF() = .T. and FOUND() = .F. simultaneously. "Data" derived from this end of file record is blank.

In the other possible case, we can place EVERY LINK below the last name field in Classes.DBF. This shows us every class, whether assigned to a student, or not. It does not show us all students, but rather, only the students that are assigned to classes. The output in Figure 4 shows all five classes, but not all four students' names.

| In Names.DBF   | in Classes.DBF     |
|----------------|--------------------|
| Mark Burroughs | A3A                |
| Mark Burroughs | A3B Burroughs      |
| Sam Song       | A1A Burroughs      |
| Sam Song       | B3B Song<br>A3A Song |

*Figure 4  EVERY LINK has been placed below the last name field in Classes.*

In summary, the EVERY clause placed under a file skeleton in a linked relation causes every record in the "every" file to be displayed, regardless of whether it has a match. However, not every record from both files will be displayed, only records in the file with the EVERY operator. In an interesting twist, it also causes the "every" file to become the "parent" file in the relation.

Given our description of how dBASE IV works, the last point is a subtle one, and bears further explanation. The method that dBASE IV uses to determine a match is with the command SET FILTER TO FOUND(n), where n is the work area (file) being tested, and that work area is the one containing the child file, the one to which the relation is set or is pointing. Again, sitting on record #1 of the parent file (the one that points to a record in the child file) if a match is found in the second file, the filter condition is true and the record is included. If no match is found in the second file, FOUND(n) is false, and the record in the parent file is excluded from the results. The test of the filter condition is performed for each record in the parent file. There is no way to perform a test of each record in the child file since the SET RELATION command only points to records that match records in the parent file. The only way that dBASE IV can test an EVERY condition is to make the "every" database the master (parent) file. I call this a twist since the relation
is now set "backwards" from the way it was set in the first two examples. The relationship is now many-to-one instead of the usual one-to-many, a fact that is transparent to the user unless the contents of the .QBE file are inspected.

##### Three Files Linked Using EVERY

Now that we understand what is going on in a query that contains an EVERY clause, let's try to expand on this concept. It's very likely you will find occasion to have three related databases. In this discussion, the related databases will be connected in a
chain rather than a tree fashion. A chain relation is File A relating to one or many records in File B, and each record in File B relates to one or many File C records. A tree relation is File A relating to both B and C from the same A record.

It's logical to assume that if we have three files related from A to B to C, we may then desire to see all records from all three files in a view, regardless of whether some of these records are related to others. Again, as in the two file relation, dBASE IV will automatically perform a limited linked query unless the EVERY operator is used. We previously observed that the EVERY operator gave us every record from the file under which the key phrase EVERY was placed. Now that we have three file skeletons in our view, how will dBASE IV handle our use of the EVERY operator? We should know from experience that we cannot place an EVERY operator under both files in a two file relation. This is not allowed and will generate an error. In a three file relation we can only use EVERY twice; one for each of the two linking example variables. What will happen? Before we describe the results, let's speculate as to the possible results of two EVERY phrases. On the one hand, we should see all records contained in both of the "EVERY" files in our resultant data table. dBASE IV should interpret the EVERY phrase as a directive to eliminate the SET FILTER TO FOUND(n) in both related work areas. But there is the second consequence of EVERY to consider. The EVERY file is set up as the master database in the relation. It is impossible to have two files competing to be the master file. In actuality, one is master, the second is next in the chain, and the file without an EVERY operator is last in the chain.

Another possible explanation for the consequences of a query using two EVERY borrows from a concept that SQL uses frequently; that is, the concept of a subquery. A subquery comes about as a combination of two queries. Imagine a query that returns all records for customers residing in California. This is a subset of the nationwide database of customers. Now, we want to find all customers who made purchases in the past three months, and also lived in California. We could make a single complicated query, or take the resultant data from the first query and apply the second query to the resultant data subset instead. This
concept of querying the results of a second query is used in SQL. What does this mean? In our examination of queries containing three files and two EVERY operators, a dBASE IV program could actually perform the query as a one shot thing, combining all data from two of the three files. The QBE capabilities cannot possess all of the human intuitiveness or predictability that could be hard-coded into a program. Thus, QBE will treat the process stepwise, as two separate queries; the relation from A to B and the relation of the resultant data to C.

Let's look at some examples now. We'll use the same two databases from before, but a third file has been added. To make life simple, the new file is related one-to-one to the second file. Still, the third file ClassTtl.DBF (containing class titles, instructor names, etc.) has a match to an unused class in Classes.DBF (B2B), a class slot that is not currently assigned this semester.

All three files are shown in Figure 5.

In Names.DBF in Classes.DBF In Classttl.DBF

John Furke A3A Burroughs Astronomy Gordon
Mark Burroughs A1A Song Sociology Jones
Sam Song B2B French Smith
Fido Rover B3B Song Biology Bandini
A3B Burroughs Chemistry Burfle


The first case to examine is that with the simplest link, where we link student names to their classes. This is the A file to B file link. Next we place a second link variable in the Classes database and link to the ClassTtl file. This is the B to C link. Without an EVERY operator in place, the results are as shown in Figure 6.

The results look identical to those returned from the simple A to B file link described previously. Except that the teacher's name and the class description is included. This shows that dBASE IV first links the student name to the Classes file, then links the resultant data to the Classttl file. Looking into the QBE file produced, we see two FOUND()
statements: SET FILTER TO FOUND(2) .AND. FOUND(3). This means that, by default, dBASE IV wants to show records from Names only when they have matches in both the related files.

The next case is where there is a single EVERY clause placed in the child file Classes, next to and in addition to the linking variable that links Names to Classes. This removes the FOUND(2) in the Classes file, but maintains the one relating to the third file,
ClassTtl. The resultant data is nonetheless identical to that displayed in Figure 6 because the four classes shown are still related just as they were, even with the EVERY clause left out. Further, the EVERY clause, even though it could cause additional records to be displayed from the Names file, still doesn't override the FOUND(3) which requires that the records to be displayed are also related to records in the third file. In fact, this requirement effectively removes those records that should have been added back to the Classes file when the EVERY operator was added! Since the data files in this example are
related one-to-one from B to C, there really is one class title record that should have been displayed due to the use of the EVERY operator. However, since the A file (Names) must relate to the C file (ClassTtl) within the constraints of the filter:
FOUND(3), that additional record is still suppressed.

FNM LNM CLASS CODE DESCRIPTION TEACHER
Sam Song B3B Biology Bandini
Sam Song A1A Sociology Jones
Mark Burroughs A3A Astronomy Gordon
Mark Burroughs A3B Chemistry Burfle

To gain that additional record from files B and C, we must place
two EVERY operators in our view, one in the B file (Classes) and
one in the C file (ClassTtl). This gives us the data as expected
and shown in Figure 7.

FNM LNM CLASS CODE DESCRIPTION TEACHER
Sam Song A1A Sociology Jones
Mark Burroughs A3B Chemistry Burfle
Sam Song B3B Biology Bandini
Mark Burroughs A3A Astronomy Gordon
French Smith

Further, looking into the .QBE file, we see that the ClassTtl file is now the master database. In other words, in our A-B-C scheme, the relation set above is C to B to A. Interestingly, in the case of a single EVERY operator, the relation was still A to
B to C.

A third and final case to discuss also involves two EVERY operators. In this case I placed both EVERY operators in the intermediate file -- Classes. Since this file contains two
linking variables, each relating to another file, it seems like a reasonable possibility in setting up a multiple "EVERY" type of relation to display all records.

The results of this relation look identical to those produced by the other case that contains two EVERY operators. However, the crucial new factor that sets this type of procedure apart is that the files are set up in a tree relation. dBASE IV determines that the file containing the
two EVERY operators is the master, so it must relate both to A and to C. The way the data is set up, we see no difference, but you should be aware of the diversity of choices that dBASE IV makes when you set relations by using link operators in QBE.

To summarize, what you see when you perform these types of relations is NOT simply dBASE IV combining all records from each file that has an EVERY operator below it. That type of result is basically true only when two files are concerned. With three files, dBASE IV employs a more SQL-like approach. If A relates to B which relates to C, and if a record in A relates to one in B but that record in B doesn't relate to one in C, an EVERY cannot
force the C data to be displayed. In other words, only one file of the three can be the master. Consequently, whereas the master file can be made to display all its records, regardless of related child records (i.e. dBASE IV will at least display a blank record as an "unmatched" child record to every parent record), the middle or intermediary file cannot also be master. Records in the middle file that do not relate to the master file will NOT be displayed, regardless of the placement of an EVERY operator. It's as if the data from the relation of A to B is the basis of the set of data that can be applied to the third file C. This fact, specifically, the manner in which the dBASE IV QBE goes about linking files, overrides the way we may want it to work. There may not be a way to get ALL records from ALL files to show up in a QBE query, regardless of how many EVERY operators
are thrown in. It doesn't mean that dBASE IV is not functioning correctly, just that the combination of multiple files makes for less obviously predictable results.

I recommend that you try to build experimental queries for your files. Then take a good long look at the .QBE file that results from the query. This should help you to understand what type of data you will get when you create a query. You may find that the decisions made by QBE are very logical and predictable, as I showed in the queries above. You can also learn to create programs that perform the same as .QBE file. In which case you will be free to create whatever results you need for whatever the circumstances.

##### Simplest Link (Every operator not used)

```dos
SET FIELDS TO
SELECT 1
USE Name AGAIN NOUPDATE
USE Classes AGAIN NOUPDATE IN 2 ORDER LNm
SET EXACT ON
SET FILTER TO FOUND(2)
SET RELATION TO A->LNm INTO B
SET SKIP TO B
GO TOP
SET FIELDS TO A->FNm,A->LNm,LNm2=B->LNm,A->Date_Regis,B->Class_Code,B->Occupied
```

##### EVERY used in the Names file

```dos
SET FIELDS TO
SELECT 1
USE Name AGAIN NOUPDATE
USE Classes AGAIN NOUPDATE IN 2 ORDER LNm
SET EXACT ON
SET FILTER TO
SET RELATION TO A->LNm INTO B
SET SKIP TO B
GO TOP
SET FIELDS TO A->FNm,A->LNm,LNm2=B->LNm,A->Date_Regis,B->Class_Code,B->Occupied
```


##### EVERY used in Classes file.

```dos
SET FIELDS TO
SELECT 2
SELECT 1
USE Name AGAIN
QBE___ct = 1
DO WHILE LEN(TAG(QBE_ct)) <> 0
IF TAG(QBE___ct) = "LNM"
EXIT
ELSE
QBE___ct = QBE___ct + 1
ENDIF
ENDDO

IF LEN(TAG(QBE___ct)) <> 0
SET ORDER TO TAG LNm
ELSE
INDEX ON LNm TAG LNm
ENDIF

RELEASE QBE___ct
SELECT 2
USE Classes AGAIN NOUPDATE
USE Name AGAIN NOUPDATE IN 1 ORDER LNm
SET EXACT ON
SET FILTER TO
SET RELATION TO B->LNm INTO A
SET SKIP TO A
GO TOP
SET FIELDS TO A->FNm,A->LNm,LNm2=B->LNm,A->Date_Regis,B->Class_Code,B->Occupied
```


