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
CROSS JOIN
INNER JOIN 
OUTER JOIN-LEFT, RIGHT AND FULL OUTER JOIN

CREATE TABLE tblEmployeee (
    ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100),
    Gender VARCHAR(10),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);
SELECT * from tblEmployeee

CREATE TABLE tblDepartment (
    ID INT NOT NULL PRIMARY KEY,
    DepartmentName VARCHAR(100),
    Location VARCHAR(100),
    DepartmentHead VARCHAR(100)
);
SELECT * from tblDepartment

insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (1, 'Tom', 'Male', 4000, 1)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (2, 'Pam', 'Female', 3000, 3)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (3, 'John', 'Male', 3500, 1)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (4, 'Sam', 'Male', 4500, 2)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (5, 'Todd', 'Male', 2800, 2)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (6, 'Ben', 'Male', 7000, 1)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (7, 'Sara', 'Female', 4800, 3)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (8, 'Valarie', 'Female', 5500, 1)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (9, 'James', 'Male', 6500, NULL)
insert into tblEmployeee(ID, Name, Gender, Salary, DepartmentID) values (10, 'Russell', 'Male', 8800, NULL)

insert into tblDepartment(ID, DepartmentName, Location, DepartmentHead) values (1, 'IT','London','Rick')
insert into tblDepartment(ID, DepartmentName, Location, DepartmentHead) values (2, 'Payroll','Delhi','Ron')
insert into tblDepartment(ID, DepartmentName, Location, DepartmentHead) values (3, 'HR','New York','Christie')
insert into tblDepartment(ID, DepartmentName, Location, DepartmentHead) values (4, 'Other Department','Sydney','Cindrella')

select * from tblEmployeee
select * from tblDepartment

--INNER JOIN QUERY
 select name, gender, salary, departmentname
 from tblEmployeee
 JOIN tblDepartment
 ON tblEmployeee.DepartmentID=tblDepartment.ID

 ----------OR-----------------
 select name, gender, salary, departmentname
 from tblEmployeee
 INNER JOIN tblDepartment
 ON tblEmployeee.DepartmentID=tblDepartment.ID

 --LEFT OUTER JOIN
 select name, gender, salary, departmentname
 from tblEmployeee
 LEFT OUTER JOIN tblDepartment
 ON tblEmployeee.DepartmentID=tblDepartment.ID

 ---OR-------
 select name, gender, salary, departmentname
 from tblEmployeee
 LEFT JOIN tblDepartment
 ON tblEmployeee.DepartmentID=tblDepartment.ID
 select * from tblEmployeee
select * from tblDepartment

select name, gender, salary, departmentname
 from tblEmployeee
 RIGHT JOIN tblDepartment
 ON tblEmployeee.DepartmentID=tblDepartment.ID
 select * from tblEmployeee
select * from tblDepartment

select name, gender, salary, departmentname
 from tblEmployeee
 FULL OUTER JOIN tblDepartment  --YOU CAN USE FULL JOIN
 ON tblEmployeee.DepartmentID=tblDepartment.ID
 select * from tblEmployeee
select * from tblDepartment

--cross join (will not have on clause)
select name, gender, salary, departmentname
 from tblEmployeee
 CROSS JOIN tblDepartment

----ADVANCED JOINS-----
SELECT * FROM tblEmployeee
SELECT * FROM tblDepartment

SELECT		name, gender, salary, departmentname
FROM		tblEmployeee
LEFT JOIN	tblDepartment
ON			tblEmployeee.DepartmentID=tblDepartment.ID
WHERE		tblEmployeee.DepartmentID is NULL

SELECT		name, gender, salary, departmentname
FROM		tblEmployeee
right JOIN	tblDepartment
ON			tblEmployeee.DepartmentID=tblDepartment.ID
WHERE		tblEmployeee.DepartmentID is NULL

SELECT		name, gender, salary, departmentname
FROM		tblEmployeee
full JOIN	tblDepartment
ON			tblEmployeee.DepartmentID=tblDepartment.ID
WHERE		tblEmployeee.DepartmentID is NULL

--LEFT OUTER SELF JOIN
--INNER SELF JOIN
--CROSS SELF JOIN
CREATE TABLE tblEmpjoins (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    ManagerID INT NULL
);
INSERT INTO tblEmpjoins (EmployeeID, Name, ManagerID) VALUES
(1, 'Mike', 3),
(2, 'Rob', 1),
(3, 'Todd', NULL),
(4, 'Ben', 1),
(5, 'Sam', 1);

select * from tblEmpjoins
 
 SELECT E.NAME AS EMPLOYEE, M.NAME AS MANAGER
 FROM tblEmpjoins E
 LEFT JOIN tblEmpjoins M
 ON E.ManagerID = M.EmployeeID

 SELECT E.NAME AS EMPLOYEE, M.NAME AS MANAGER
 FROM tblEmpjoins E
 INNER JOIN tblEmpjoins M
 ON E.ManagerID = M.EmployeeID

 SELECT E.NAME AS EMPLOYEE, M.NAME AS MANAGER
 FROM tblEmpjoins E
 CROSS JOIN tblEmpjoins M

 ---PART 15: DIFFERENT PLACE TO REPLACE NULL VALUES
 --ISNULL() FUNCTION
 --CASE STATEMENT
 --COALESCE() FUNCTION

 SELECT E.NAME AS EMPLOYEE, ISNULL(M.NAME, 'NO MANAGER') AS MANAGER
 FROM tblEmpjoins E
 LEFT JOIN tblEmpjoins M
 ON E.ManagerID=M.EmployeeID

 SELECT E.NAME AS EMPLOYEE,
 CASE
 WHEN M.NAME IS NULL THEN 'NO MANAGER' ELSE M.NAME
 END
 AS MANAGER
 FROM TBLEMPJOINS E
 LEFT JOIN TBLEMPJOINS M
 ON E.MANAGERID=M.EMPLOYEEID

 SELECT 
    E.NAME AS EMPLOYEE, 
    COALESCE(M.NAME, 'NO MANAGER') AS MANAGER
FROM 
    tblEmpjoins E
LEFT JOIN 
    tblEmpjoins M ON E.ManagerID = M.EmployeeID;

--PART 16-- COALESCE FUNCTION IN SQL SERVER
RETURNS FIRST NULL VLAUE

CREATE TABLE People (
    Id INT PRIMARY KEY,
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50)
);
INSERT INTO People (Id, FirstName, MiddleName, LastName) VALUES
(1, 'Sam', NULL, NULL),
(2, NULL, 'Todd', 'Tanzan'),
(3, NULL, NULL, 'Sara'),
(4, 'Ben', 'Parker', NULL),
(5, 'James', 'Nick', 'Nancy');

SELECT * FROM People
SELECT ID, COALESCE(FIRSTNAME, MIDDLENAME,LASTNAME) AS NAME FROM People

--PART 17 UNION AND UNION ALL IN SQL SERVER
--PURPOSE, DIFFERENCE JOIN & UNION, DIFFERENCE UNION & UNION ALL
-- TableA
CREATE TABLE TableA (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100)
);

-- TableB
CREATE TABLE TableB (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100)
);

-- Insert into TableA
INSERT INTO TableA (Id, Name, Email) VALUES
(1, 'Raj', 'R@R.com'),
(2, 'Sam', 'S@S.com');

-- Insert into TableB
INSERT INTO TableB (Id, Name, Email) VALUES
(1, 'Ben', 'B@B.com'),
(2, 'Sam', 'S@S.com');

SELECT * FROM TableA
SELECT * FROM TableB

SELECT * FROM TableA
UNION 
SELECT * FROM TableB

SELECT * FROM TableA
UNION ALL
SELECT * FROM TableB

SELECT * FROM TableA
UNION 
SELECT * FROM TableB

SELECT ID, EMAIL, NAME FROM TableA
UNION
SELECT ID, NAME, EMAIL FROM TableB

SELECT ID, EMAIL, NAME FROM TableA
UNION ALL
SELECT ID, NAME, EMAIL FROM TableB

SELECT * FROM TableA
ORDER BY NAME

SELECT * FROM TableB
ORDER BY NAME

SELECT * FROM TableA
UNION ALL
SELECT * FROM TableB
UNION ALL
SELECT * FROM TableB
ORDER BY Name

--UNION combines rows from 2 or more tables
--joins combines from 2 or more columns
-------------------------------------------------\
---STORED PROCEDURES IN SQL SERVER---
CREATE TABLE Emp (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    DepartmentId INT
);

INSERT INTO Emp(Id, Name, Gender, DepartmentId) VALUES
(1, 'Sam', 'Male', 1),
(2, 'Ram', 'Male', 1),
(3, 'Sara', 'Female', 3),
(4, 'Todd', 'Male', 2),
(5, 'John', 'Male', 3),
(6, 'Sana', 'Female', 2),
(7, 'James', 'Male', 1),
(8, 'Rob', 'Male', 2),
(9, 'Steve', 'Male', 1),
(10, 'Pam', 'Female', 2);

select * from Emp

create procedure spGetEmployees
AS
BEGIN
select name, gender from Emp
END

SPGETEMPLOYEES  --STORED PROCEDURES TO EXECUTE
EXEC spGetEmployees --FOR EXECUTION

CREATE PROC SPGETEMPLOYEES
AS
BEGIN
SELECT NAME, GENDER FROM Emp
END

SELECT * FROM Emp

CREATE PROC SPGetEmpByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as
Begin
Select Name, Gender, DepartmentId 
from Emp 
where gender = @Gender
and 
DepartmentId = @DepartmentId
END

SPGetEmpByGenderAndDepartment 'Male', 1  --to execute
SPGetEmpByGenderAndDepartment @Departmentid =1 , @Gender='Male'

--simple stored procedures
--procedure with parameters and execution
-- defination of stored procedure in new query window--programmability--stored procedures--dbo.spgetgenderand department

-------------------------------------------------------------------------------------------------------------------------
SYSTEM STORED PROCEDURES
--CREATE STORED PROCEDURES WITH INPUT PARAMETERS--
sp_helptext spgetemployees  ---it shows impleentation of stored procedure looks like
create procedure spGetEmployees  
AS  
BEGIN  
select name, gender from Emp  
END
-- NOTE: FOR USER DEFINED STORED PROCEDURES MICORSOFT RECOMMNEDS NOT TO USE SP_ as a prefix

alter procedure spGetEmployees  
AS  
BEGIN  
select name, gender from Emp tblemployee order by name
END

DROP PROCEDURE spGetEmployees

--ENCRYPT TEXT OF STORED PROCEDURE
SP_HELPTEXT SPGetEmpByGenderAndDepartment

ALTER PROC SPGetEmpByGenderAndDepartment  
@Gender nvarchar(20),  
@DepartmentId int 
WITH ENCRYPTION
as  
Begin  
Select Name, Gender, DepartmentId   
from Emp   
where gender = @Gender  
and   
DepartmentId = @DepartmentId  
END

--CREATE STORED PROCEDURES WITH OUTPUT PARAMETERS

CREATE TABLE Empproc (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    DepartmentId INT
);

INSERT INTO Empproc(Id, Name, Gender, DepartmentId) VALUES
(1, 'Sam', 'Male', 1),
(2, 'Ram', 'Male', 1),
(3, 'Sara', 'Female', 3),
(4, 'Todd', 'Male', 2),
(5, 'John', 'Male', 3),
(6, 'Sana', 'Female', 2),
(7, 'James', 'Male', 1),
(8, 'Rob', 'Male', 2),
(9, 'Steve', 'Male', 1),
(10, 'Pam', 'Female', 2);

select * from Empproc

CREATE PROCEDURE spGetEmpprocCountByGender
    @Gender NVARCHAR(20),
    @EmpprocCount INT OUTPUT
AS
BEGIN
    SELECT count(*) from empproc
END;

ALTER PROCEDURE spGetEmpprocCountByGender
    @Gender NVARCHAR(20),
    @EmpprocCount INT OUTPUT
AS
BEGIN
    SELECT @EmpprocCount = count(id) from empproc where Gender=@Gender
END;

declare @totalcount int
execute spGetEmpprocCountByGender 'male', @totalcount out 
if(@totalcount is null)
	print '@TottalCount is null'
	Else
	Print '@TotalCount is not null'
print @totalcount

DECLARE @totalcount INT;

EXECUTE spGetEmpprocCountByGender 
    @Gender = 'Male',
    @EmpprocCount = @totalcount OUTPUT;

PRINT @totalcount;

sp_help spGetEmpprocCountByGender

sp_help empproc

sp_helptext spGetEmpprocCountByGender

sp_depends spGetEmpprocCountByGender
---------------------------------------------------------------------------------------------------------
---STORED PROCEDURES OUTPUT PARAMETERS OR RETURN VALUES
DECLARE @RETURN_VALUE INT
@NAME NVARCHAR(20)
EXEC @RETURN_VALUE=[DBO].[spGetEmpprocCountByGender]
@Gender='MALE'
@NAME=@NAME OUTPUT

SELECT @NAME AS N '@NAME'

SELECT 'RETURN VALUE'=@RETURN VALUE
GO

CREATE proc spgettotalcount1
@totalcount int out
as
begin
select @totalcount=count(id) from empproc
end

decalre @total int
execute spgettotalcount1 @total out
print @total

CREATE proc spgettotalcount2
@totalcount int out
as
begin
return (select count=count(id) from empproc)
end

decalre @total int
execute @total=spgettotalcount2 
print @total

DECLARE @total INT;

EXECUTE @total = spgettotalcount2;

PRINT @total;

DECLARE @total INT;

EXEC spgettotalcount2 @totalcount = @total OUTPUT;

PRINT @total;
--------------------------------------------------------------
select * from Emp

create proc spGetNameid1
@id int,
@name nvarchar(20) output
as
begin
select @name= name from emp where id=@id
end

declare @name nvarchar(20)
execute spGetNameid1 1, @name out
print 'name=' + @name

--SP returns name of the person using return values
 create proc spgetnamebyid2
 @id int
 as 
 begin
 return(select name from Emp where id=@id)
 end
 
 DECALRE @NAME NVARCHAR(20)
 EXECUT @NAME = SPGETNAMEBYID2 1
 PRINT 'NAME=' + @NAME

 RETURN STATUS VALUE						OUTPUT PARAMETERS
 ONLY INTERGER DATATYPE						ANYDATATYPE
 ONLY ONE VALUE								MORE THAN VALUE
 USE TO CONVERY SUCCESS OR FAILURE			USE TO RETURN VALUES LIKE NAME, COUNT ETC.,


 --ADVANTAGES OF STORED PROCEDURES
 EXECUTION PLAN RETENTION AND REUSABILITY
 REDUCES NETWORK TRAFFIC
 CODE REUSABILITY AND BETTER MAINTAINABILITY
 BETTER SECURITY
 AVOID SQL INJECTION ATTACK

 SELECT * FROM EMP

 Create procedure spGetNameById
 @Id int
 As
 Begin 
 Select Name from emp where Id=@id
 End

 Execute spGetNameById 1
 Execute spGetNameById 2

 select Name from emp where Id=1
 select Name from emp where Id=2

 --part22 BUILT IN STRING FUNCTIONS IN SQL SERVER
 user defined
 system functions

 select ASCII('A')
 select ASCII('ABC')
 select ASCII('BC')

 SELECT CHAR(65)

DECLARE @START INT
SET @START=65
WHILE(@START<=90)
BEGIN
PRINT CHAR(@START)
SET @START=@START+1
END

SELECT RIGHT('ABCDEF',4)
SELECT LEFT('ABCDEF',4)

--CHARINDEX
'sara@aaa.com'

select CHARINDEX('@','sara@aaa.com')

--SUBSTRING
select SUBSTRING('sara@aaa.com',6,7)
select SUBSTRING('pam@bbb.com',5,7)
select SUBSTRING('pam@bbb.com',charindex('@','pam@bbb.com')+1,7)
--These will be used when manipulate the strings
select SUBSTRING('pam@bbb.com',charindex('@','pam@bbb.com')+1, LEN('pam@bbb.com')-charindex('@','pam@bbb.com'))

