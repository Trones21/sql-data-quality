/** To use this script just change the DB name in the columnCursor - Search for PK_ChangeDBName **/
/** Tested with SQL Server 2016 **/


--Run this statement once to create the output table
--Note: If you change the data quality table name or location, you will have to modify other parts of the script - Search for: PK_OtherDQTable
Create table dbo.DataQuality(
[ColumnObjectUID] NVARCHAR(255),
[Schema] NVARCHAR(128),
[Table] NVARCHAR(128), 
[Column] NVARCHAR(128),
RecordCount INT,
nonValCount INT,
[DateTime] Datetime);



/* Create procedure and job in SQL Server Agent to run this at specific intervals */


/* Full Procedure */

create table #Results(
[ColumnObjectUID] NVARCHAR(255),
[Schema] NVARCHAR(128),
[Table] NVARCHAR(128), 
[Column] NVARCHAR(128),
RecordCount INT,
nonValCount INT);

declare @schema NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128);
declare @recordCount INT;
declare @nonValCount INT;
declare @SQL NVARCHAR(MAX);

declare columnCursor Cursor
for
SELECT 
	[TABLE_SCHEMA]
      ,[TABLE_NAME]
      ,[COLUMN_NAME]
	  --PK_ChangeDBName 
  FROM [CryptoCurrencyScraperFirst.WebScrapeDbContext].[INFORMATION_SCHEMA].[COLUMNS]
  --PK_OtherDQTable  -- Excludes our newly created table from the cursor
  where NOT ([TABLE_SCHEMA] = 'dbo' and [TABLE_NAME] = 'DataQuality');

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

	Insert into #Results values(null, @schema, @table, @column, @recordCount, @nonValCount);
	Fetch next from columnCursor into @schema, @table, @column;
End;
close columnCursor;
deallocate columnCursor;

-- If NonValCount is null, this means all values are filled, so we update the column to 0
update #Results
set nonValCount = 0
where nonValCount is null;


-- Join the ObjectUID



-- only insert a record for this run if one of the numbers has changed, or if the key  does not exist
select *,
CURRENT_TIMESTAMP
from #Results r
left join dbo.DataQuality dq
on 


where 
r.nonValCount <> dq.nonValCount or
r.RecordCount <> dq.recordCount

select * from #Results;

insert into dbo.DataQuality
select *,
CURRENT_TIMESTAMP
from #Results
;

delete from #Results;


drop table #Results;
