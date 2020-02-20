# sql-data-quality

SQL scripts to create Data Quality tables that can be used with data visualization software such as Tableau or PowerBI

The default output table looks like this


| TableName  | ColumnName | RecordCount | nonValCount  | 
| ---------- |-------------|-----|
| MyTable    | MyColumn | 3678 | 2167|
| MyTable    | AnotherColumn | 2567 | 2141|
| AnotherTable    | AnoColumn | 256 | 214 |

nonValCount - Is the number of rows where the value is null or ''

This can be modified to output anything desired - just modify the dynamic sql in the procedure

## Examples:
-PK_ToDo - Include code snippets for these
Number of Records where length > 10 


## Script Status
| Script/System | Status  					|
| ------------- |:-------------------------:|
| SAP HANA 		| 	Finished - Untested  	|