CREATE TABLE Emp1 (
    Id INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    MiddleName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Gender NVARCHAR(10),
    DepartmentId INT,
    Number INT
);

INSERT INTO Emp1 (Id, FirstName, MiddleName, LastName, Email, Gender, DepartmentId, Number) VALUES
(1, 'Sam',  'S', 'Sony',    'Sam@aaa.com',  'Male',   1, 1),
(2, 'Ram',  'R', 'Barber',  'Ram@aaa.com',  'Male',   1, 2),
(3, 'Sara', NULL, 'Sanosky','Sara@ccc.com', 'Female', 3, 2),
(4, 'Todd', NULL, 'Gartner','Todd@bbb.com', 'Male',   2, 2),
(5, 'John', 'J', 'Grover',  'John@aaa.com', 'Male',   1, 3),
(6, 'Sana', 'S', 'Lenin',   'Sana@ccc.com', 'Female', 3, 1),
(7, 'James','J', 'Bond',    'James@bbb.com','Male',   2, 3),
(8, 'Rob',  'R', 'Hunter',  'Rob@ccc.com',  'Male',   2, 2),
(9, 'Steve','S', 'Wilson',  'Steve@aaa.com','Male',   1, 2),
(10,'Pam',  'P', 'Broker',  'Pam@bbb.com',  'Female', 2, 1);

select * from Emp1

select SUBSTRING(email, charindex('@',email)+1,
len(email)-charindex('@',email)) as EmailDomain
from Emp1

SELECT 
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email) - CHARINDEX('@', email)) AS EmailDomain,
    COUNT(Email) AS Total
FROM 
    emp1
GROUP BY 
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email) - CHARINDEX('@', email));

--REPLICATE()FUNCTION
SELECT REPLICATE('PRAGIM', 3)

--SPACE
select '          '
select space(5)

--PATINDEX
SELECT EMAIL, PATINDEX('%@aaa.com',email) as firstoccurence
from Emp1
where PATINDEX('%@aaa.com',email>0)

--REPLACE()
select email, REPLACE(email, '.com', '.net') as convertedemail
from Emp1

--STUFF()
select email, STUFF(email,1,2,3, '*****') as stuffedemail
from Emp1


--PART 25 DATETIME FUNCTIONS IN SQL SERVER

select DATEPART(weekday, '2012-08-30 19:45:31.793') --returns5
select DATENAME(weekday, '2012-08-30 19:45:31.793') --returns thursday

select DATEADD(day, 20, '2012-08-30 19:45:31.793') --returns 2012-08-30 19:45:31.793
select DATEADD(day, -20, '2012-08-30 19:45:31.793') --returns 2012-08-10 19:45:31.793

select DATEDIFF(month, '11/30/2005', '01/31/2006')  --returns 2
select DATEDIFF(day, '11/300/2005','01/31/2006') --returns 62

select DATEDIFF(day, '11/30/2005', '01/31/2006')  --returns 2

DECALRE @DOB datetime, @tempdate datetime, @years int, @months int, @days int
set @DOB='10/08/1982'

select @tempdate=@DOB

Select @years = DATEDIFF(year, @tempdate, getdate())
case
	when (month(@DOB) > month(getdate())) OR
	(Month(@DOB)-month(getdate()) and day(@DOB)>Day(Getdate()))
	then 1 else 0
end
select @tempdate =dateadd(year, @years, @tempdate)
----------------------------------------------------------------------------------

CREATE TABLE EmployeeBirthdays (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    DateOfBirth DATETIME
);

INSERT INTO EmployeeBirthdays (Id, Name, DateOfBirth) VALUES
(1, 'Sam',  '1980-12-30 00:00:00.000'),
(2, 'Pam',  '1991-09-01 12:02:36.260'),
(3, 'John', '1985-08-22 12:03:30.370'),
(4, 'Sara', '1979-11-29 12:59:30.670');

select*from EmployeeBirthdays

select id, name, dateofbirth, 
CAST(dateofbirth as nvarchar(20)) 
as convertedDOB
from EmployeeBirthdays

select id, name, dateofbirth, 
CONVERT(nvarchar, DateofBirth) 
as convertedDOB 
from EmployeeBirthdays

select id, name, dateofbirth
convert(nvarchar, dateofbirth,103) as convertedDOB
from employeebirthdays

--TO GET JUST THE DATEPART FROM THE DATETIME
SELECT CONVERT(VARCHAR(10), GETDATE(), 101);
--returns 09/02/2012

select id, name, name + '_' + cast(id as nvarchar) from EmployeeBirthdays

CREATE TABLE registrations (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    email VARCHAR(50),
    DateOfBirth DATETIME
);

INSERT INTO registrations (Id, Name, email, DateOfBirth) VALUES
(1, 'John',  'j@j.com',  '2012-08-24 11:04:30.230'),
(2, 'Sam',   's@s.com',   '2012-08-25 14:04:29.780'),
(3, 'Todd',  't@t.com',  '2012-08-25 15:04:29.780'),
(4, 'Mary',  'm@m.com',  '2012-08-24 15:04:30.730'),
(5, 'Sunil', 'sunil@s.com', '2012-08-24 15:05:30.330'),
(6, 'Mike',  'mike@m.com',  '2012-08-26 15:05:30.330');

select * from registrations
EXEC sp_rename 'registrations.DateOfBirth', 'RegistrationDate', 'COLUMN';

SELECT cast(RegistrationDate as date), COUNT(Id) AS total
FROM registrations
GROUP BY cast(RegistrationDate as date);

--PART 29 MATHEMATICAL FUNCTIONS IN SQL SERVER
Select ABS (-101.5) -- returns 101.5, without the - sign.

Select CEILING (15.2) -- Returns 16

Select CEILING(-15.2) -- Returns -15

Select FLOOR (15.2) -- Returns 15

Select FLOOR (-15.2) -- Returns -16

Select POWER (2,3) -- Returns 8

Select SQUARE (9) -- Returns 81

Select SQRT (81) -- Returns 9

Select RAND (1) -- Always returns the same value
select RAND() --- it will show seed value in between 0 to1 random number 0.008 like that

Select FLOOR (RAND () * 100)

DECLARE @Counter INT;
SET @Counter = 1;

WHILE (@Counter <= 10)
BEGIN
    PRINT FLOOR(RAND() * 100);
    SET @Counter = @Counter + 1;
END;
--ROUND(NUMERIC EXPRESSION, LENGTH, [FUNCTION- Which you used to round the number or truncate the number])

--Round to 2 places after (to the right) the decimal point

Select ROUND (850.556, 2) -- Returns 850.560

--NOTE: IT ROUNDS THE GIVEN NUMBER OR IT TRUNCATES THE GIVEN NUMBER
--Truncate anything after 2 places, after (to the right) the decimal point select ROUND (850.556, 2, 1) -- Returns 850.550
-- Round to 1 place after (to the right) the decimal point
Select ROUND (850.556, 1) -- Returns 850.600
-- Truncate anything after 1 place, after (to the right) the decimal point 
Select ROUND (850.556, 1, 1) -- Returns 850.500
-- Round the last 2 places before (to the left) the decimal point
Select ROUND (850.556, -2) -- 900.000
--Round the last 1 place before (to the left) the decimal point
Select ROUND (850.556, -1) -- 850.000

--USER DEFINED FUNCTIONS(UDF)
--PART 30 -SCALAR USER DEFINED FUNCTIONS IN SQL  -- IT RETURNS SINGLE VALUE
SELECT SQUARE(3)

SELECT GETDATE()

DECLARE @DOB DATE;
SET @DOB = '1982-08-10';  -- unambiguous date format
SELECT @DOB;

CREATE FUNCTION CALCULATEAGE (@DOB DATE)
RETURNS INT
AS
BEGIN
    DECLARE @AGE INT;

    SET @AGE = DATEDIFF(YEAR, @DOB, GETDATE()) 
        - CASE 
            WHEN (MONTH(@DOB) > MONTH(GETDATE()))
                 OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
            THEN 1
            ELSE 0
          END;

    RETURN @AGE;
END;

SELECT SAMPLE.DBO.CALCULATEAGE('10/08/1982')
--OR
SELECT DBO.CALCULATEAGE('10/08/1982')

SELECT * FROM EmployeeBirthdays

SELECT ID, NAME, DBO.CALCULATEAGE(DATEOFBIRTH) AS AGE FROM EmployeeBirthdays
WHERE DBO.CALCULATEAGE(DATEOFBIRTH) >30

SP_HELPTEXT CALCULATEAGE
CREATE FUNCTION SPCALCULATEAGE 
(
    @DOB DATE   
)
RETURNS INT
AS  
BEGIN  
    DECLARE @AGE INT;  

    SET @AGE = DATEDIFF(YEAR, @DOB, GETDATE())   
        - CASE   
            WHEN (MONTH(@DOB) > MONTH(GETDATE()))  
                 OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))  
            THEN 1  
            ELSE 0  
          END;  

    RETURN @AGE;  
END;

EXECUTE SPCALCULATEAGE '10/8/1982'

SELECT ID, NAME,DBO.CALCULATEAGE(DATEOFBIRTH) AS AGE
FROM EMPLOYEEBIRTHDAYS

--PART 31 INLINE TABLE VALUED FUNCTIONS  = used to achieve the functionality of parameterized views
CREATE TABLE EmployeeDetails (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    DateOfBirth DATETIME,
    Gender NVARCHAR(10),
    DepartmentId INT
);
INSERT INTO EmployeeDetails (Id, Name, DateOfBirth, Gender, DepartmentId) VALUES
(1, 'Sam',  '1980-12-30 00:00:00.000', 'Male',   1),
(2, 'Pam',  '1982-09-01 12:02:36.260', 'Female', 2),
(3, 'John', '1985-08-22 12:03:30.370', 'Male',   1),
(4, 'Sara', '1979-11-29 12:59:30.670', 'Female', 3),
(5, 'Todd', '1978-11-29 12:59:30.670', 'Male',   1);

select * from EmployeeDetails

--CREATE THE FUNCTION
CREATE FUNCTION fn_EmployeesByGender (@Gender NVARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT ID, Name, DateOfBirth, Gender, DepartmentID
    FROM EmployeeDetails
    WHERE Gender = @Gender
);

select * from fn_EmployeesByGender('male') where name='john'

SELECT E.ID, E.Name, E.Gender, E.DepartmentID
FROM fn_EmployeesByGender('male') E
JOIN EmployeeDetails D ON D.ID = E.ID;

--MULTI STATEMENT TABLE VALUED FUNCTIONS IN SQL SERVER
select * from employeedetails

CREATE FUNCTION fn_MSTVF_EmployeeDetails()
RETURNS TABLE
AS
RETURN
(
    SELECT ID, Name, CAST(DateOfBirth AS DATE) AS DOB
    FROM EmployeeDetails
);

SELECT * FROM fn_MSTVF_EmployeeDetails();

CREATE FUNCTION fn_MSTVF_EmployeeDetails()
RETURNS @table TABLE (
    ID INT,
    Name VARCHAR(20),
    DOB DATE
)
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Name, CAST(DateOfBirth AS DATE)
    FROM EmployeeDetails;

    RETURN;
END;

SELECT * FROM fn_MSTVF_EmployeeDetails();

--PART 33 IMPORTANT CONCEPTS RELATED TO FUNCTIONS IN SQL SERVER
DETERMINISTIC AND NON DETERMINISTIC
DETERMINISTIC FUNCTIONS EX: SQUARE(), POWER(), SUM(), AVG(), AND COUNT()
NON DETERMINISTIC FUNCTIONS EX: GETDATE() AND CURRENT_TIMESTAMP()

--RAND() FUNCTION -- NON DETERMINISTIC FUNCTION BUT IF PROVIDES A SEED VALUE THE 
--FUNCTION RETURNS DETERMINISTIC, AS THE SAME VALUE GETS RETURNED FOR THE SAME SEED VALUE.
SELECT * FROM EmployeeDetails

SELECT COUNT(*) FROM EmployeeDetails

SELECT SQUARE(3) --DEERMINISTIC

SELECT GETDATE()--NON DETERMINISTIC

SELECT CURRENT_TIMESTAMP --NON DETERMINISTIC

SELECT RAND(1) --IF YOU PROVIDE A VALUE IN THE GIVEN SEED THE OUPUT WILL BE SAME AND IT WONT CHANGE

SELECT RAND()--EXECUTES RANDOM VALUES
--RAND FUNC BEHAVE BOTH AS DETERMINISTIC AND NON DETERMINISTIC DEPENDING ON HOW YOU EXECUTE

--ENCRYPTING THE FUNCTION DEFINATION AND SCHEMA BINDING
SELECT * FROM EMPLOYEEDETAILS

CREATE FUNCTION FN_GETNAMEBYID(@ID INT)
RETURNS VARCHAR(30)
AS
BEGIN
RETURN (SELECT NAME FROM EmployeeDetails WHERE ID=@ID)
END

SELECT DBO.FN_GETNAMEBYID(1)

SP_HELPTEXT FN_GETNAMEBYID

ALTER FUNCTION FN_GETNAMEBYID(@ID INT)  
RETURNS VARCHAR(30)  
WITH ENCRYPTION
AS  
BEGIN  
RETURN (SELECT NAME FROM EmployeeDetails WHERE ID=@ID)  
END  

SP_HELPTEXT FN_GETNAMEBYID  - click f5

once encrytped you cannot view the text of the function

--**IMPORTANT: SCHEMA BINDING**--

SP_HELPTEXT FN_GETNAMEBYID

ALTER FUNCTION FN_GETNAMEBYID(@ID INT)  
RETURNS VARCHAR(30)
WITH SCHEMABINDING
AS  
BEGIN  
RETURN (SELECT NAME FROM DBO.EmployeeDetails WHERE ID=@ID)  
END  

DROP TABLE EmployeeDetails

--PART 34 TEMPORARY TABLES IN SQL SERVER
LOCAL AND GLOBAL

--SINGLE # SYMBOL INDICATE THAT THIS PERSON TABLE IS A TEMPORARY TABLE
--EX CREATE TABLE #PERSONALDETAILS (ID INT, NAME NVARCHAR(20))

--	lets  call this as 1st connection window
CREATE TABLE #PERSONALDETAILS (ID INT, NAME NVARCHAR(20))

INSERT INTO #PERSONALDETAILS VALUES(1, 'Mike')
INSERT INTO #PERSONALDETAILS VALUES(2, 'John')
INSERT INTO #PERSONALDETAILS VALUES(3, 'Todd')

select * from #PERSONALDETAILS

--IF YOU CLOSE 1ST CONNECTION IT WILL DROP AUTOMATICALLY
--IF THE 2ND CONNECTION IS OPEN 2ND WILL BE AVAILABLE 1ST WILL BE CLOSED

----USING PROCEDURES
CREATE PROCEDURE SPCREATELOCALTEMPTABLE
AS
BEGIN
CREATE TABLE #PERSONALDETAILS (ID INT, NAME NVARCHAR(20))
INSERT INTO #PERSONALDETAILS VALUES(1, 'Mike')
INSERT INTO #PERSONALDETAILS VALUES(2, 'John')
INSERT INTO #PERSONALDETAILS VALUES(3, 'Todd')

select * from #PERSONALDETAILS
END

EXECUTE SPCREATELOCALTEMPTABLE

CREATE TABLE #PERSONALDETAILS (ID INT, NAME NVARCHAR(20))

INSERT INTO #PERSONALDETAILS VALUES(1, 'Mike')
INSERT INTO #PERSONALDETAILS VALUES(2, 'John')
INSERT INTO #PERSONALDETAILS VALUES(3, 'Todd')

select * from #PERSONALDETAILS

--GLOBAL TEMPORARY TABLES
--with global temprary tables we cannot create same tables in 2 different connections
--where as in local temp tables we can able to create

CREATE TABLE ##EMPLOYEEDETAILS (ID INT, NAME NVARCHAR(20))

select * from ##EMPLOYEEDETAILS

