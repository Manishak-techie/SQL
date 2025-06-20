create database sample2
Alter database sample2 modify name=Sample3

/*using Stored Procedures*/
sp_renamedb 'Sample3','Sample4'

/*Drop a DB OR Delete a Database*/
Drop database Sample4  /* database will be deleted and .ldf and .mdf files are also deleted*/
/*when deleting the database that database should not be in use*/

/*CREATING AND WORKING WITH TABLES*/
/*created dbo.tblperson manually using right click near the tables*/

/*now writing query for gender - A table can have only one primary key*/
create table tblGender
(
ID int NOT NULL Primary Key,
Gender nvarchar(50) NOT NULL
)

/*if table created in different database delete that or check the database before executing
or Use [Sample] Go --> Database Name*/

alter table tblperson add constraint tblperson_GenderID_FK
Foreign Key (GenderID) references tblGender(ID)

UPDATE tblPerson
SET GenderID = 3
WHERE id = 6;
/*The UPDATE statement conflicted with the FOREIGN KEY constraint "tblperson_GenderID_FK". The conflict occurred in database "Sample", table "dbo.tblGender", column 'ID'.*/
INSERT INTO dbo.tblGender (ID, Gender)
VALUES (3, 'Other');

-- Now that Gender ID 3 exists, update person with ID = 6
UPDATE dbo.tblPerson
SET GenderID = 3
WHERE ID = 6;

SELECT * FROM dbo.tblPerson
WHERE ID = 6;

/*ADDING A DEFAULT CONSTRAINT*/

SELECT * FROM tblGender;
SELECT * FROM tblperson

insert into tblPerson (ID, Name, Email) values (7, 'Rich', 'r@r.com')

UPDATE dbo.tblGender
SET Gender = 'Unknown'
WHERE ID = 3;

--Default constraint
ALTER TABLE tblperson
ADD CONSTRAINT DF_TBLPERSON_GenderID
default 3 for GenderID

insert into tblPerson (ID, Name, Email) values (8, 'Mike', 'mike@r.com') --default constraint is inserted in genderID

insert into tblPerson (ID, Name, Email, GenderID) values (9, 'Sara', 's@r.com',1) --giving the genderID value to sara

insert into tblPerson (ID, Name, Email, GenderID) values (10, 'Johnny', 'j@r.com',NULL) 
--providing genderID value as NULL so while executing it will be NULL
--because passing the value in the insert query

ALTER TABLE tblperson --dropped the constraint
drop constraint DF_TBLPERSON_GenderID

ALTER TABLE tblperson --restored the constraint
ADD CONSTRAINT DF_TBLPERSON_GenderID
DEFAULT 1 FOR GenderID;

--PART 5--CASCADING REFERENTIAL INTEGRITY CONSTRAINT
--PART 3--CREATING TABLES AND ADDING PRIMARY AND FOREIGN KEY CONSTRAINT
--PART 4--ADDING A DEFAULT CONSTRAINT

SELECT * FROM tblGender;
SELECT * FROM tblperson

DELETE FROM tblPerson WHERE ID = 2;
insert into tblPerson (ID, Name, Email, GenderID) values (2, 'Mary', 'm@m.com', NULL)
--NO ACTION 
--before executing we will go to tblperson-keys-tblperson_genderid_FK-insert or update specification delete rule=default
delete from tblGender where id=2

--SET NULL.
--before executing we will go to tblperson-keys-tblperson_genderid_FK-insert or update specification delete rule=Set Null
delete from tblGender where id=1

--cascade
--before executing we will go to tblperson-keys-tblperson_genderid_FK-insert or update specification delete rule=Cascade
delete from tblGender where id=3

--PART 6- ADDING A CHECK CONSTRAINT

ALTER TABLE dbo.tblPerson
ADD Age INT;
insert into dbo.tblPerson values(11, 'sara', 's@s.com',2,-970)

INSERT INTO dbo.tblGender (ID, Gender) VALUES (1, 'Male');
INSERT INTO dbo.tblGender (ID, Gender) VALUES (2, 'Female');
INSERT INTO dbo.tblGender (ID, Gender) VALUES (3, 'Unknown');

delete from tblPerson where ID=11
SELECT * FROM tblGender;
SELECT * FROM tblperson
insert into dbo.tblPerson values(11, 'sara', 's@s.com',2,10)
insert into dbo.tblPerson values(13, 'Jane', 'a@a.com',1,20)
insert into dbo.tblPerson values(12, 'sara', 's@s.com',2,NULL)
--by clicking on new constraint in expression added Age>0 AND Age<150
--here age is a null able column. if i pass null what happens to the boolean expression
--if you remember boolean expression should be greater than 0 and less than 150. now 
--NULL GREATER THAN zero or less than 150 this is unknown value this boolean expression results unknown result
--in which case the constraint passes and null to be inserted

