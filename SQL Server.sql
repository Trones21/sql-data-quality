/****** Script for SelectTopNRows command from SSMS  ******/

create table #Writeto (TableName NVARCHAR(MAX), NameLength INT);

insert into #Writeto values('test' , 4);

Declare @Name NVARCHAR(MAX);
Declare @NameLength INT;

declare testCursor Cursor
	for SELECT [name], LEN([name]) as NameLength FROM [WideWorldImporters].[sys].[all_objects] where [type_desc] = 'USER_TABLE';

open testCursor;

Fetch Next from testCursor into @Name, @NameLength;

while @@FETCH_STATUS = 0
	BEGIN
		insert into #Writeto values(@Name , @NameLength);
		Fetch Next from testCursor into @Name, @NameLength;
	END;

close testCursor;

deallocate testCursor;


select * from #Writeto;

--Instructions:
-- Search for PK_ToDo and follow instructions 

--PK_ToDo - Optional - Persist to your table instead of temp table #Results 
create table #Results(
TableName NVARCHAR(MAX), 
ColumnName NVARCHAR(MAX),
RecordCount INT,
nonValCount INT);

--PkK_ToDo - Multiple ways to get row counts, choose one:
--1.Cursor + Dynamic SQL 
declare tableCursor Cursor 
for
SELECT TOP (1000) [TABLE_CATALOG]
      ,[TABLE_SCHEMA]
      ,[TABLE_NAME]
      ,[TABLE_TYPE]
	  --PK_ToDo --Change db name Here
  FROM [WideWorldImporters].[INFORMATION_SCHEMA].[TABLES]

--2.SQL - Join 





declare columnCursor Cursor
for
SELECT 
	[TABLE_SCHEMA]
      ,[TABLE_NAME]
      ,[COLUMN_NAME]
	  --PK_ToDo -- Change db name here
  FROM [WideWorldImporters].[INFORMATION_SCHEMA].[COLUMNS]

declare @schema NVARCHAR(MAX);
declare @table NVARCHAR(MAX);
declare @column NVARCHAR(MAX);
declare @recordCount INT;

declare @SQL_recordCount NVARCHAR(MAX) = N'select COUNT(*) from [' + @schema + '].[' + @table + '];'

declare @SQL_nonValCount NVARCHAR(MAX) = 
N'Select @out = COUNT(['+ @column +']) from ' + @schema + '.' + @table + ' 
where [' + @column + '] IS NULL OR LTRIM(RTRIM([' + @column + '])) = '''';' ;



--loop Columns
set @schema = 'Sales';
set @table = 'Invoices';
set @Column = 'ContactPersonID';


declare @nonValsCnt INT;

 --Syntax Help: Sql Statement, Output Param Defintion, Assign output param val to existing variable (backwards looking syntax)
EXEC sp_executesql @SQL_nonValCount, N'@out INT OUTPUT', @out = @nonValsCnt OUTPUT;

Insert into #Results(@schema, @table, @column, @recordCount, @nonValsCnt);





Create Procedure GetNonValsCount(@table as NVARCHAR(MAX), @column as NVARCHAR(MAX), output @nonValsCnt INT)
as
begin
	select COUNT(@column)

end;

Select COUNT([ContactPersonID]) from Sales.Invoices 

Select COUNT([ContactPersonID]) from Sales.Invoices 
where [ContactPersonID] IS NULL OR LTRIM(RTRIM([ContactPersonID])) = ''