INSERT INTO ##EMPLOYEEDETAILS VALUES(1, 'Mike')
INSERT INTO ##EMPLOYEEDETAILS VALUES(2, 'John')
INSERT INTO ##EMPLOYEEDETAILS VALUES(3, 'Todd')

--#--single pound local
--## - 2 pound symbols global
--PART 35 INDEXES IN SQL SERVER
--CREATED ON TABLES AND VIEWS
 SELECT * FROM tblEmployeee

 CREATE INDEX IX_TBLEMPLOYEEE_SALARY
ON TBLEMPLOYEEE (SALARY ASC);

sp_helpindex tblemployeee

drop index tblemployeee.IX_TBLEMPLOYEEE_SALARY

--part 36 clustered and non clustered indexes in sql server

CREATE TABLE [tblEmployeecluster] (
    [Id] INT PRIMARY KEY,
    [Name] NVARCHAR(50),
    [Salary] INT,
    [Gender] NVARCHAR(10),
    [City] NVARCHAR(50)
);

Insert into tblEmployeecluster Values 
(3, 'John', 4500, 'Male', 'New York'),
(1, ' Sam', 2500, 'Male', ' London'),
(4, 'Sara', 5500, 'Female', 'Tokyo' ),
(5, 'Todd', 3100, 'Male', 'Toronto' ),
(2, 'Pam' , 6500, 'Female', 'Sydney')

select * from tblEmployeecluster

execute sp_helpindex tblemployeecluster

create clustered index IX_tblemployeecluster_gender_salary
on tblemployeecluster(gender desc, salary asc)

drop index tblemployee.PK__tblEmplo__3214EC07EDBFE281

CREATE nonCLUSTERED INDEX IX_tblemployeecluster
ON tblemployeecluster(name);

--PART 37 UNIQUE & NON UNIQUE INDEXES
CREATE TABLE tbemployee (
    [Id] INT PRIMARY KEY,
    [FirstName] NVARCHAR(50),
    [LastName] NVARCHAR(50),
    [Salary] INT,
    [Gender] NVARCHAR(10),
    [City] NVARCHAR(50)
);

sp_helpindex tbemployee

Insert into tbemployee Values 
(3, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(1, 'Sam', 'Menco', 4500, 'Male', 'New York')

(1, 'Sam', 'Menco', 2500, 'Male', 'Sydney'),
(4, 'Sam', 'Menco', 2500, 'Male', 'Sydney'),
(3, 'Mike', 'Menco', 2500, 'Male', 'London'),

select * from tbemployee

CREATE UNIQUE NONCLUSTERED INDEX UIX_TBEMPLOYEE_FIRSTNAME_LASTNAME
ON TBEMPLOYEE (FirstName, LastName);

SELECT City, COUNT(*) 
FROM tbemployee 
GROUP BY City 
HAVING COUNT(*) > 1;

ALTER TABLE tbemployee
ADD CONSTRAINT uq_tbemployee_city
UNIQUE clustered(City);

sp_helptext uq_tbemployee_city

drop index tbemployee.PK__tbemploy__3214EC070626121E
--An explicit DROP INDEX is not allowed on index 'tbemployee.PK__tbemploy__3214EC070626121E'. 
--It is being used for PRIMARY KEY constraint enforcement.
-------------------------------------------------------------------------------------------

--PART 38 ADVANTANTAGES AND DISADVANTAGES OF INDEXES
COVERING INDEXES

SELECT * FROM tblEmployee

CREATE TABLE tbemployees (
    Id INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Salary INT,
    Gender NVARCHAR(10),
    City NVARCHAR(50)
);

INSERT INTO tbemployee (Id, FirstName, LastName, Salary, Gender, City) VALUES
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(2, 'Sara', 'Menco', 6500, 'Female', 'London'),
(3, 'John', 'Barber', 2500, 'Male', 'Sydney'),
(4, 'Pam', 'Grove', 3500, 'Female', 'Toronto'),
(5, 'James', 'Mirch', 7500, 'Male', 'London');

SELECT statement with a WHERE clause
Select * from tblEmployee where Salary > 4000 and Salary < 8000

--DELETE and UPDATE statement
Delete from tblEmployee where Salary = 2500
Update tblEmployee Set Salary = 9000 where Salary = 7500

--ORDER BY ASCENDING
Select * from tblEmployee order by Salary

--ORDER BY DESCENDING
Select * from tblEmployee order by Salary Desc

--GROUP BY
Select Salary, COUNT (Salary) as total 
from tblemployees
group by salary

--indexes help to find data quickly
--clustered index doesnt require any additional storage
--non clustered index requires additional space as ot stored separately from the table
--------------------------------------------------------------------------------------

--PART 39 VIEWS IN SQL SERVER
--SAVED SQL QUERY
TBL-TABLE
STORED PROC-SP
VIEWS-VW

CREATE TABLE tblDept (
    DeptId INT PRIMARY KEY,
    DeptName NVARCHAR(50)
);
INSERT INTO tblDept(DeptId, DeptName) VALUES
(1, 'IT'),
(2, 'Payroll'),
(3, 'HR'),
(4, 'Admin');


CREATE TABLE tblEmpData (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Salary INT,
    Gender NVARCHAR(10),
    DepartmentId INT
);
INSERT INTO tblEmpData (Id, Name, Salary, Gender, DepartmentId) VALUES
(1, 'John', 5000, 'Male', 3),
(2, 'Mike', 3400, 'Male', 2),
(3, 'Pam', 6000, 'Female', 1),
(4, 'Todd', 4800, 'Male', 4),
(5, 'Sara', 3200, 'Female', 1),
(6, 'Ben', 4800, 'Male', 3);

select * from tbldept
select * from tblEmpData

SELECT 
    e.Id, 
    e.Name, 
    e.Salary, 
    e.Gender, 
    d.DeptName
FROM tblEmpData e
JOIN tblDept d
    ON e.DepartmentId = d.DeptId;

create view vWEmployeesByDepartment
as
SELECT 
    e.Id, 
    e.Name, 
    e.Salary, 
    e.Gender, 
    d.DeptName
FROM tblEmpData e
JOIN tblDept d
    ON e.DepartmentId = d.DeptId;

	sp_helptext vWEmployeesByDepartment

		select * from vWEmployeesByDepartment

--A VIEW IS NOTHING BUT A STORED QUERY AND CONSIDERED AS VIRTUAL TABLE
--CAN BE REDUCED TO COMPLEXITY OF DATABASE SCHEMA

CREATE VIEW vWITEmployeesByDepartment
AS
SELECT 
    e.Id, 
    e.Name, 
    e.Salary, 
    e.Gender, 
    d.DeptName
FROM tblEmpData e
JOIN tblDept d
    ON e.DepartmentId = d.DeptId
WHERE d.DeptName = 'IT';

select * from tbldept
select * from tblEmpData
select * from vWITEmployeesByDepartment

CREATE VIEW vWNonConfidentialData
AS
SELECT 
    e.Id, 
    e.Name, 
    e.Gender, 
    d.DeptName
FROM tblEmpData e
JOIN tblDept d
    ON e.DepartmentId = d.DeptId;

select * from vWNonConfidentialData

create view vWSummarizeddata
as
select deptname, count(id) as totalemployees
from tblEmpData
join tblDept
on tblEmpData.DepartmentId=tblDept.DeptId
group by DeptName

select * from vWSummarizeddata

--part 40 UPDATEABLE VIEWS
select * from tbldept
select * from tblEmpData

CREATE VIEW vWEmployeesDataExceptsalary
AS
SELECT id, name, gender, DepartmentId
FROM tblEmpData

select * from vWEmployeesDataExceptsalary

update vWEmployeesDataExceptsalary
insert into vWEmployeesDataExceptsalary
delete from vWEmployeesDataExceptsalary

update vWEmployeesDataExceptsalary
set name='mikey' where id=2

select * from  vWEmployeesDataExceptsalary
select * from tblEmpData
delete from vWEmployeesDataExceptsalary where id=2
insert into vWEmployeesDataExceptsalary values (2, 'mikey', 'male', 2)

create view vWEmployeeDetailsByDepartment
as
select id, name, salary, gender, deptname
from tblEmpData
join tblDept
on tblEmpData.DepartmentId=tblDept.DeptId

select * from vWEmployeeDetailsByDepartment

update vWEmployeeDetailsByDepartment
set DeptName='IT' where Name='john'

select * from tbldept
select * from tblEmpData

--PART 41 INDEXED VIEWS
SELECT * FROM TBLPRODUCT
SELECT * FROM TBLPRODUCTSALES

CREATE TABLE tblProducts (
    ProductId INT PRIMARY KEY,
    Name NVARCHAR(50),
    UnitPrice INT
);

CREATE TABLE tblproductSales (
    ProductId INT,
    QuantitySold INT
);

INSERT INTO tblProducts (ProductId, Name, UnitPrice) VALUES
(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10);

INSERT INTO tblproductSales (ProductId, QuantitySold) VALUES
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14);

select * from tblProducts
select * from tblproductSales

create view vWTotalSlaesByProduct
with SchemaBinding
as
select name,
sum(ISNULL((quantitysold * unitprice), 0)) as totalsales,
count_big(*) as totaltransactions
from dbo.tblproductSales
join dbo.tblProducts
on dbo.tblProducts.productid=dbo.tblproductSales.ProductId
group by name

select * from vWTotalSlaesByProduct

create unique clustered index UIX_vWTotalSlaesByProduct
on vWTotalSlaesByProduct_(name)

--PART 42 VIEW LIMITATIONS
- Error: Cannot pass Parameters to Views reate View vWEmployeeDetails
Gender nvarchar (20)
IS
elect rom
There
Id, Name, Gender, RepartmentId
EblEmployee
Invalid object name 'blEmployee'.

--You can filter Gender in the WHERE clause
Select * from vWEmployeeDetails where Gender = 'Male'

-- Inline Table valued function as a replacement for
-- Parameterized views

