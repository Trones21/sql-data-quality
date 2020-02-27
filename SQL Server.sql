/** To use this script just change the DB name in the columnCursor **/
/** Tested with SQL Server 2016 **/

create table #Results(
[Schema] NVARCHAR(MAX),
[Table] NVARCHAR(MAX), 
[Column] NVARCHAR(MAX),
RecordCount INT,
nonValCount INT);

declare @schema NVARCHAR(MAX), @table NVARCHAR(MAX), @column NVARCHAR(MAX);
declare @recordCount INT;
declare @nonValCount INT;
declare @SQL NVARCHAR(MAX);

declare columnCursor Cursor
for
SELECT 
	[TABLE_SCHEMA]
      ,[TABLE_NAME]
      ,[COLUMN_NAME]
	  --Change DB name 
  FROM [WideWorldImporters].[INFORMATION_SCHEMA].[COLUMNS];

open columnCursor;
Fetch next from columnCursor into @schema, @table, @column;

while @@FETCH_STATUS = 0
Begin
	set @SQL  = 
	N'Select @rcOUT = rc, @nvcOUT = nvc
	from (
	select
	SUM(CASE 
		WHEN ['+ @column +'] IS NULL THEN 1 
		WHEN LTRIM(RTRIM(['+ @column +'])) = '''' THEN 1
		END)	
		as nvc,

	 COUNT(*) as rc 
	 from [' + @schema + '].[' + @table + ']) as t1 ;' ;

	 --Syntax Help: Sql Statement, Output Param Defintion, Assign output params to existing variables (backwards looking syntax)
	EXEC sp_executesql @SQL, 
	N'@rcOUT INT OUTPUT, @nvcOUT INT OUTPUT', 
	@rcOUT = @recordCount OUTPUT, @nvcOUT = @nonValCount OUTPUT;

	Insert into #Results values(@schema, @table, @column, @recordCount, @nonValCount);
	Fetch next from columnCursor into @schema, @table, @column;
End;
close columnCursor;
deallocate columnCursor;


-- If NonValCount is null, this means all values are filled, so we update the column to 0
update #Results
set nonValCount = 0
where nonValCount is null


select * from #Results
order by [nonValCount] desc;