--DROP A CONSTRAINT(GRAPHICALLY /QUERY)
alter table dblperson
drop constraint ck_tblperson_Age

--Add a Constraint
alter table tblperson
add constraint ck_tblperson_Age Check (Age>0 AND Age<150)

--example: insert into dbo.tblPerson values(12, 'sara', 's@s.com',2,950)
--error: Violation of PRIMARY KEY constraint 'PK_tblPerson'. Cannot insert duplicate key in object 'dbo.tblPerson'. The duplicate key value is (12).

--IDENTIFY COLUMN IN SQL SERVER
SELECT * FROM tblGender;
SELECT * FROM tblperson

insert into dbo.tblPerson values(14, 'Todd', 't@t.com',1,25)
select * from tblperson1
insert into dbo.tblPerson1 values('John')
insert into dbo.tblPerson1 values('Tom')
insert into dbo.tblPerson1 values('Sara')

delete tblperson1 where personID=1

insert into dbo.tblPerson1 values('Todd')

insert into dbo.tblPerson1 values(1,'Jane')
--Error An explicit value for the identity column in table 'dbo.tblPerson1' can only be specified when a column list is used and IDENTITY_INSERT is ON.

--to turn identity insert ON will use set command
SET IDENTITY_INSERT tblperson1 ON

select * from tblperson1

insert into dbo.tblPerson1 (PersonId, Name) values(1,'Jane')

insert into dbo.tblPerson1 values('Martin')
--Explicit value must be specified for identity column in table 'tblperson1' either when IDENTITY_INSERT is set to ON
--or when a replication user is inserting into a NOT FOR REPLICATION identity column.
--If you dont want too supply the value explicitly then IDENTITY INSERT turn OFF
SET IDENTITY_INSERT tblperson1 OFF

--IF i delete all the rows from table and i want to reset identity insert
delete from dbo.tblPerson1
--in this case the output is personid=7 and name=martin it is not resetting to 1
--Here use dbcc commands dabase consistency check commands

DBCC CHECKIDENT(tblPerson1, RESEED, 0)
--By executing this query personid resets to 1

--PART 8: RETRIEVING LAST GENERATED IDENTITY COLUMN VALUE IN SQL SERVER
--DIFF BTWN SCOPE_IDENTITY(), @@IDENTITY AND ident_current('tablename')

create table test1
(
ID int identity(1,1),
Value nvarchar(20)
)

create table test2
(
ID int identity(1,1),
Value nvarchar(20)
)
--USER1

insert into test1 values('X')

select * from test1
-- lets say the last generated identity column should be retrieved to do that use
--scope identity function
select SCOPE_IDENTITY()

select @@IDENTITY --retrieve the last generated identity column value

--you can create a trigger on a table for a specific action
insert into test1 values('X')
--when i insert a row into this table i want some process to be done automatically 
--using triggers
create trigger trforinsert on Test1 for Insert
as
Begin
insert into test2 values('YYYY') --TRIGGER defination would be begin and end tables
End

select * from test1
select * from test2

insert into test1 values('X')
select SCOPE_IDENTITY()
select @@IDENTITY
--scope_identity and @@identity returns last generated values
--------------------------------------------------------------------

--IDENT_CURRENT

insert into test2 values('zzz')
select IDENT_CURRENT('Test2')  --operates accross any session
select SCOPE_IDENTITY()
select @@IDENTITY

-------------------------------------------------------------------------------------------------------------------------------------------
--PART 9 UNIQUE KEY CONSTRAINT
ALTER TABLE tblPerson
Add Constraint UQ_tblPerson_Email Unique(Email)

--Double-check duplicates again from here  i have duplicates to remove all those i worked on this because
--executing alter table getting erro as The CREATE UNIQUE INDEX statement terminated because a duplicate key was found for the object name 
--'dbo.tblPerson' and the index name 'UQ_tblPerson_Email'. The duplicate key value is (s@s.com). 
--Could not create constraint or index. See previous errors.
--If this returns no rows, no duplicates exist and the UNIQUE constraint should work — but if duplicates show up, note them.
SELECT Email, COUNT(*) AS Count
FROM dbo.tblPerson
GROUP BY Email
HAVING COUNT(*) > 1;

select * from tblPerson