Create function fnEmployeeDetails (@Gender nvarchar (20))
Returns Table as
Return
(Select Id, Name, Gender, DepartmentId
from tblEmployee where Gender = (Gender)

Select * from dbo. fnEmployeeDetails ('Male')

--cannot create views on temp tables

--PART 43--
DML TRIGGERS --AFTER TRIGGERS, INSTEAD OF TRIGGERS
--TRIGGERS CAN BE CONSIDERED AS A SPECIAL KIND OF STORED PROCEDURES THAT EXECUTE AUTOMATICALLY
--IN RESPONSE TO TRIGGER ACTION

DML
DDL
LOGON TRIGGERS


SELECT * FROM tblEmpData
select * from employeeaudit
---------------------------------------------------------------------
-- Create Employees table
select * from tblempdata

-- Create EmployeeAudit table with IDENTITY and AuditData
CREATE TABLE EmployeeAudit (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    AuditData NVARCHAR(255),
    AuditDate DATETIME DEFAULT GETDATE()
);

-- Create trigger to insert audit data on employee insert
CREATE OR ALTER TRIGGER trg_AuditEmployeeInsert
ON tblempdata
AFTER INSERT
AS
BEGIN
    INSERT INTO EmployeeAudit (AuditData, AuditDate)
    SELECT 
        'New employee with Id=' + CAST(Id AS NVARCHAR) + ' is added at ' + CONVERT(NVARCHAR, GETDATE(), 120),
        GETDATE()
    FROM inserted;
END;

-- Insert new employee to test
INSERT INTO tblempdata (Id, Name, Salary, Gender, DepartmentId)
VALUES (10, 'Jiva', 1800, 'Female', 3);

-- Check audit records
SELECT * FROM EmployeeAudit;

--DELETE TRIGGER
CREATE OR ALTER TRIGGER trg_TBLEMPLOYEE_FORDELETE
ON tblempdata
FOR DELETE
AS
BEGIN
    DECLARE @ID INT
    SELECT @ID = Id FROM deleted

    INSERT INTO EmployeeAudit (AuditData)
    VALUES ('An existing employee with Id = ' + CAST(@ID AS NVARCHAR(5)) +
            ' is deleted at ' + CONVERT(NVARCHAR, GETDATE(), 120))
END;

delete from tblempdata where id=1
select * from employeeaudit
select * from tblempdata

--PART 44 DML TRIGGERS

create trigger tr_tblemployee_ForUpdate
on tblempdata
for update
as begin
	select * from deleted --contains old data before the update action
	select * from inserted --new data before the update action
end

update tblempdata set name='james', salary=2000, gender='male'
where id=8

update tblempdata set name='james', salary=2000, gender='male'
where id=8

update tblempdata set name='tods', salary=2000, gender='female'
where id = 4

select * from tblempdata
select * from employeeaudit

---------------------------------------------------------------------------

CREATE OR ALTER TRIGGER tr_tblEmployee_ForUpdate
ON tblEmpdata
FOR UPDATE
AS
BEGIN
    DECLARE @Id INT
    DECLARE @OldName NVARCHAR(50), @NewName NVARCHAR(50)
    DECLARE @OldSalary INT, @NewSalary INT
    DECLARE @OldGender NVARCHAR(20), @NewGender NVARCHAR(20)
    DECLARE @OldDeptId INT, @NewDeptId INT
    DECLARE @AuditString NVARCHAR(1000)

    SELECT * INTO #TempTable FROM inserted

    WHILE EXISTS (SELECT Id FROM #TempTable)
    BEGIN
        SET @AuditString = ''

        SELECT TOP 1 
            @Id = Id,
            @NewName = Name,
            @NewGender = Gender,
            @NewSalary = Salary,
            @NewDeptId = DepartmentId
        FROM #TempTable

        SELECT
            @OldName = Name,
            @OldGender = Gender,
            @OldSalary = Salary,
            @OldDeptId = DepartmentId
        FROM deleted 
        WHERE Id = @Id

        SET @AuditString = 'Employee with Id = ' + CAST(@Id AS NVARCHAR(10)) + ' changed:'

        IF (@OldName <> @NewName)
            SET @AuditString = @AuditString + ' NAME from ' + @OldName + ' to ' + @NewName + ';'

        IF (@OldGender <> @NewGender)
            SET @AuditString = @AuditString + ' GENDER from ' + @OldGender + ' to ' + @NewGender + ';'

        IF (@OldSalary <> @NewSalary)
            SET @AuditString = @AuditString + ' SALARY from ' + CAST(@OldSalary AS NVARCHAR) + ' to ' + CAST(@NewSalary AS NVARCHAR) + ';'

        IF (@OldDeptId <> @NewDeptId)
            SET @AuditString = @AuditString + ' DEPARTMENT from ' + CAST(@OldDeptId AS NVARCHAR) + ' to ' + CAST(@NewDeptId AS NVARCHAR) + ';'

        INSERT INTO EmployeeAudit VALUES (@AuditString)

        DELETE FROM #TempTable WHERE Id = @Id
    END
END;

select * from tr_tblEmployee_ForUpdate

SELECT * FROM EmployeeAudit;
==================================================================================
--PART 45 INSTEAD OF INSERT TRIGGER
SELECT * FROM TBLEMPDATA
SELECT * FROM tblDepT

CREATE VIEW vWEmpployeeDetails
as
select id, name, gender, deptname
from tblempdata
join tbldept
on tbldept.deptid=tblempdata.departmentid

select * from vWEmpployeeDetails

insert into vWEmpployeeDetails values(7, 'valarie','Female','IT')

create trigger tr_vWempployeeDetails_InsteadofInsert
on vWEmpployeeDetails
instead of insert
as
begin
	select * from inserted
	select * from deleted
end
============================================================================
alter trigger tr_vWEmpployeeDetails_InsteadofInsert 
on vWEmpployeeDetails
Instead Of Insert as
Begin
Declare
@DeptId int
--Check if there is a valid DepartmentId
--for the given DepartmentName
Select @Deptid = DeptId
from tblDept join inserted
on inserted. DeptName = tblDept. DeptName
--If DepartmentId is null throw an error
--and stop processing 
if (@DeptId is null)
Begin
	Raiserror ('Invalid Department Name. Statement terminated', 16, 1)
	return
End
--Finally insert into tblEmployee table
Insert into tblEmpdata (Id, Name, Gender, DepartmentId)
Select Id, Name, Gender, @DeptId 
from inserted
End

--try executing this

insert into vWEmpployeeDetails values(7, 'valarie','Female','adafqef')
insert into vWEmpployeeDetails values(7, 'valarie','Female','IT')

--IMP: special tables inserted and deleted
------------------------------------------------------------------------------
--PART 46 INSTEAD OF UPDATE TRIGGERS IN SQL SERVER
SELECT * FROM TBLEMPDATA
SELECT * FROM tblDepT

CREATE VIEW vWEmplDetails
as select Id, name, Gender, DeptName
from tblempdata
join tbldept
on tblempdata.departmentId=tbldept.deptid

select * from vWempldetails

--UPDATE AFFECTING MULTIPLE BASE TABLES
update vWemplDetails set name='johnny', deptname='it' where id=1

--UPDATE AFFECTING JUST ONE BASE TABLES
update vWEmplDetails set DeptName='IT' where id=1

update vWEmplDetails set DeptName='HR' where id=3

Update tblDepartment set DeptName = 'HR' where DeptId = 3
==============================================================
create trigger tr_VWEmplDetails_InsteadofUpdate
on vWEmplDetails instead of update as
Begin
-- if EmployeeId is updated if (Update (Id) )
Begin
Raiserror ('Id cannot be changed', 16, 1)
Return
End
-- If DeptName is updated if (Update (DeptName) )
Begin
Declare @DeptId int
Select @DeptId = DeptId
from tblDept 
join inserted
on inserted. DeptName = tblDept. DeptName
if (@DeptId is NULL )
Begin
	Raiserror ('Invalid Department Name', 16, 1)
	Return
End
Update tblEmpldata set DepartmentId = @DeptId
from inserted 
join tblEmpDATA
on tblEmpDATA. Id = inserted. id
End
-- If gender is updated 
if (Update (Gender) )
Begin
	Update tblEmpDATA set Gender = inserted. Gender
	from inserted join tblEmployee
	on tblEmpDATA. Id = inserted. id
End
-- If Name is updated 
if (Update (Name) )
Begin
	Update tblEmpDATA set Name = inserted. Name
	from inserted join tblEmployee
	on tblEmpDATA. Id = inserted.id
	End
End

SELECT * FROM TBLEMPDATA
SELECT * FROM tblDepT
SELECT * FROM VWEmplDetails

update tbldept set Deptname='IT' where deptid=3

--UPDATE AFFECTING JUST ONE BASE TABLES
update vWEmplDetails set Deptname='IT' where Id=1

--UPDATE AFFECTING MULTIPLE BASE TABLES
update vWEmplDetails set name='jame', deptname='IT' where ID=1

--------------------------------------------------------------------
--PART 47 INSERT OF DELETE TRIGGERS IN SQL SERVER
SELECT * FROM TBLEMPDATA
SELECT * FROM tblDepT

INSERT INTO tblEmpData (Id, Name, Salary, Gender, DepartmentId)
VALUES (1, 'John', 5000, 'Male', 3);

SELECT * FROM tblEmpData ORDER BY Id;

create view vWemployedetails
as
select id, name, gender, deptname
from tblempdata
join tbldept
on tblempdata.departmentid=tbldept.deptid

select * from vWEmployeDetails
==================================================
delete from vWEmployeeDetails where id=1
--------------------------------------------------
create trigger tr_vWemployedetails_insteadofdelete
on vWemployedetails
instead of delete
as
begin
	delete tblempdata
		from tblempdata
		join deleted
		on tblempdata.id=deleted.id
		--subquery
		--delete from tblempdata
		--where id in (select id from deleted)
end
--OR--
alter trigger tr_vWemployedetails_insteadofdelete
on vWemployedetails
instead of delete
as
begin
	--delete tblempdata
		--from tblempdata
		--join deleted
		--on tblempdata.id=deleted.id
		
		--subquery
		delete from tblempdata
		where id in (select id from deleted)
end

delete from vWemployedetails where id in(3,4)
---------------------------------------------------
--part 48 derived tables and common table expressions in SQL SERVER
--USING VIEWS
Create view vWEmployeeCount as
Select DeptName, DepartmentId, COUNT (*)
as TotalEmployees
from tblEmpdata
join tbldept
on tblEmpdata.DepartmentId = tblDept.DeptId
group by DeptName, DepartmentId

select * from vWEmployeeCount

Select DeptName, TotalEmployees 
from vWEmployeeCount 
where TotalEmployees >= 2

select * from tblempdata
select * from tbldept

--USING TEMP TABLES

Select DeptName, DepartmentId, COUNT (*) as totalemployees
into #TempEmployeeCount
from tblEmpdata 
join tbldept
on tblEmpdata.DepartmentId = tblDept. Deptid
group by DeptName, DepartmentId 

select * from #TempEmployeeCount

Select DeptName, TotalEmployees 
From #TempEmployeeCount 
where TotalEmployees >= 2

drop table #TempEmployeeCount

--USING TABLE VARIABLE
Declare @tblEmployeeCount table (DeptName nvarchar (20), DepartmentId int, TotalEmployees int)

-- Insert data into the table variable
INSERT INTO @tblEmployeeCount
SELECT d.DeptName, d.DeptId AS DepartmentId, 
    COUNT(*) AS TotalEmployees
FROM 
    tblEmpData e
JOIN 
    tblDept d ON e.DepartmentId = d.DeptId
GROUP BY 
    d.DeptName, d.DeptId;

-- Query from the table variable
SELECT DeptName, TotalEmployees
FROM @tblEmployeeCount
WHERE TotalEmployees >= 2;

Insert @tblEmployeeCount
Select DeptName, DepartmentId, COUNT (*) as TotalEmployees from tblEmpdata join tblDept
on tblEmpdata. DepartmentId = tblDept. DeptId
group by DeptName, DepartmentId

Select DeptName, TotalEmployees
From @tblEmployeeCount
where TotalEmployees >= 2;

--Using Derived Tables
Select DeptName, TotalEmployees
from(
Select DeptName, DepartmentId, COUNT (*) 
as TotalEmployees 
from tblEmpdata
join tblDept
on tblEmpdata. DepartmentId = tblDept. DeptId
group by DeptName, DepartmentId
)
-- Declare the table variable
DECLARE @tblEmployeeCount TABLE (
    DeptName NVARCHAR(50),
    DepartmentId INT,
    TotalEmployees INT
);

--USING CTE
WITH EMPLOYEECOUNT(DEPTNAME, DEPARTMENTID, TOTALEMPOYEES)
AS
(
Select DeptName, Departmentid, count(*) as totalemployees
from tblempdata
join tbldept
on tblempdata.departmentid=tbldept.deptid
group by deptname, departmentid
)

select deptname, totalemployees
from employeecount
where totalemployees>=2

select * from tblempdata
select * from tbldept

--PART 49 CTE SQL SERVER


--PART 52 DATABASE NORMALIZATION
--PART 53 2NF AND 3NF

--PART 54 PIVOT IN SQL SERVER
CREATE TABLE tblProducttSales (
    SalesAgent NVARCHAR(50),
    SalesCountry NVARCHAR(50),
    SalesAmount INT
);

INSERT INTO tblProducttSales (SalesAgent, SalesCountry, SalesAmount) VALUES
('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),
('John', 'India', 540),
('John', 'UK', 120),
('David', 'UK', 220),
('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'UK', 660),
('Tom', 'US', 400),
('John', 'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'US', 360),
('David', 'UK', 140);

CREATE TABLE tblSalesSummary (
    SalesCountry NVARCHAR(50),
    SalesAgent NVARCHAR(50),
    Total INT
);

INSERT INTO tblSalesSummary (SalesCountry, SalesAgent, Total) VALUES
('India', 'David', 960),
('India', 'John', 970),
('India', 'Tom', 350),
('UK', 'David', 360),
('UK', 'John', 800),
('UK', 'Tom', 1340),
('US', 'David', 320),
('US', 'John', 540),
('US', 'Tom', 470);

SELECT * FROM tblproducttsales
select * from tblsalessummary

--GROUP BY QUERY
select salescountry, salesagent, sum(salesamount) as total from
tblproducttsales
group by salescountry, salesagent
order by salescountry, salesagent

--QUERY USING PIVOT
SELECT SALESAGENT, INDIA, US, UK FROM tblproducttsales
pivot(sum(salesamount) for salescountry in ([India],[us],[uk]))
as pivottable

SELECT SALESAGENT, INDIA, US, UK 
FROM tblproducttsales
pivot(sum(salesamount) 
or salescountry in ([India],[us],[uk]))
as pivottable

CREATE TABLE tblProductsSale (
    Id INT PRIMARY KEY,
    SalesAgent NVARCHAR(50),
    SalesCountry NVARCHAR(50),
    SalesAmount INT
);

INSERT INTO tblProductsSale (Id, SalesAgent, SalesCountry, SalesAmount) VALUES
(1, 'Tom',   'UK',    200),
(2, 'John',  'US',    180),
(3, 'John',  'UK',    260),
(4, 'David', 'India', 450),
(5, 'Tom',   'India', 350),
(6, 'John',  'India', 540),
(7, 'John',  'UK',    120),
(8, 'David', 'UK',    220),
(9, 'John',  'UK',    420),
(10,'David', 'US',    320);

select * from tblproductssale


SELECT SalesAgent, [India], [US], [UK]
FROM 
(
    SELECT SalesAgent, SalesCountry, SalesAmount
    FROM tblProductsSale
) AS SourceTable
PIVOT
(
    SUM(SalesAmount) 
    FOR SalesCountry IN ([India], [US], [UK])
) AS PivotTable;

--PART 55 ERROR HANDLING IN SQL SERVER
-- Create the table
CREATE TABLE tblProd (
    ProductId INT PRIMARY KEY,
    Name NVARCHAR(50),
    UnitPrice DECIMAL(10,2),
    QtyAvailable INT
);

-- Insert sample data
INSERT INTO tblProd (ProductId, Name, UnitPrice, QtyAvailable)
VALUES 
(1, 'Laptops', 2340, 100),
(2, 'Desktops', 3467, 50);


-- Create the ProductSales table
CREATE TABLE ProdSales (
    productSalesId INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT,
    QuantitySold INT
);

select * from tblprod
select * from prodsales

execute spSellProduct 1, 10

CREATE PROCEDURE spSellProduct
    @ProductId INT,
    @QuantityToSell INT
AS
BEGIN
    DECLARE @StockAvailable INT;

    -- Get the available stock
    SELECT @StockAvailable = QtyAvailable
    FROM tblprod
    WHERE ProductId = @ProductId;

    -- Check stock
    IF (@StockAvailable < @QuantityToSell)
    BEGIN
        RAISERROR('Not enough stock available', 16, 1);
        RETURN;
    END

    -- Proceed if enough stock
    BEGIN TRAN;

    -- Update available stock
    UPDATE tblprod
    SET QtyAvailable = QtyAvailable - @QuantityToSell
    WHERE ProductId = @ProductId;

    -- Insert record into ProductSales table
    INSERT INTO ProductSales (ProductId, QuantitySold)
    VALUES (@ProductId, @QuantityToSell);

    COMMIT TRAN;
END;

--PART 57 TRANSACTIONS IN SQL SERVER

select * from tblprod

BEGIN TRANSACTION
update tblprod set qtyavailable =400 where productid=1

--sql reads only commited data
set transaction isolation level read uncommitted -- now it will read the data
select * from tblprod

rollback transaction
commit transaction


CREATE TABLE tblPhysicalAddress (
    AddressId INT PRIMARY KEY,
    EmployeeNumber INT,
    HouseNumber NVARCHAR(10),
    StreetAddress NVARCHAR(100),
    City NVARCHAR(50),
    PostalCode NVARCHAR(20)
);

CREATE TABLE tblMailingAddress (
    AddressId INT PRIMARY KEY,
    EmployeeNumber INT,
    HouseNumber NVARCHAR(10),
    StreetAddress NVARCHAR(100),
    City NVARCHAR(50),
    PostalCode NVARCHAR(20)
);

INSERT INTO tblPhysicalAddress (AddressId, EmployeeNumber, HouseNumber, StreetAddress, City, PostalCode)
VALUES (1, 101, '#10', 'King Street', 'LONDOON', 'CR27DW');

INSERT INTO tblMailingAddress (AddressId, EmployeeNumber, HouseNumber, StreetAddress, City, PostalCode)
VALUES (1, 101, '#10', 'King Street', 'LONDOON', 'CR27DW');

select * from tblPhysicalAddress
select * from tblMailingAddress
execute spUpdateAddress

CREATE PROCEDURE spUpdateAddress
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE tblMailingAddress 
        SET City = 'LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        UPDATE tblPhysicalAddress 
        SET City = 'LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
    END CATCH
END;

alter PROCEDURE spUpdateAddress
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE tblMailingAddress 
        SET City = 'LONDON1'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        UPDATE tblPhysicalAddress 
        SET City = 'LONDON LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
		PRINT 'TRANSACTION ROLLED BACK'
    END CATCH
END;

--TRANSACTIONS IN SQL SERVER AND ACID TESTS
ACID-ATOMIC CONSISTENT ISOLATED DURABLE

CREATE TABLE ProductionSales (
    ProductSalesId INT PRIMARY KEY,
    ProductId INT,
    QuantitySold INT
);
INSERT INTO ProductionSales (ProductSalesId, ProductId, QuantitySold)
VALUES 
(1, 1, 10),
(2, 1, 10);

SELECT * FROM tblprod
select * from ProductionSales


SELECT * FROM tblprod where productid=2

begin tran
update tblprod set qtyavailable = 350 where productid=1

rollback tran

--PART 59 SUBQUERIES IN SQL

create table tblprduct
([id] int identity primary key,
[Name] nvarchar (50),
[Description] nvarchar (250)
)

Insert into tblprduct values ('TV', '52 inch black color LCD TV' )
Insert into tblprduct values ('Laptop', 'Very thin black color acer laptop' )
Insert into tblprduct values ('Desktop', 'HP high performance desktop')

CREATE TABLE tblProducsales (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT,
    UnitPrice INT,
    QuantitySold INT,
    FOREIGN KEY (ProductId) REFERENCES tblProducts(ProductId)
);

Insert into tblProducsales values (3, 450, 5)
Insert into tblProducsales values (2, 250, 7)
Insert into tblProducsales values (3, 450, 4)
Insert into tblProducsales values (3, 450, 9)

select * from tblprduct
select * from tblProducsales

select id, name, [description]
from tblprduct
where id not in(select distinct productid from tblProducsales)--sub query retuns only 1 column

--same query using JOINS
select tblprduct.id, name, [description]
from tblprduct
left join tblProducsales
on tblprduct.id= tblProducsales.productid
where tblProducsales.productid is null

--subquery in select list
SELECT 
    Name,
    (SELECT SUM(QuantitySold) 
     FROM tblProducsales 
     WHERE ProductId = P.Id) AS QtySold
FROM tblprduct P
ORDER BY Name;

--REPLACING USING JOIN
SELECT NAME, SUM(QUANTITYSOLD) AS QTYSOLD
from tblprduct
left join tblProducsales
on tblprduct.id=tblProducsales.productid
group by name

--CORRELATED SUBQUERY IN SQL

SELECT * FROM tblprduct
SELECT * FROM tblProducsales

select id, name, description
from tblprduct where id not in(select distinct productid from tblProducsales)

--correlated subquery--depending on outer query for its values
select name,
(select sum(quantitysold) from tblProducsales where productid=tblprduct.id) as qtysold
from tblprduct

--PART 61 CREATING A LARGE TABLE WITH RANDOM DATA FOR PERFORMANCE TESTING
--IF TABLE EXISTS DROP AND RECREATE

if (exists(select * 
			from information_schema.tables
			where table_name='tblProducsales'))

begin
drop table tblProducsales
end

if (exists (select * from information_schema.tables
where table_name='tblprduct'))
begin
drop table tblprduct
end

create table tblprduct
(
[id] int identity primary key,
[name] nvarchar(50),
[description] nvarchar(250)
)

create table tblProducsales
(
id int primary key identity,
productid int foreign key references tblprduct(id),
unitprice int,
quantitysold int
)

--INSERT SAMPLE DATA IN TBLPRODUCTS TABLE
decalre @id int
set @id=1

while(@id <= 10000)
begin
insert into tblprduct values('product -'+  cast(@id as nvarchar(20)),
'product -'+ cast(@id as nvarchar(20)) + 'description')

print @id
set @id=@id+1
end
--------------------------------------------------------------
DECLARE @id INT
SET @id = 1

WHILE (@id <= 10000)
BEGIN
    INSERT INTO tblprduct 
    VALUES (
        'product - ' + CAST(@id AS NVARCHAR(20)),
        'product - ' + CAST(@id AS NVARCHAR(20)) + ' description'
    )

    PRINT CAST(@id AS NVARCHAR(20))
    SET @id = @id + 1
END

select * from tblprduct
select * from tblProducsales

DECLARE @LL INT = 1
DECLARE @UL INT = 5

-- Generate a random number between @LL and @UL (inclusive)
SELECT ROUND(((@UL - @LL + 1) * RAND() + @LL - 0.5), 0) AS RandomNumber

DECLARE @LL INT = 1
DECLARE @UL INT = 5

DECLARE @rand INT

WHILE (1 = 1)
BEGIN
    -- Assign the generated random number to @rand
    SET @rand = ROUND(((@UL - @LL + 1) * RAND() + @LL - 0.5), 0)

    PRINT 'Random Number: ' + CAST(@rand AS NVARCHAR(10))

    -- If the random number is outside expected range, show error and break
    IF (@rand < @LL OR @rand > @UL)
    BEGIN
        PRINT 'Error - Out of range: ' + CAST(@rand AS NVARCHAR(10))
        BREAK
    END

    -- Optional: add delay to observe output
    WAITFOR DELAY '00:00:01'
END

--PART 62 WHAT TO CHOOSE PERFORM SUBQUERY OR JOINS


--PART 63 CURSORS IN SQL SERVER
CREATE TABLE tblProdcursors (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Description NVARCHAR(255)
);

INSERT INTO tblProdcursors (Id, Name, Description) VALUES
(1, 'Product - 1', 'Product - 1 Description'),
(2, 'Product - 2', 'Product - 2 Description'),
(3, 'Product - 3', 'Product - 3 Description'),
(4, 'Product - 4', 'Product - 4 Description'),
(5, 'Product - 5', 'Product - 5 Description');

CREATE TABLE tblProdSalescursors (
    Id INT PRIMARY KEY,
    ProductId INT,
    UnitPrice INT,
    QuantitySold INT
);

INSERT INTO tblProdSalescursors (Id, ProductId, UnitPrice, QuantitySold) VALUES
(1, 5, 5, 3),
(2, 4, 23, 4),
(3, 2, 31, 2),
(4, 4, 93, 9),
(5, 5, 72, 5);

select * from tblProdcursors
select * from tblProdSalescursors

DECLARE @ProductId INT
DECLARE @Name NVARCHAR(30)

DECLARE ProductCursor CURSOR FOR
SELECT Id, Name FROM tblProdcursors WHERE Id <= 1000

OPEN ProductCursor

FETCH NEXT FROM ProductCursor INTO @ProductId, @Name

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Id = ' + CAST(@ProductId AS NVARCHAR(10)) + ', Name = ' + ISNULL(@Name, 'NULL')

    FETCH NEXT FROM ProductCursor INTO @ProductId, @Name
END

CLOSE ProductCursor
DEALLOCATE ProductCursor

DECLARE ProductCursor CURSOR FOR
SELECT TOP 1000 Id, Name FROM tblProdcursors ORDER BY Id

--PART 64 REPLACING CURSORS USING JOINS
SELECT TOP 10 * FROM tblProdcursors
SELECT TOP 10 * FROM tblProdSalescursors

select count(*) from tblProdcursors
select count(*) from tblProdSalescursors

SELECT name, unitprice
FROM tblProdcursors
JOIN tblProdSalescursors ON tblProdcursors.id = tblProdSalescursors.productid
WHERE 
    name = 'product - 55'
    OR name = 'product - 65'
    OR name LIKE 'product - 100%';


--PART 65 LIST ALL TABLES IN SQL SERVER DATABASE USIGN A QUERY

SELECT * FROM SYSOBJECTS WHERE XTYPE = 'U' --USER TABLE
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'FN' --SCALAR FUNCTION
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'P' --STORED PROCEDURE
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'V' --VIEWS

SELECT DISTINCT XTYPE FROM SYSOBJECTS  --AVAILABLE IN SAMPLE DATABASE
SELECT * FROM SYS.TABLES
SELECT * FROM SYS.VIEWS
SELECT * FROM SYS.PROCEDURES

SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM INFORMATION_SCHEMA.VIEWS
SELECT * FROM INFORMATION_SCHEMA.ROUTINES

--PART 66 WRITING RE RUNNABLE SQL SERVER SCRIPTS

CREATE TABLE TBLEMP2
(ID INT IDENTITY PRIMARY KEY,
NAME VARCHAR(100),
GENDER NVARCHAR(10),
DATEOFBIRTH DATETIME
) -- IF YOU CREATE THE SAME AND IT EXISTS ALREADY

USE [SAMPLE];

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TBLEMP2')
BEGIN
    CREATE TABLE TBLEMP2
    (
        ID INT IDENTITY PRIMARY KEY,
        NAME NVARCHAR(100),
        GENDER NVARCHAR(10),
        DATEOFBIRTH DATETIME
    );
    PRINT 'TABLE TBLEMP2 SUCCESSFULLY CREATED';
END
ELSE
BEGIN
    PRINT 'TABLE TBLEMP2 ALREADY EXISTS';
END
---------------------------------------------------
IF OBJECT_ID('TBLEMP2') IS NULL
BEGIN
    -- CREATE TABLE SCRIPT HERE
    PRINT 'TABLE TBLEMP2 SUCCESSFULLY CREATED'
END
ELSE
BEGIN
    PRINT 'TABLE TBLEMP2 ALREADY EXISTS'
END
--------------------------------------------------
IF OBJECT_ID('TBLEMP2') IS not NULL
BEGIN
    -- CREATE TABLE SCRIPT HERE
    drop table TBLEMP2
END
create table TBLEMP2
(
id int identity primary key,
name nvarchar(100),
gender nvarchar(10),
dateofbirth datetime
)

--check for existense of table before drop

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE COLUMN_NAME = 'emailaddress' 
      AND TABLE_NAME = 'TBLEMP2' 
      AND TABLE_SCHEMA = 'dbo'
)
BEGIN
    ALTER TABLE TBLEMP2
    ADD emailaddress NVARCHAR(50);
END
ELSE
BEGIN
    PRINT 'Column emailaddress already exists';
END


IF col_length('TBLEMP2','emailaddress') IS not NULL
BEGIN
    print 'column already exists'
end
else
begin
    print 'column does not exists'
end

--PART 68 ALTER DATABASE TABLE COLUMNS WITHOUT DROPPING TABLES

CREATE TABLE tblEmp3 (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Gender NVARCHAR(10),
    Salary INT
);
INSERT INTO tblEmp3 (Id, Name, Gender, Salary) VALUES
(1, 'Sara Nani', 'Female', 4500),
(2, 'James Hist', 'Male', 5300),
(3, 'Mary Jane', 'Female', 6200),
(4, 'Paul Sensit', 'Male', 4200),
(5, 'Mike Jen', 'Male', 5500);

select * from tblemp3

select gender, sum(salary) as total
from tblemp3
group by gender

--PART 68 OPTIONAL PARAMETERS IN SQL SERVER STORED PROCEDURES
CREATE TABLE tblEmp4 (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(50),
    Email NVARCHAR(50),
    Age INT,
    Gender NVARCHAR(50),
    HireDate DATE
);

INSERT INTO tblEmp4 VALUES 
('Sara Nan', 'Sara.Nan@test.com', 35, 'Female', '1999-04-04');

INSERT INTO tblEmp4 VALUES 
('James Histo', 'James.Histo@test.com', 33, 'Male', '2008-07-13');

INSERT INTO tblEmp4 VALUES 
('Mary Jane', 'Mary.Jane@test.com', 28, 'Female', '2005-11-11');

INSERT INTO tblEmp4 VALUES 
('Paul Sensit', 'Paul.Sensit@test.com', 29, 'Male', '2007-10-23');

SELECT * FROM tblEmp4

alter PROC SPSEARCHEMPLOYEES
@NAME NVARCHAR(50) =null,
@Email NVARCHAR(50) = null,
@Gender NVARCHAR(50)=null,
@Age int=null
as
begin
select * from tblEmp4
where 
(name=@name or @name is null)and 
(gender=@gender or @gender is null) and
(email=@email or @email is null) and
(age=@age or @age is null)
end

execute SPSEARCHEMPLOYEES
execute SPSEARCHEMPLOYEES @gender='male'
execute SPSEARCHEMPLOYEES @gender='male', @age='33'

--PART 69 MERGE IN SQL SERVER
CREATE TABLE StudentSource (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100)
);

CREATE TABLE StudentTarget (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100)
);
-- Insert into StudentSource
INSERT INTO StudentSource (Id, Name) VALUES
(1, 'Mike'),
(2, 'Sara');

-- Insert into StudentTarget
INSERT INTO StudentTarget (Id, Name) VALUES
(1, 'Mike'),
(3, 'John');

select * from StudentSource
select * from StudentTarget

merge studenttarget as T
using studentsource as S
on T.ID=S.ID
when matched then
update set t.name=s.name
when not matched by target then
insert (id, name) values(s.id,s.name)
when not matched by source then
delete;

--PART 70 SQL SERVER CONSURRENT TRANSACTIONS
CREATE TABLE Accounts (
    Id INT PRIMARY KEY,
    AccountName NVARCHAR(100),
    Balance INT
);
INSERT INTO Accounts (Id, AccountName, Balance) VALUES
(1, 'Mark', 1000),
(2, 'Mary', 1000);

select * from Accounts
--transfer 100$ from mark to mary account
begin try
begin transaction
update accounts set balance=balance - 100 where id=1
update accounts set balance=balance + 100 where id='A'
commit transaction
print 'transaction commited'
end try
begin catch
rollback transaction
print 'transaction rolled back'
end catch

--PART 71 SQL SERVER DIRTY READ EXAMPLE
CREATE TABLE ProductInventory (
    Id INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    ItemsInStock INT
);
INSERT INTO ProductInventory (Id, ProductName, ItemsInStock) VALUES
(1, 'iPhone', 10);

--transaction1 
SELECT * FROM ProductInventory

select * from ProductInventory

begin tran
update productinventory set itemsinstock =9
where id=1

--bill the customer
waitfor delay '00:00:15'
rollback transaction

--transaction 2
select * from ProductInventory where id=1

--2nd transaction will execute after the 1st transaction

--part 72 sql server lost update problem
select * from ProductInventory

-- Transaction 1
BEGIN TRANSACTION;

DECLARE @ItemsInStock INT;

SELECT @ItemsInStock = ItemsInStock
FROM ProductInventory
WHERE Id = 1;

WAITFOR DELAY '00:00:10';  -- Simulate some processing delay

SET @ItemsInStock = @ItemsInStock - 1;

UPDATE ProductInventory
SET ItemsInStock = @ItemsInStock
WHERE Id = 1;

PRINT 'Items in stock after update: ' + CAST(@ItemsInStock AS NVARCHAR(10));

COMMIT TRANSACTION;


--transaction1
select * from ProductInventory

update ProductInventory set itemsinstock=10
set transaction isolation level repeatable read

BEGIN TRANSACTION;

DECLARE @ItemsInStock INT;

SELECT @ItemsInStock = ItemsInStock
FROM ProductInventory
WHERE Id = 1;

WAITFOR DELAY '00:00:10';  -- Simulate some processing delay

SET @ItemsInStock = @ItemsInStock - 1;

UPDATE ProductInventory
SET ItemsInStock = @ItemsInStock
WHERE Id = 1;

PRINT 'Items in stock after update: ' + CAST(@ItemsInStock AS NVARCHAR(10));

COMMIT TRANSACTION;

set transaction isolation level repeatable read


-- Transaction 2
BEGIN TRANSACTION;

DECLARE @ItemsInStock INT;

SELECT @ItemsInStock = ItemsInStock
FROM ProductInventory
WHERE Id = 1;

WAITFOR DELAY '00:00:10';  -- Simulate some processing delay

SET @ItemsInStock = @ItemsInStock - 1;

UPDATE ProductInventory
SET ItemsInStock = @ItemsInStock
WHERE Id = 1;

--part 73 NON REPEATABLE READ EXAMPLE IN SQL SERVER

select * from ProductInventory

--PART 74 PHANTOM READ EXAMPLE IN SQL SERVER
one transaction executes query twice & it gets different number of rows
in the result set each time

--PART 75 SNAPSHOT ISOLATION LEVEL IN SQL SERVER
--does not have concurrency effects
--transaction 1
set transaction isolation level serializable

begin transaction
update productinventory
set itemsinstock=5 where id=1

commit transaction

--transaction 2
set transaction isolation level serializable

begin transaction
select itemsinstock from productinventory where id=1

commit transaction
-----------------------------------------------------------------------
--part 75 read committed snapshot isolation level in sql server
--transaction 1
set transaction isolation level read committed
begin transaction
update productinventory
set itemsinstock = 5 where id=1

commit transaction

select * from productinventory
============================================================
alter database sampledb set read_committed_snapshot on
--transaction 2
set transaction isolation level read committed
begin transaction
select itemsinstock from productinventory where id=1
commit transaction

select * from productinventory
============================================================
--PART 76 DIFF BETWEEN SNAPSHOT ISOLATION AND READ COMMITTED SNAPSHOT

ALTER DATABASE SAMPLEDB
SET ALLOW_SNAPSHOT_ISOLATION OFF

ALTER DATABASE SAMPLEDB
SET READ_COMMITTED_SNAPSHOT ON

--TRANSACTION 1
set transaction isolation level read SNAPSHOT
begin transaction
update productinventory
set itemsinstock = 8 where id=1

commit transaction

select * from productinventory

--TRANSACTION 1
set transaction isolation level read SNAPSHOT
begin transaction
update productinventory
set itemsinstock = 8 where id=1

commit transaction
=================================================
--PART 77 SQL SERVER DEADLOCK EXAMPLE

SELECT * FROM TABLEA
SELECT * FROM TABLEB

--TRANSACTION 1
begin transaction
update TABLEA set name='raj transaction 1'
where id=1

update tableB set name='ben transaction 1'
where id=1

commit transaction

--TRANSACTION 2
begin transaction
update TableB set name='raj transaction 2'
where id=1

update TableA set name='ben transaction 2'
where id=1

commit transaction

--ERROR Transaction (Process ID 54) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. 
--Return the transaction.

--PART 78 SQL SERVER DEADLOCK VICTIM SELECTION
-- Create TableA
CREATE TABLE TableA1 (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50)
);

-- Insert 5 rows into TableA
INSERT INTO TableA1 (ID, Name) VALUES
(1, 'John'),
(2, 'Alice'),
(3, 'Robert'),
(4, 'Nina'),
(5, 'Steve');

-- Create TableB
CREATE TABLE TableB1 (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50)
);

