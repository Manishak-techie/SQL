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