--Look for hidden duplicates (case sensitivity / trailing spaces)
--Run this to find possible "hidden" duplicates ignoring case and spaces:
SELECT LOWER(LTRIM(RTRIM(Email))) AS CleanEmail, COUNT(*) AS Count
FROM dbo.tblPerson
GROUP BY LOWER(LTRIM(RTRIM(Email)))
HAVING COUNT(*) > 1;

--Check for NULL emails: 
--If your Email column allows NULLs, and multiple rows have NULL, those won’t violate UNIQUE constraints normally, but it’s good to verify:
SELECT COUNT(*) FROM dbo.tblPerson WHERE Email IS NULL;

--Normalize Emails: Update emails to remove trailing spaces and normalize case before adding constraint:
WITH CTE AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY LOWER(LTRIM(RTRIM(Email))) ORDER BY ID) AS rn
  FROM dbo.tblPerson
)
DELETE FROM CTE WHERE rn > 1;

ALTER TABLE dbo.tblPerson
ADD CONSTRAINT UQ_tblPerson_Email UNIQUE (Email);
--------------------------------------------------------------------------------------------------------------------------------------------

select * from tblPerson
DELETE FROM dbo.tblPerson; --to delete the duplicate rows
INSERT INTO tblPerson Values(1, 'ABC', 'a@a.com', 1, 20)
INSERT INTO tblPerson Values(2, 'XYZ', 'a@a.com', 1, 20)
Alter table tblPerson
DROP CONSTRAINT UQ_tblPerson_Email
--------------------------------------------------------------------------------------------------
--PART 10 SELECT STATEMENT IN SQL SERVER
--SELECT SPECIFIC COLUMNS OR ALL COULMNS
--DISTINCT ROWS
--FILTERING WITH WHERE CLAUSE
--WILD CARDS IN SQL SERVER
--JOINING MULTIPLE CONDITIONS USING AND and OR operators
--sorting rows using order by
--selecting top n or top n in percentage of rows

select * from tblPerson
ALTER TABLE dbo.tblPerson
ADD City VARCHAR(100);

insert into tblPerson (ID, Name, Email, GenderID, Age, City) values (1, 'Tom', 't@t.com',1,23,'London')
insert into tblPerson (ID, Name, Email, GenderID, Age, City) values (2, 'John', 'j@j.com',1,20,'Newyork')
insert into tblPerson (ID, Name, Email, GenderID, Age, City) values (3, 'Mary', 'mary mary.com',2,21,'Sydney')
insert into tblPerson (ID, Name, Email, GenderID, Age, City) values (4, 'Josh', 'josh@dell.com',1,29,'London')
insert into tblPerson (ID, Name, Email, GenderID, Age, City) values (5, 'Sara', 'sara@abc.com',2,25,'Mumbai')

DELETE FROM dbo.tblPerson;

--another way of selecting all the right click on the table tblperson--SCRIPT TABLE AS--INSERT--NEW EDITOR QUERY WINDOW
SELECT [ID]
      ,[Name]
      ,[Email]
      ,[GenderID]
      ,[Age]
      ,[City]
  FROM [Sample].[dbo].[tblPerson]

GO
--YOU WILL GET LIKE THIS IN DIFFERENT QUERY WINDOW
--SAMPLE-NAME OF DATABASE, DBO--SCHEMA, TBLPERSON--TABLE

select * from tblPerson

select distinct city from tblPerson

--distinct city, name of the person
select distinct name, city from tblPerson
--in the result city London is repeated it is not giving me distinct city
--when you are saying distinct keyword in multiple columns you are actually telling SQL server the value should be 
--distinct across these two columns 
--when you use distinct keyword more than one column you are specifying its enough for the values to be distinct across all those columns

--FILTERING VALUES WITH THE WHERE CLAUSE
SELECT * FROM TBLPERSON
SELECT * FROM tblPerson WHERE CITY='LONDON'

--USING WHERE CLAUSE TO LIMIT THE NUMBER OF ROWS THAT YOU WANT TO RETURN NOW
SELECT * FROM tblPerson WHERE CITY<>'LONDON'
--<> not equal to symbol in sql server 
-- != this is considered as not equal to
SELECT * FROM tblPerson WHERE CITY!='LONDON'
--we have lot of operators and wild cards
--=equal to
--!= or <> not equal to
-->greater than
--<less than
--<=lessthan or equal to 
--IN specify a list of values
--between specify a range
--like specify a pattern
--not not in list, range, etc.,
-- % SPECIFIES ZERO OR MORE CHARACTERS
--    - SPECIFIES EXACTLY ONE CHARACTER
---[] ANY CHARACTER WITHIN THE BRACKETS
--[^] = NOT ANY CHARACTER WITHIN THE BRACKETS (^(shift+6 shortcut))