-- Insert 1 row into TableB
INSERT INTO TableB1 (ID, Name) VALUES
(1, 'Mary');

SELECT * FROM TABLEA1
SELECT * FROM TABLEB1

--TRANS1
BEGIN TRAN

UPDATE TABLEA1 SET NAME=NAME + 'TRANSACTION 1'
WHERE ID IN(1,2,3,4,5)

UPDATE TABLEB1 SET NAME=NAME + 'TRANSACTION 1'
WHERE ID=1

COMMIT TRANSACTION

--TRANSACTION 2

BEGIN TRAN

UPDATE TABLEB1 SET NAME=NAME + 'TRANSACTION 2'
WHERE ID=1

UPDATE TABLEA1 SET NAME=NAME + 'TRANSACTION 2'
WHERE ID IN (1,2,3,4,5)

COMMIT TRANSACTION
==================================================

TRUNCATE TABLE TABLEA1
TRUNCATE TABLE TABLEB1


--TRANS1
BEGIN TRAN

UPDATE TABLEA1 SET NAME=NAME + 'TRANSACTION 1'
WHERE ID IN(1,2,3,4,5)

UPDATE TABLEB1 SET NAME=NAME + 'TRANSACTION 1'
WHERE ID=1

COMMIT TRANSACTION

SELECT * FROM TABLEA1
SELECT * FROM TABLEB1


