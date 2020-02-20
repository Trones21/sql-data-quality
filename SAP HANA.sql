/*
Note: This hasn't beeen tested, I made some modifications to make it more generic, but I haven't run this version yet 
*/

-- Setup
/*

alter procedure "CVENT"."GetNonValsCount"(IN schematable NVARCHAR(255), IN Col NVARCHAR(255), out nonValsCnt integer)
as begin

execute immediate 'select COUNT(TO_NVARCHAR("' || :Col || '")) from "' || :schematable ||'"
where 
"' || :Col || '" is null or
TRIM("' || :Col || '") = ''''; '  
into nonValsCnt;

end


alter global temporary table nonValsCntTable
(
"TableName" NVARCHAR(255),
"ColumnName" NVARCHAR(255),
"nonValsCnt" integer
);
*/

delete from nonValsCntTable;

do
begin
declare maxNum integer;
declare i integer;
declare columnString NVARCHAR(255);
declare tablestring NVARCHAR(255);
declare nonValsCnt integer;
declare TgtSchema NVARCHAR(255);

ColumnList = 
select
ROW_NUMBER() over(order by TABLE_NAME, COLUMN_NAME desc) as rn, 
TABLE_NAME,
COLUMN_NAME
from table_columns
where SCHEMA_NAME = :TgtSchema
and TABLE_NAME like '%FilterbySomethingHere%'

select MAX(rn) into maxNum from :ColumnList;

for i in 1..:maxNum do
	
	select COLUMN_NAME into columnString from :ColumnList where rn = i;
	select :TgtSchema || "." || TABLE_NAME into tablestring from :ColumnList where rn = i;
	
	call "CVENT"."GetNonValsCount"(schematableString ,columnString, nonValsCnt);
	insert into nonValsCntTable values(columnString, nonValsCnt, tableString);

end for;

end;

select * from
(select
TABLE_NAME,
RECORD_COUNT
from m_tables
where SCHEMA_NAME = :TgtSchema
and TABLE_NAME like '%FilterbySomethingHere%'
) rc
left join 
(select * from nonValsCntTable) nonVals
on nonVals."TableName" = rc.TABLE_NAME;