SELECT * FROM tblPerson WHERE Age=20 or Age=23 or Age=29

SELECT * FROM tblPerson WHERE Age IN (20, 23, 29)

SELECT * FROM tblPerson WHERE Age BETWEEN 20 AND 25

SELECT * FROM tblPerson WHERE Age=20 or Age=23 or Age=29

SELECT * FROM tblPerson WHERE CITY LIKE 'L%' --displays only L values which starts with L

SELECT * FROM tblPerson WHERE EMAIL NOT LIKE '%@%' --dispaly which doesnt have @

SELECT * FROM tblPerson WHERE EMAIL LIKE '_@_.COM' -- .com will be add and a@a.com will be added

SELECT * FROM tblPerson WHERE NAME LIKE '[MST]%' --will provide data the letter starts from MST

SELECT * FROM tblPerson WHERE NAME LIKE '[^MST]%' -- other than MST

SELECT * FROM tblPerson WHERE (city='london' or city='mumbai') AND AGE>25 --DISPLAY AGE WHICH IS GREATER THAN 25
-------------------------------------------------------------------------------------------------------------------
--TO RETRIEVE THE NAMES IN ASCENDING ORDER
SELECT * FROM tblPerson ORDER BY NAME --BY DEFAULT IT DISPLAYS ASCENDING ORDER
SELECT * FROM tblPerson ORDER BY NAME DESC, AGE ASC  -- BY DEFAULT DISPLAYS DESCENDING ORDER

--TOP N OR TOP N PERCENTAGE OF ROWS
THIS IS USEFUL IF THE TABLE IS LARGE 

SELECT TOP 2 NAME, AGE FROM TBLPERSON
select top 1 percent * from tblperson

--GROUP BY IN SQL SERVER
CREATE TABLE tblEmployee (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Gender VARCHAR(10),
    Salary DECIMAL(10, 2),
    City VARCHAR(50)
);
insert into tblEmployee(ID, Name, Gender, Salary, City) values (1, 'Tom', 'Male', 4000, 'London')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (2, 'Pam', 'Female', 3000, 'New York')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (3, 'John', 'Male', 3500, 'London')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (4, 'Sam', 'Male', 4500, 'London')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (5, 'Todd', 'Male', 2800, 'Sydney')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (6, 'Ben', 'Male', 7000, 'New York')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (7, 'Sara', 'Female', 4800, 'Sydney')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (8, 'Valarie', 'Female', 5500, 'New York')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (9, 'James', 'Male', 6500, 'London')
insert into tblEmployee(ID, Name, Gender, Salary, City) values (10, 'Russell', 'Male', 8800, 'London')

select * from tblEmployee

SELECT SUM(salary) from tblEmployee
SELECT min(salary) from tblEmployee
SELECT max(salary) from tblEmployee
--USING GROUPBY
SELECT SUM(salary) AS TOTALSALARY 
from tblEmployee
GROUP BY CITY

SELECT CITY, GENDER, SUM(salary) AS TOTALSALARY 
from tblEmployee
GROUP BY CITY, Gender
ORDER BY City

SELECT GENDER, CITY, SUM(salary) AS TOTALSALARY 
from tblEmployee
GROUP BY Gender, City
ORDER BY City

SELECT COUNT(*) FROM tblEmployee
SELECT COUNT(ID) FROM tblEmployee

SELECT GENDER, CITY, SUM(salary) AS TOTALSALARY, COUNT(ID) AS [Total Employees]
from tblEmployee
GROUP BY Gender, City

--PART 11 FILTERING GROUPS
SELECT GENDER, CITY, SUM(salary) AS TOTALSALARY, COUNT(ID) AS TotalEmployees
from tblEmployee
WHERE GENDER='MALE'
GROUP BY Gender, City  --here aggregations are not done

SELECT GENDER, CITY, SUM(salary) AS TOTALSALARY, COUNT(ID) AS TotalEmployees
from tblEmployee
GROUP BY Gender, City
having gender='male'  -- in this aggregations are done every row in this table

--AGREEGATE FUNCTIONS

select * from tblEmployee where sum(salary)>4000 -- will get error
--An aggregate may not appear in the WHERE clause unless it is in a 
--subquery contained in a HAVING clause or a select list, and the column being aggregated is an outer reference.

--AGREEGATE FUNCTIONS COUNT, SUM, AVG, MIN, MAX
from tblEmployee
GROUP BY Gender, City
having sum(salary) >5000

--PART 12 JOINS IN SQL SERVER