--PART 79 LOGGING DEADLOCKS IN SQL SERVER
DBCC TRACEON(1222, -1)--SET SQL SERVER TRACE FLAG 1222
DBCC TRACESTATUS(1222, -1) --CHECK THE STATUS OF THE TRACE FLAG
DBCC TRACEOFF(1222) --TURN OFF THE TRACE FLAG

EXECUTE SP_READERRORLOG

--PART 80 SQL SERVER DEADLOCK ANALYSIS AND PREVENTION

--PART 81 CAPTURING DEADLOCKS IN SQL PROFILER

--PART 82 SQL SERVER DEADLOCKK ERROR HANDLING

--PART 84 HANDLING DEADLOCKS IN ADO NET

--PART 85 RETRY LOGIC FOR DEADLOCK EXCEPTIONS

--PART 86 HOW TO FIND BLOCKING QUERIES IN SQL SERVER
DBCC OPENTRAN

--PART 87 SQL SRVER EXCEPT OPERATOR

--PART 88 DIFF BETWEEN EXCEPT AND NOT IN SQL SERVER
EXCEPT  FILTERS duplicates left query that arent in the right query 
NOT IN WILL NOT FILTER
--PART 89 INTERSECT OPERATOR IN SQL SERVER
DUPLICATES ARE FILTERED OUT RETURNS ONLY DISTINCT ROWS
--PART 90 DIFFERENCE BETWEEN UNION INTERSECT AND EXCEPT IN SQL SERVER
union- returns all unique rows both left and right
intersect - retrieves common unique rows from both
except-- returns rows fromleft query that arent in right query

--PART 91 CROSS APPLY AND OUTER APPLY IN SQL SERVER
SELECT * FROM DEPARTMENT D
-- Create Department table

CREATE TABLE Departmenttable (
    ID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- Insert values into Department table
INSERT INTO Departmenttable (ID, DepartmentName) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Payroll'),
(4, 'Administration'),
(5, 'Sales');-- You can change or remove this if only 4 departments are needed

-- Step 1: Create the table
CREATE TABLE Employeestable (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

-- Step 2: Insert the records
INSERT INTO Employeestable (ID, Name, Gender, Salary, DepartmentID) VALUES
(1, 'Mark', 'Male',   50000, 1),
(2, 'Mary', 'Female', 60000, 3),
(3, 'Steve', 'Male',  45000, 2),
(4, 'John', 'Male',   56000, 1),
(5, 'Sara', 'Female', 39000, 2);

select * from Employeestable
select * from Departmenttable

SELECT *
FROM DepartmentTable d
INNER JOIN EmployeesTable e
ON d.ID = e.DepartmentID;

SELECT *
FROM DepartmentTable d
left JOIN EmployeesTable e
ON d.ID = e.DepartmentID;

SELECT d.departmentname, e.name, e.gender, e.salary
from DepartmentTable d
INNER JOIN EmployeesTable e
ON d.ID = e.DepartmentID;

SELECT d.departmentname, e.name, e.gender, e.salary
from DepartmentTable d
left JOIN EmployeesTable e
ON d.ID = e.DepartmentID;

create function fn_getemployeesbydepartmentid(@departmentid int)
returns table
as 
return
(
select * from EmployeesTable
where departmentid=@departmentid
)

select * from fn_getemployeesbydepartmentid(1)

SELECT d.departmentname, e.name, e.gender, e.salary
from DepartmentTable d
cross apply fn_getemployeesbydepartmentid(d.id) e
--ON d.ID = e.DepartmentID;

SELECT d.departmentname, e.name, e.gender, e.salary
from DepartmentTable d
outer apply fn_getemployeesbydepartmentid(d.id) e

--cross apply returns matching rows
--outer apply returns matching+non matching rows

--PART 92 DDL TRIGGERS IN SQL SERVER
CREATE TRIGGER trmyfirsttrigger
on database
for create_Table
as begin
print'new table created'
end

create table test(id int)


ALTER TRIGGER trMyFirstTrigger
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    PRINT 'You have just created, altered, or dropped a table.'
END;
GO

create table test(id int)
drop table test

ALTER TRIGGER trMyFirstTrigger
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	rollback
    PRINT 'you cannot create, alter or drop a table'
END;
GO

create table test(id int)
drop table test

disable trigger trMyFirstTrigger on database
enable trigger trMyFirstTrigger on database
drop trigger trMyFirstTrigger on database

alter TRIGGER trMyFirstTrigger
ON DATABASE
FOR rename
AS
BEGIn
    PRINT 'you renamed the trigger'
END;
GO

sp_rename 'test', 'newtest'

--PART 93 SERVER SCOPED DDL TRIGGERS

CREATE TRIGGER tr_SERVERSCOPETRIGGER
on database
for create_Table, ALTER_TABLE, DROP_tABLE
as 
begin
	ROLLBACK
	print'YOU CANNOT CREATE, ALTER OR DROP A TABLE'
end

--CREATE TABLE
CREATE TABLE TEST(ID INT)

--PART 94 SQL SERVER TRIGGER EXECUTION ORDER

-- Database-scope DDL trigger
CREATE TRIGGER tr_DATABASESCOPETRIGGER
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS 
BEGIN
    PRINT 'DATABASE SCOPE TRIGGER'
END;
GO

-- Server-scope DDL trigger
CREATE TRIGGER tr_SERVERSCOPETRIGGER
ON ALL SERVER
FOR CREATE_TABLE
AS 
BEGIN
    PRINT 'SERVER SCOPE TRIGGER'
END;
GO

CREATE TABLE TEST(ID INT)

CREATE TRIGGER tr_DATABASESCOPETRIGGER3
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS 
BEGIN
    PRINT 'DATABASE SCOPE TRIGGER - 3'
END;
GO

CREATE TRIGGER tr_DATABASESCOPETRIGGER2
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS 
BEGIN
    PRINT 'DATABASE SCOPE TRIGGER - 2'
END;
GO

CREATE TRIGGER tr_DATABASESCOPETRIGGER1
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS 
BEGIN
    PRINT 'DATABASE SCOPE TRIGGER - 1'
END;
GO

DROP TABLE TestTriggerExecution;
-- Example DDL statement that will fire the database triggers
CREATE TABLE TriggerTestTable (
    ID INT
);

SELECT name, type_desc, parent_class_desc, create_date
FROM sys.triggers
WHERE parent_class_desc = 'DATABASE';

EXEC sp_settriggerorder
    @triggername = 'tr_databasescopetrigger1',
    @order = 'first',
    @stmttype = 'create_table',
    @namespace = 'database';
GO

EXEC sp_settriggerorder
    @triggername = 'tr_databasescopetrigger2',
    @order = 'last',
    @stmttype = 'create_table',
    @namespace = 'database';
GO

create table test(id int)

--PART 95 AUDIT TABLE CHANGES IN SQL SERVER
CREATE TRIGGER tr_Audittablechanges
ON all server
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS 
BEGIN
    select eventdata()
END;

create table mytable(id int, name varchar(50))

--PART 96 LOGON TRIGGERS IN SQL SERVER
SELECT * FROM SYS.dm_exec_sessions

SELECT 
    is_user_process,
    original_login_name,
    *
FROM 
    sys.dm_exec_sessions
ORDER BY 
    login_time DESC;

SP_READERRORLOG

--PART 97 SELECT INTO SQL SERVER
select * from DepartmentTable
select * from employeestable

select * into employeesbackup from employeestable
select * from employeesbackup
-- Step 1: Disable the DDL trigger temporarily (if you have one that blocks CREATE TABLE)
DISABLE TRIGGER tr_databasescopetrigger1 ON DATABASE;
GO

-- Step 2: Use SELECT INTO to copy the table
SELECT *
INTO EmployeesBackup
FROM EmployeesTable;
GO

-- Step 3: Re-enable the DDL trigger
ENABLE TRIGGER tr_databasescopetrigger1 ON DATABASE;
GO

--🔹 Step 1: Check if the trigger exists and where
SELECT name, parent_class_desc, is_disabled
FROM sys.triggers
WHERE parent_class_desc = 'DATABASE';
--🔹 Step 1: Check if the trigger exists and where
DISABLE TRIGGER trmyfirsttrigger ON DATABASE;
DISABLE TRIGGER tr_DATABASESCOPETRIGGER ON DATABASE;
DISABLE TRIGGER tr_DATABASESCOPETRIGGER2 ON DATABASE;
DISABLE TRIGGER tr_DATABASESCOPETRIGGER3 ON DATABASE;
GO
--✅ Now run your SELECT INTO statement:
SELECT *
INTO EmployeesBackup
FROM EmployeesTable;
GO


-- Step 1: Create a backup table with selected columns
SELECT id, name, gender
INTO EmployeesBackup
FROM EmployeesTable;
GO

-- Step 2: View the contents of the newly created table
SELECT *
FROM EmployeesBackup;
GO

DROP TABLE EmployeesBackup;
GO

--PART 98  DIFFERENCE BETWEEN WHERE AND HAVING IN SQL SERVER
CREATE TABLE SALES (
    Product VARCHAR(50),
    SaleAmount INT
);
INSERT INTO SALES (Product, SaleAmount)
VALUES 
('IPHONE', 500),
('LAPTOP', 800),
('IPHONE', 1000),
('SPEAKER', 400),
('LAPTOP', 600);

SELECT * FROM SALES

SELECT PRODUCT, SUM(SALEAMOUNT) AS TOTALSALES
FROM SALES
GROUP BY PRODUCT

SELECT PRODUCT, SUM(SALEAMOUNT) AS TOTALSALES
FROM SALES
GROUP BY PRODUCT
HAVING SUM(SALEAMOUNT)>1000

WHERE--FILTERS ROWS BEFORE AGGREGATE CALCULATIONS
HAVING--FILTERS AFTER AGGREGATE CALCULATIONS

SELECT PRODUCT, SUM(SALEAMOUNT) AS TOTALSALES
FROM SALES
WHERE PRODUCT IN ('IPHONE', 'SPEAKER')
GROUP BY PRODUCT;

SELECT PRODUCT, SUM(SALEAMOUNT) AS TOTALSALES
FROM SALES
GROUP BY PRODUCT
HAVING PRODUCT IN ('IPHONE', 'SPEAKER');

SELECT PRODUCT, SUM(SALEAMOUNT) AS TOTALSALES
FROM SALES
WHERE PRODUCT IN ('IPHONE', 'SPEAKER')
GROUP BY PRODUCT
HAVING SUM(SALEAMOUNT) > 1000;

--PART 99 TABLE VALUED PARAMETERS IN SQL SERVER
CREATE TABLE EMP5
(ID INT PRIMARY KEY,
NAME VARCHAR(50),
GENDER VARCHAR(10)
)
GO

SELECT * FROM EMP5

CREATE TYPE EMPTABLETYPE AS TABLE
(ID INT PRIMARY KEY,
NAME VARCHAR(50),
GENDER VARCHAR(10)
)
GO

--PART 100 SEND DATATABLE AS PARAMETER TO STORED PROCEDURE

--PART 101 GROUPING SETS IN SQL SERVER
CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10),
    Salary INT,
    Country NVARCHAR(50)
);

INSERT INTO Employees (Id, Name, Gender, Salary, Country) VALUES
(1, 'Mark',      'Male',   5000, 'USA'),
(2, 'John',      'Male',   4500, 'India'),
(3, 'Pam',       'Female', 5500, 'USA'),
(4, 'Sara',      'Female', 4000, 'India'),
(5, 'Todd',      'Male',   3500, 'India'),
(6, 'Mary',      'Female', 5000, 'UK'),
(7, 'Ben',       'Male',   6500, 'UK'),
(8, 'Elizabeth', 'Female', 7000, 'USA'),
(9, 'Tom',       'Male',   5500, 'UK'),
(10,'Ron',       'Male',   5000, 'USA');

SELECT * FROM Employees

SELECT Country, Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Country, Gender;
--------------------------------------------------
SELECT Country, Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Country, Gender

UNION ALL

SELECT Country, NULL AS Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Country;
--------------------------------------------------------------
SELECT Country, Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Country, Gender

UNION ALL

SELECT Country, NULL AS Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Country

UNION ALL

SELECT NULL AS Country, Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Gender

UNION ALL

SELECT NULL AS Country, NULL AS Gender, SUM(Salary) AS TotalSalary
FROM Employees;
------------------------------------------------------------------
--PART 102 ROLLUP IN SQL SERVER
SELECT COUNTRY, SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY ROLLUP(COUNTRY)

SELECT COUNTRY, SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY COUNTRY WITH ROLLUP
-----------------------------------------------
SELECT COUNTRY, SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY COUNTRY

UNION ALL

SELECT NULL, SUM(SALARY) AS TOTALSALARY
FROM Employees
-------------------------------------------------
SELECT COUNTRY, SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY GROUPING SETS
(
(COUNTRY), ()
)

--PART 103 CUBE IN SQL SERVER
SELECT COUNTRY, SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY CUBE(COUNTRY, GENDER)

--PART 104 DIFF BETWEEN CUBE AND ROLLUP INSQL SERVER
CREATE TABLE SalesData (
    Continent NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    SaleAmount INT
);

INSERT INTO SalesData (Continent, Country, City, SaleAmount) VALUES
('Asia',   'India',          'Bangalore',   1000),
('Asia',   'India',          'Chennai',     2000),
('Asia',   'Japan',          'Tokyo',       4000),
('Asia',   'Japan',          'Hiroshima',   5000),
('Europe', 'United Kingdom', 'London',      1000),
('Europe', 'United Kingdom', 'Manchester',  2000),
('Europe', 'France',         'Paris',       4000),
('Europe', 'France',         'Cannes',      5000);

SELECT * FROM SalesData

SELECT Continent, Country, City, SUM(SaleAmount) AS TotalSales
FROM SalesData
GROUP BY ROLLUP(Continent, Country, City); --AGGREGATION DONE BASED ON HIERACHY RELATIONSHIP

SELECT Continent, Country, City, SUM(SaleAmount) AS TotalSales
FROM SalesData
GROUP BY CUBE(Continent, Country, City);--ALL POSSIBLE COMBINATIONS

SELECT Continent, SUM(SaleAmount) AS TotalSales
FROM SalesData
GROUP BY CUBE(Continent)

SELECT Continent, SUM(SaleAmount) AS TotalSales
FROM SalesData
GROUP BY ROLLUP(Continent)

--PART 105 GROUPING FUNCTION SQL SERVER
CREATE TABLE GroupingResults (
    Continent NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    TotalSales INT,
    GP_Continent INT,
    GP_Country INT,
    GP_City INT
);

INSERT INTO GroupingResults VALUES
('Asia',   'India',          'Bangalore',   1000, 0, 0, 0),
('Asia',   'India',          'Chennai',     2000, 0, 0, 0),
('Asia',   'India',          NULL,          3000, 0, 0, 1),
('Asia',   'Japan',          'Hiroshima',   5000, 0, 0, 0),
('Asia',   'Japan',          'Tokyo',       4000, 0, 0, 0),
('Asia',   'Japan',          NULL,          9000, 0, 0, 1),
('Asia',   NULL,             NULL,         12000, 0, 1, 1),
('Europe', 'France',         'Paris',       4000, 0, 0, 0),
('Europe', 'France',         NULL,          9000, 0, 0, 1),
('Europe', 'United Kingdom', 'London',      1000, 0, 0, 0),
('Europe', 'United Kingdom', 'Manchester',  2000, 0, 0, 0),
('Europe', 'United Kingdom', NULL,          3000, 0, 0, 1),
('Europe', NULL,             NULL,         12000, 0, 1, 1),
(NULL,     NULL,             NULL,         24000, 1, 1, 1);

