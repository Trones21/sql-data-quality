/* Only outputs the current Data Quality, no history*/
/* For use with Tableau dashboards */
/* To use this script just change the schema name in the columnCursor */
/* Tested with  MySQL 8.0.18 */

/*MySQL doesn't support anonymous blocks, so we are creating procedures -- its more readable anyway :) */

Create table DataQualityCurrent(
`Schema` NVARCHAR(128),
`Table` NVARCHAR(128), 
`Column` NVARCHAR(128),
RecordCount INT,
nonValCount INT,
distinctCount INT);

DELIMITER //
CREATE PROCEDURE `DataQuality` ()
begin
declare Num INT default 0;
-- For Columns
declare schemaName, tableName, columnName CHAR(128);
declare nonValCount, recordCount, distinctCount INT;
-- Other
declare isFinished bool default false;

  DECLARE columnCursor
        CURSOR FOR 
			SELECT
			   TABLE_SCHEMA
			  ,TABLE_NAME
			  ,COLUMN_NAME
			FROM INFORMATION_SCHEMA.COLUMNS
		  -- PK_Change Table_Schema (the database)
		  where TABLE_SCHEMA = 'classicmodels';
          
DECLARE CONTINUE HANDLER FOR NOT FOUND SET isFinished = TRUE;	
set sql_mode='PIPES_AS_CONCAT';

OPEN columnCursor;

doWork: LOOP
FETCH columnCursor into schemaName, tableName, columnName;
IF isFinished then
	Leave doWork;
End IF;

set @schema = schemaName;
set @table = tableName;
set @column = columnName;

set @sql = '
select COUNT(*),
COUNT(distinct `' || @column ||'`),
SUM(CASE 
	WHEN `' || @column ||'` IS NULL THEN 1 
	WHEN LTRIM(RTRIM(`' || @column ||'`)) = '''' THEN 1
	END)	
INTO @recordCount, @distinctCount, @nonValCount
from `' || @schema || '`.`' || @table || '`;';

PREPARE dynamic_statement FROM @sql;
EXECUTE dynamic_statement;
DEALLOCATE PREPARE dynamic_statement;

-- We could remove the variables and put this in the dynamic sql if we wanted to?
INSERT INTO `dataqualitycurrent`
VALUES
(@schema,
 @table,
@column, 
@recordCount,
@nonValCount,
@distinctCount);

END LOOP doWork;

close columnCursor;

-- If NonValCount is null, this means all values are filled, so we update the column to 0
update DataQualityCurrent
set nonValCount = 0
where nonValCount is null;

END  //
DELIMITER ; 

Call DataQuality();

select * from dataqualitycurrent;