SELECT * FROM GroupingResults

SELECT 
    Continent, 
    Country,
    City, 
    SUM(SaleAmount) AS TotalSales,
    GROUPING(Continent) AS GP_Continent,
    GROUPING(Country) AS GP_Country,
    GROUPING(City) AS GP_City
FROM SalesData
GROUP BY ROLLUP(Continent, Country, City);

SELECT 
  CASE WHEN GROUPING(Continent) = 1 THEN 'all' ELSE ISNULL(Continent, 'unknown') END AS Continent,
  CASE WHEN GROUPING(Country) = 1 THEN 'all' ELSE ISNULL(Country, 'unknown') END AS Country,
  CASE WHEN GROUPING(City) = 1 THEN 'all' ELSE ISNULL(City, 'unknown') END AS City,
  SUM(SaleAmount) AS TotalSales
FROM SalesData
GROUP BY ROLLUP(Continent, Country, City);

select 
ISNULL(Continent, 'ALL') as continent,
ISNULL(Country, 'ALL') as Country,
ISNULL(City, 'ALL') as City,
sum(SaleAmount) as totalsales
from SalesData
group by rollup(continent, country, city)

select * from SalesData

--PART 106 GROUPING ID FUNCTIONIN SQL SERVER
SELECT 
    Continent, 
    Country, 
    City, 
    SUM(SaleAmount) AS TotalSales,
    GROUPING(Continent) + GROUPING(Country) + GROUPING(City) AS Groupings
FROM 
    SalesData
GROUP BY 
    ROLLUP(Continent, Country, City);

--PART 107 DEBUGGING SQL SERVER STORED PROCEDURES
--ALT+F5
--STEP INTO
--STEP OVER
--STEP OUT

--PART 108 OVER CLAUSE IN SQL SERVER
CREATE TABLE emp1 (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    Salary DECIMAL(10, 2)
);

INSERT INTO emp1 (ID, Name, Gender, Salary) VALUES
(1, 'Alice',   'Female', 55000),
(2, 'Bob',     'Male',   60000),
(3, 'Charlie', 'Male',   48000),
(4, 'Diana',   'Female', 62000),
(5, 'Ethan',   'Male',   51000),
(6, 'Fiona',   'Female', 58000),
(7, 'George',  'Male',   47000),
(8, 'Hannah',  'Female', 53000),
(9, 'Ian',     'Male',   49000),
(10,'Julia',   'Female', 61000);

SELECT * FROM emp1

SELECT GENDER, COUNT(*) AS GENDERTOTAL, AVG(SALARY) AS AVGSAL,
MIN(SALARY)AS MINSAL,MAX(SALARY) AS MAXSAL
FROM EMP1
GROUP BY GENDER

SELECT 
    E.Name, 
    E.Salary, 
    E.Gender, 
    GENDERS.GenderTotal, 
    GENDERS.AvgSal, 
    GENDERS.MinSal, 
    GENDERS.MaxSal
FROM Emp1 E
INNER JOIN (
    SELECT 
        Gender, 
        COUNT(*) AS GenderTotal, 
        AVG(Salary) AS AvgSal,
        MIN(Salary) AS MinSal,
        MAX(Salary) AS MaxSal
    FROM Emp1
    GROUP BY Gender
) AS GENDERS
ON E.Gender = GENDERS.Gender;

SELECT 
    Name, 
    Salary, 
    Gender,
    COUNT(Gender) OVER (PARTITION BY Gender) AS GendersTotal,
    AVG(Salary) OVER (PARTITION BY Gender) AS AvgSal,
    MIN(Salary) OVER (PARTITION BY Gender) AS MinSal,
    MAX(Salary) OVER (PARTITION BY Gender) AS MaxSal
FROM emp1;

--PART 109 ROW NUMBER FUNCTION SQL SERVER
SELECT 
    Name, 
    Gender, 
    Salary,
    ROW_NUMBER() OVER (ORDER BY Gender) AS RowNumber
FROM Employees;

SELECT 
    Name, 
    Gender, 
    Salary,
    ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY GENDER) AS RowNumber
FROM Employees;

--PART 110 RANK AND DENSE RANK IN SQL SERVER
SELECT * FROM Employees

SELECT 
    Name, 
    Gender, 
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS [Rank],
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees;

SELECT 
    Name, 
    Gender, 
    Salary,
    RANK() OVER (PARTITION BY GENDER ORDER BY Salary DESC) AS [Rank],
    DENSE_RANK() OVER (PARTITION BY GENDER ORDER BY Salary DESC) AS DenseRank
FROM Employees;

--PART 111 DIFFERENCE BTW RANK DENSE RANK AND ROW NUMBER
SELECT 
    Name, 
    Gender, 
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
    RANK() OVER (ORDER BY Salary DESC) AS [Rank],
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees;


--PART 112 CALCULATE RUNNING TOTAL IN SQL SERVER
select name, gender, salary,
sum(salary) over (order by id) as runningtotal
from employees

select name, gender, salary,
sum(salary) over (partition by gender order by id) as runningtotal
from employees

--PART 113 NTILE FUNCTION IN SQL SERVER
select NAME, GENDER, SALARY,
NTILE(2) OVER(ORDER BY SALARY) AS [NTILE]
from employees

select NAME, GENDER, SALARY,
NTILE(2) OVER(partition by gender ORDER BY SALARY) AS [NTILE]
from employees

--PART 114 LEAD AND LAG FUNCTIONS IN SQL SERVER
select NAME, GENDER, SALARY,
LEAD(SALARY) OVER( ORDER BY SALARY) AS LEAD
from employees

select NAME, GENDER, SALARY,
LEAD(SALARY, 2, -1) OVER( ORDER BY SALARY) AS LEAD
from employees

SELECT 
    Name, 
    Gender, 
    Salary,
    LEAD(Salary, 2, -1) OVER (ORDER BY Salary) AS LeadSalary,
    LAG(Salary, 1, -1) OVER (ORDER BY Salary) AS LagSalary
FROM Employees;

SELECT 
    Name, 
    Gender, 
    Salary,
    LEAD(Salary, 2, -1) OVER (partition by gender ORDER BY Salary) AS LeadSalary,
    LAG(Salary, 1, -1) OVER (partition by gender ORDER BY Salary) AS LagSalary
FROM Employees;

select NAME, GENDER, SALARY,
LEAD(SALARY) OVER(partition by gender ORDER BY SALARY) AS LEAD
from employees

--PART 115 FIRST_VALUE FUNCTION SQL SERVER
select NAME, GENDER, SALARY,
FIRST_VALUE(NAME) OVER(ORDER BY SALARY) AS FIRST_VALUE
from employees

select NAME, GENDER, SALARY,
FIRST_VALUE(NAME) OVER(partition by gendeR ORDER BY SALARY) AS FIRST_VALUE
from employees

--PART 116 WINDOW FUNCTIONS IN SQL SERVER
--AGGREGATE FUNC()--AVG, SUM,COUNT,MIN,MAX ETC.,
--RANKING FUNC()--RANK,DENSE_RANK,ROW_NUMBER ETC.,
--ANALYTIC FUNC()-LEAD,LAG,FIRST_VALUE,LAST_VALUE ETC.,
SELECT 
    Name, 
    Gender, 
    Salary,
    AVG(Salary) OVER (partition by gendeR ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Average,
    COUNT(Salary) OVER (partition by gendeR order BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Count],
    SUM(Salary) OVER (partition by gendeR ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Sum]
FROM Employees;

SELECT 
    Name, 
    Gender, 
    Salary,
    AVG(Salary) OVER (ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Average,
    COUNT(Salary) OVER (order BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS [Count],
    SUM(Salary) OVER (ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS [Sum]
FROM Employees;

SELECT AVG(SALARY)
FROM EMPLOYEES

--PART 117 DIFFERENCE BTW ROWS AND RANGE
--RANGE TREATS AS SINGLE ENTITY
--ROWS TREATS AS DISTINCT VALUES

SELECT NAME, SALARY,
SUM(SALARY) OVER( ORDER BY SALARY) AS RUNNINGTOTAL
FROM EMPLOYEES

SELECT NAME, SALARY,
SUM(SALARY) OVER( ORDER BY SALARY RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RUNNINGTOTAL
FROM EMPLOYEES

SELECT NAME, SALARY,
SUM(SALARY) OVER( ORDER BY SALARY ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RUNNINGTOTAL
FROM EMPLOYEES

SELECT NAME, SALARY,
SUM(SALARY) OVER(ORDER BY SALARY) AS [DEFAULT],
SUM(SALARY) OVER( ORDER BY SALARY RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [RANGE],
SUM(SALARY) OVER( ORDER BY SALARY ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [ROWS]

FROM EMPLOYEES

--PART 118 LAST VALUE FUNCTION IN SQL SERVER
select NAME, GENDER, SALARY,
LAST_VALUE(NAME) OVER(partition by gendeR ORDER BY SALARY) AS LAST_VALUE
from employees

--PART 119 UNPIVOT IN SQL SERVER
--PIVOT TURNS ROWS INTO COLUMNS
--UNPIVOT TURNS COLUMNS INTO ROWS
CREATE TABLE SalesAgent (
    Name VARCHAR(50),
    India INT,
    US INT,
    UK INT
);
INSERT INTO SalesAgent (Name, India, US, UK)
VALUES 
('David', 960, 520, 360),
('John', 970, 540, 800);

select * from SalesAgent
--------------------------------------
CREATE TABLE tblProductSales (
    SalesAgent VARCHAR(50),
    India INT,
    US INT,
    UK INT
);
INSERT INTO tblProductSales (SalesAgent, India, US, UK)
VALUES 
('David', 960, 520, 360),
('John', 970, 540, 800);

select * from tblProductSales
-------------------------------------
SELECT 
    SalesAgent, 
    Country, 
    SalesAmount
FROM tblProductSales
UNPIVOT (
    SalesAmount
    FOR Country IN (India, US, UK)
) AS UnpivotExample;
----------------------------------------
SELECT 
    SalesAgent, 
    Country, 
    SalesAmount
FROM tblProductSales
UNPIVOT (
    SalesAmount
    FOR Country IN (India, US, UK)
) AS UnpivotExample;

--PART 120 REVERSE PIVOT TABLE IN SQL SERVER
SELECT 
    SalesAgent, 
    Country, 
    SalesAmount
FROM tblProductSales
UNPIVOT (
    SalesAmount 
    FOR Country IN (India, US, UK)
) AS Unpivoted;
----------------------------------------------
SELECT 
    SalesAgent, 
    [India], 
    [US]
FROM tblProductSales
PIVOT (
    SUM(SalesAmount)
    FOR Country IN ([India], [US])
) AS PivotExample;

-------------------------------------------------
select * from tblProductSales

SELECT 
    SalesAgent, 
    Country, 
    SalesAmount
FROM tblProductSales
UNPIVOT (
    SalesAmount
    FOR Country IN (India, US, UK)
) AS Unpivoted;


-----------------------------------------------------------------------

--PART 121 CHOOSE FUNCTION SQL SERVER
SELECT CHOOSE(2,'INDIA','US','UK') AS COUNTRY

SELECT CHOOSE(0,'INDIA','US','UK') AS COUNTRY

CREATE TABLE EmployeeBirthdays (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    DateOfBirth DATE
);
INSERT INTO EmployeeBirthdays (ID, Name, DateOfBirth)
VALUES
(1, 'Alice', '1980-01-11'),
(2, 'Bob', '1981-03-15'),
(3, 'Charlie', '1982-07-20'),
(4, 'Diana', '1983-09-05'),
(5, 'Ethan', '1984-11-30'),
(6, 'Fiona', '1985-12-25');

SELECT * FROM EmployeeBirthdays

SELECT 
    Name, 
    DateOfBirth,
    CASE DATEPART(MM, DateOfBirth)
        WHEN 1 THEN 'JAN'
        WHEN 2 THEN 'FEB'
        WHEN 3 THEN 'MAR'
        WHEN 4 THEN 'APR'
        WHEN 5 THEN 'MAY'
        WHEN 6 THEN 'JUN'
        WHEN 7 THEN 'JUL'
        WHEN 8 THEN 'AUG'
        WHEN 9 THEN 'SEP'
        WHEN 10 THEN 'OCT'
        WHEN 11 THEN 'NOV'
        WHEN 12 THEN 'DEC'
    END AS [MONTH]
FROM EmployeeBirthdays;

SELECT 
    Name,
    DateOfBirth,
    CHOOSE(DATEPART(MM, DateOfBirth),
           'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
           'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC') AS [MONTH]
FROM EmployeeBirthdays;

--PART 122 IIF FUNCTION SQL SERVE
DECLARE @GENDERID INT
SET @GENDERID=1
SELECT IIF(@GENDERID=1,'MALE','FEMALE') AS GENDER

SELECT * FROM Employees
--USING CASE STATEMENT
SELECT 
    NAME,
    CASE 
        WHEN UPPER(GENDER) = 'MALE' THEN 'MALE'
        ELSE 'FEMALE'
    END AS GENDER
FROM EMPLOYEES;

--USING IIF STATEMENT
SELECT 
    NAME,
    IIF(UPPER(GENDER) = 'MALE', 'MALE', 'FEMALE') AS GENDER
FROM EMPLOYEES;

SELECT DISTINCT GENDER, SQL_VARIANT_PROPERTY(GENDER, 'BaseType') AS DataType
FROM EMPLOYEES;

--PART 123 TRY PARSE FUNCTION
SELECT TRY_PARSE('99' AS INT) AS RESULT--RESULTS 99
SELECT TRY_PARSE('ABC' AS INT) AS RESULT--RESULTS NULL

select
case when try_parse('abc' as int) is null then 'conversion failed'
else'conversion successful'
end as result

SELECT 
    IIF(TRY_PARSE('abc' AS INT) IS NULL, 'conversion failed', 'conversion successful') AS result;

SELECT PARSE('abc' AS INT) AS RESULT--RESULTS error
SELECT TRY_PARSE('ABC' AS INT) AS RESULT--RESULTS NULL

--PART 124 try convert function

SELECT try_convert(int,'99') AS RESULT--RESULTS 99
SELECT try_convert(int,'abc') AS RESULT--RESULTS null

select
case when try_convert(int,'abc') is null then 'conversion failed'
else'conversion successful'
end as result

SELECT 
    IIF(TRY_CONVERT(INT, 'abc') IS NULL, 'conversion failed', 'conversion successful') AS result;

SELECT try_convert(xml,'<root><child/></root>') AS [xml]
SELECT TRY_PARSE(xml,'<root><child/></root>') AS [xml]

--PART 125 EOMONTH FUNCTION
SELECT EOMONTH('11/20/2015') AS LASTDAY

SELECT EOMONTH('2016-02-20', 2) AS LASTDAY;

SELECT EOMONTH('2016-02-20', -1) AS LASTDAY;

--PART 126 DATEFROMPARTS FUNCTION
SELECT DATEFROMPARTS(2025,05,02) AS [DATE]

--PART 127 DIFF BTW DATETIME AND SMALLDATETIME
--SMALLDATETIME
INSERT INTO Employees([SMALLDATETIME]) VALUES ('01/01/1899')
--DATETIME
INSERT INTO Employees([DATETIME]) VALUES ('01/01/1752')

-- DATE TIME AND SMALL DATE TIEM HAS TO BE WITHIN THE DATE RANGE OTHERWISE WILL GET AN ERROR

--PART 128 DATETIME2FROMPARTS
SELECT DATETIME2FROMPARTS(2015,11,15,20,55,55,0,0) AS [DATETIME2]
SELECT DATETIME2FROMPARTS(2015,11,15,20,55,55,5,3) AS [DATETIME2]

--PART 129 DATETIME AND DATETIME2

CREATE TABLE DateTimeExample (
    ID INT,
    DT_Datetime DATETIME,
    DT_Datetime2 DATETIME2(7)
);
INSERT INTO DateTimeExample (ID, DT_Datetime, DT_Datetime2)
VALUES 
(1, '2024-06-26 12:34:56.123', '2024-06-26 12:34:56.1234567'),
(2, '2024-06-26 23:59:59.997', '2024-06-26 23:59:59.9999999');
SELECT 
    ID, 
    DT_Datetime, 
    DT_Datetime2
FROM 
    DateTimeExample;


DECLARE @dt1 DATETIME = '2024-06-26 12:34:56.123';
DECLARE @dt2 DATETIME2(7) = '2024-06-26 12:34:56.1234567';

SELECT 
    @dt1 AS [DATETIME],
    @dt2 AS [DATETIME2(7)];

--PART 130 OFFSET FETCH NEXT IN SQLSERVER
CREATE TABLE Products (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Description VARCHAR(255),
    Price DECIMAL(10, 2)
);
INSERT INTO Products (ID, Name, Description, Price) VALUES
(1, 'Product-1', 'Product Description-1', 10),
(2, 'Product-2', 'Product Description-2', 20),
(3, 'Product-3', 'Product Description-3', 30),
(4, 'Product-4', 'Product Description-4', 40),
(5, 'Product-5', 'Product Description-5', 50),
(6, 'Product-6', 'Product Description-6', 60),
(7, 'Product-7', 'Product Description-7', 10),
(8, 'Product-8', 'Product Description-8', 20),
(9, 'Product-9', 'Product Description-9', 30),
(10, 'Product-10', 'Product Description-10', 40),
(11, 'Product-11', 'Product Description-11', 50),
(12, 'Product-12', 'Product Description-12', 60),
(13, 'Product-13', 'Product Description-13', 10),
(14, 'Product-14', 'Product Description-14', 20),
(15, 'Product-15', 'Product Description-15', 30),
(16, 'Product-16', 'Product Description-16', 40),
(17, 'Product-17', 'Product Description-17', 50),
(18, 'Product-18', 'Product Description-18', 60),
(19, 'Product-19', 'Product Description-19', 10),
(20, 'Product-20', 'Product Description-20', 20),
(21, 'Product-21', 'Product Description-21', 30),
(22, 'Product-22', 'Product Description-22', 40),
(23, 'Product-23', 'Product Description-23', 50),
(24, 'Product-24', 'Product Description-24', 60),
(25, 'Product-25', 'Product Description-25', 10),
(26, 'Product-26', 'Product Description-26', 20),
(27, 'Product-27', 'Product Description-27', 30),
(28, 'Product-28', 'Product Description-28', 40),
(29, 'Product-29', 'Product Description-29', 50),
(30, 'Product-30', 'Product Description-30', 60),
(31, 'Product-31', 'Product Description-31', 10),
(32, 'Product-32', 'Product Description-32', 20),
(33, 'Product-33', 'Product Description-33', 30),
(34, 'Product-34', 'Product Description-34', 40),
(35, 'Product-35', 'Product Description-35', 50),
(36, 'Product-36', 'Product Description-36', 60),
(37, 'Product-37', 'Product Description-37', 10),
(38, 'Product-38', 'Product Description-38', 20),
(39, 'Product-39', 'Product Description-39', 30),
(40, 'Product-40', 'Product Description-40', 40),
(41, 'Product-41', 'Product Description-41', 50),
(42, 'Product-42', 'Product Description-42', 60),
(43, 'Product-43', 'Product Description-43', 10),
(44, 'Product-44', 'Product Description-44', 20),
(45, 'Product-45', 'Product Description-45', 30),
(46, 'Product-46', 'Product Description-46', 40),
(47, 'Product-47', 'Product Description-47', 50),
(48, 'Product-48', 'Product Description-48', 60),
(49, 'Product-49', 'Product Description-49', 10),
(50, 'Product-50', 'Product Description-50', 20),
(51, 'Product-51', 'Product Description-51', 30),
(52, 'Product-52', 'Product Description-52', 40),
(53, 'Product-53', 'Product Description-53', 50),
(54, 'Product-54', 'Product Description-54', 60),
(55, 'Product-55', 'Product Description-55', 10),
(56, 'Product-56', 'Product Description-56', 20),
(57, 'Product-57', 'Product Description-57', 30),
(58, 'Product-58', 'Product Description-58', 40),
(59, 'Product-59', 'Product Description-59', 50),
(60, 'Product-60', 'Product Description-60', 60),
(61, 'Product-61', 'Product Description-61', 10),
(62, 'Product-62', 'Product Description-62', 20),
(63, 'Product-63', 'Product Description-63', 30),
(64, 'Product-64', 'Product Description-64', 40),
(65, 'Product-65', 'Product Description-65', 50),
(66, 'Product-66', 'Product Description-66', 60),
(67, 'Product-67', 'Product Description-67', 10),
(68, 'Product-68', 'Product Description-68', 20),
(69, 'Product-69', 'Product Description-69', 30),
(70, 'Product-70', 'Product Description-70', 40),
(71, 'Product-71', 'Product Description-71', 50),
(72, 'Product-72', 'Product Description-72', 60),
(73, 'Product-73', 'Product Description-73', 10),
(74, 'Product-74', 'Product Description-74', 20),
(75, 'Product-75', 'Product Description-75', 30),
(76, 'Product-76', 'Product Description-76', 40),
(77, 'Product-77', 'Product Description-77', 50),
(78, 'Product-78', 'Product Description-78', 60),
(79, 'Product-79', 'Product Description-79', 10),
(80, 'Product-80', 'Product Description-80', 20),
(81, 'Product-81', 'Product Description-81', 30),
(82, 'Product-82', 'Product Description-82', 40),
(83, 'Product-83', 'Product Description-83', 50),
(84, 'Product-84', 'Product Description-84', 60),
(85, 'Product-85', 'Product Description-85', 10),
(86, 'Product-86', 'Product Description-86', 20),
(87, 'Product-87', 'Product Description-87', 30),
(88, 'Product-88', 'Product Description-88', 40),
(89, 'Product-89', 'Product Description-89', 50),
(90, 'Product-90', 'Product Description-90', 60),
(91, 'Product-91', 'Product Description-91', 10),
(92, 'Product-92', 'Product Description-92', 20),
(93, 'Product-93', 'Product Description-93', 30),
(94, 'Product-94', 'Product Description-94', 40),
(95, 'Product-95', 'Product Description-95', 50),
(96, 'Product-96', 'Product Description-96', 60),
(97, 'Product-97', 'Product Description-97', 10),
(98, 'Product-98', 'Product Description-98', 20),
(99, 'Product-99', 'Product Description-99', 30),
(100, 'Product-100', 'Product Description-100', 40);

SELECT * FROM Products

SELECT * FROM Products
ORDER BY ID
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

DECLARE @Counter INT = (SELECT ISNULL(MAX(ID), 0) + 1 FROM Products);
--append rows without deleting existing ones:

DECLARE @Counter INT = (SELECT ISNULL(MAX(ID), 0) + 1 FROM Products);
DECLARE @Max INT = @Counter + 99; -- Insert 100 rows

DECLARE @Name VARCHAR(25);
DECLARE @Description VARCHAR(100);
DECLARE @Price INT;

WHILE @Counter <= @Max
BEGIN
    SET @Name = 'Product-' + CAST(@Counter AS VARCHAR(10));
    SET @Description = 'Product Description-' + CAST(@Counter AS VARCHAR(10));
    SET @Price = (@Counter % 6 + 1) * 10;

    INSERT INTO Products (ID, Name, Description, Price)
    VALUES (@Counter, @Name, @Description, @Price);

    SET @Counter = @Counter + 1;
END

SELECT TOP 10 * FROM Products ORDER BY ID;
SELECT * FROM Products WHERE ID BETWEEN 1 AND 20 ORDER BY ID;

EXEC spGetRowsByPageNumberAndPageSize @PageNumber = 5, @PageSize = 10;

CREATE PROCEDURE spGetRowsByPageNumberAndPageSize
    @PageNumber INT,
    @PageSize INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM Products
    ORDER BY Id
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

--PART 131 IDENTIFYING OBJECT DEPENDECIES

--PART 132 SYS DM SQL REFERENCING ENTITIES
SELECT * FROM SYS.dm_sql_referencing_entities('[dbo].[Employees]','OBJECT')



CREATE VIEW VWEMPLOYEE --REFERENCING ENTITY
AS
SELECT * FROM EMPLOYEES--REFERENCED ENTITY

--PART 133 SP DEPENDS IN SQL SERVER
CREATE TABLE EMPLOYEES1
(
ID INT PRIMARY KEY IDENTITY,
NAME VARCHAR(50),
GENDER VARCHAR(10)
)
GO

CREATE PROCEDURE SP_GETEMPLOYEES
AS
BEGIN
SELECT * FROM EMPLOYEES
END 
GO

SP_DEPENDS 'EMPLOYEES1'
SP_DEPENDS '[dbo].[SP_GETEMPLOYEES]'

--PART 134 SEQUENCE OBJECT IN SQL SERVER
CREATE SEQUENCE [DBO].[SEQUENCEONJECT]
AS INT
START WITH 1
INCREMENT BY 1

SELECT NEXT VALUE FOR [DBO].[SEQUENCEONJECT]

SELECT * FROM SYS.sequences WHERE NAME='SEQUENCEONJECT'

DROP SEQUENCE[SEQUENCEONJECT]

CREATE SEQUENCE[DBO].[SEQUENCEOBJECT]
START WITH 100
INCREMENT BY 10
MINVALUE 100
MAXVALUE 150

SELECT NEXT VALUE FOR [DBO].[SEQUENCEOBJECT]

/****** Object:  Sequence [dbo].[TEST_SEQ]    Script Date: 26/06/2025 18:35:17 ******/
CREATE SEQUENCE [dbo].[TEST_SEQ] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 1000
 CACHE  20 
GO

--PART 135 DIFFERENCE BETWEEN SEQUENCE AND IDENTITY

--PART 136 GUID IN SQL SERVER
declare @id uniqueidentifier
select NEWID()
select @id

-- Create first database and table
CREATE DATABASE usadb;
GO

USE usadb;
GO

CREATE TABLE usacustomer
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50)
);
GO

INSERT INTO usacustomer (name) VALUES ('tom');
INSERT INTO usacustomer (name) VALUES ('mike');
GO

-- Create second database and table
CREATE DATABASE indiadb;
GO

USE indiadb;
GO

CREATE TABLE indiacustomer
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50)
);
GO

INSERT INTO indiacustomer (name) VALUES ('tom');
INSERT INTO indiacustomer (name) VALUES ('mike');
GO

-- Select from both tables to check data
USE usadb;
GO
SELECT * FROM dbo.usacustomer;

USE indiadb;
GO
SELECT * FROM dbo.indiacustomer;

USE usadb;
GO

CREATE TABLE usacustomer1
(
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name VARCHAR(50)
);
GO

INSERT INTO usacustomer1 (id, name) VALUES (DEFAULT, 'tom');
INSERT INTO usacustomer1 (id, name) VALUES (DEFAULT, 'mike');
GO

-- To check inserted data
SELECT * FROM usacustomer1;
SELECT * FROM indiacustomer1;

CREATE TABLE indiacustomer1
(
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name VARCHAR(50)
);
GO

INSERT INTO indiacustomer1 (id, name) VALUES (DEFAULT, 'tom');
INSERT INTO indiacustomer1 (id, name) VALUES (DEFAULT, 'mike');
GO

--PART 137 check guid null or empty
DECLARE @MyGuid UNIQUEIDENTIFIER;
SET @MyGuid = NEWID();

IF (@MyGuid IS NULL)
BEGIN
    PRINT 'Guid is NULL';
END
ELSE
BEGIN
    PRINT 'Guid is NOT NULL';
END

select @MyGuid

--PART 138 dynamic sql




--PART 139 implement search web page using ASP NET



--PART 140 implement search webpage using asp net and dynamic sql


--PART 141 prevent sql injection with dynamic


--PART 142 dynamic sql  in stored procedures


--PART 144 exec vs sp executesql in sql server
DECLARE @FN NVARCHAR(50);
SET @FN = 'John';

DECLARE @sql NVARCHAR(MAX);
SET @sql = 'SELECT * FROM Employees WHERE Name = ''' + @FN + '''';

-- Execute the dynamic SQL
EXEC (@sql);

SELECT * FROM EMPLOYEES
-------------------------------------------------------
DECLARE @FN NVARCHAR(50);
SET @FN = 'John';

DECLARE @sql NVARCHAR(MAX);
SET @sql = 'SELECT * FROM Employees WHERE Name = @Name';

-- Execute the dynamic SQL with parameter
EXEC sp_executesql @sql, N'@Name NVARCHAR(50)', @Name = @FN;

--PART 145 sql server query plan cache


--PART 146 quote name function in sql server
CREATE TABLE [USA1Customers] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender VARCHAR(50)
);

INSERT INTO [USA1Customers] (FirstName, LastName, Gender) VALUES 
('Mark', 'Hastings', 'Male'),
('Steve', 'Pound', 'Male'),
('Ben', 'Hoskins', 'Male'),
('Philip', 'Hastings', 'Male'),
('Mary', 'Lambeth', 'Female'),
('Valarie', 'Vikings', 'Female'),
('John', 'Stanmore', 'Male');
SELECT * FROM USA1Customers

SELECT * FROM [USA1 Customers]--IF THERE IS SPACE ADD BRACKETS


DECLARE @sql NVARCHAR(MAX);
DECLARE @tableName NVARCHAR(50);

-- If your table name has spaces, include brackets here:
SET @tableName = '[USA1Customers]';

-- Build the dynamic SQL string:
SET @sql = 'SELECT * FROM ' + @tableName;

-- Execute the dynamic SQL:
EXEC sp_executesql @sql;


DECLARE @sql NVARCHAR(MAX);
DECLARE @tableName NVARCHAR(50);

-- Set table name without brackets if you plan to use QUOTENAME
SET @tableName = 'USA1Customers';

-- Build the dynamic SQL string with schema and table separated by a dot
SET @sql = 'SELECT * FROM ' + QUOTENAME('dbo') + '.' + QUOTENAME(@tableName);

PRINT @sql;

-- Execute the dynamic SQL:
EXEC sp_executesql @sql;

select QUOTENAME('usa customers','''')

Declare @tableName nvarchar (50)
Set @tableName = 'USA ] Customers'
Set @tableName = QUOTENAME (@tableName)
Print @tableName
Set @tableName = PARSENAME (@tableName, 1)
Print @tableName

--PART 147 dynamic sql vs stored procedures


--PART 148 DYNAMIC SQL OUTPUT PARAMETER
select * from USA1Customers

CREATE PROCEDURE spemployeecount
    @gender NVARCHAR(10),
    @count INT OUTPUT
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Build dynamic SQL
    SET @sql = 'SELECT @count = COUNT(*) FROM Employees WHERE Gender = @gender';

    -- Execute with proper parameter declaration
    EXEC sp_executesql 
        @sql, 
        N'@gender NVARCHAR(10), @count INT OUTPUT', 
        @gender = @gender, 
        @count = @count OUTPUT;
END

DECLARE @result INT;
EXEC spemployeecount @gender = 'Male', @count = @result OUTPUT;
SELECT @result AS TotalCount;

--PART 149 temp tables in dynamic sql
CREATE PROCEDURE spTempTableInDynamicSQL
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
    CREATE TABLE #Test (Id INT);
    INSERT INTO #Test VALUES (101);
    SELECT * FROM #Test;
    ';

    EXEC sp_executesql @sql;
END;

execute spTempTableInDynamicSQL


ALTER PROCEDURE spTempTableInDynamicSQL
AS
BEGIN
        CREATE TABLE #Test (Id INT);
        INSERT INTO #Test VALUES (101);
        declare @sql nvarchar(max)
		set @sql='select * from #test'
    EXEC sp_executesql @sql;
END;


execute spTempTableInDynamicSQL

