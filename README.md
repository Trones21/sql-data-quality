# sql-data-quality

SQL scripts to create Data Quality tables that can be used with data visualization software such as Tableau or PowerBI

## Purpose/Reasoning:
To get a birds eye view of your database.
 
Databases have valuable meta-data such as: 
-the number of nulls and blanks(completeness), 
-the distinct number of values in a column (uniqueness)  

In theory you could unpivot everything (see unpivot-sql) 
but as the database becomes larger, this becomes infeasible. I also think it is a bit easier to work with Tableau 
when you have 1 record per column rather than a varying number of records per column. 

### Examples:
Sometimes you will takeover existing databases that were developed by over people.
Sometimes the database is pulling data directly from an api. You have no nullable control.(Real world situation I wrote this for)
Sometimes apps may be written to just insert a blank. In technical terms this may not be the same thing as a null, but in terms of business value it's as useful as null. 

### Obtaining value from this:
Lets say you have two fields EmailAddress and Company. 
In the origin application EmailAddress is required, but company is not.
Upon Analyzing the Tableau workbook you see that 8% of records have a company and 100% have an email address.
You want to kow which companies your contacts work for. You could send out an email asking people to update their info, but let's say you don't have time to wait for responses,
nor do you know how many will respond.

Most email address are text@<company>.<com|org|etc> . So just do a little Regex in Tableau to isolate the company :) 

 
## Description:
SQL scripts to create Data Quality tables that can be used with data visualization software such as Tableau or PowerBI

PKS_ToDo (modify/add) - I have included some sample Tableau dashboards that use the output data. (Examples use the sample worldwideimporters database from Microsoft)  

The default output table looks like this:

| TableName  | ColumnName | RecordCount | nonValCount  | 
| ---------- |-------------|-----| ----- |
| MyTable    | MyColumn | 3678 | 2167|
| MyTable    | AnotherColumn | 2567 | 2141|
| AnotherTable    | AnoColumn | 256 | 214 |

nonValCount - Is the number of rows where the value is null or ''


This format can be modified to output anything desired - just modify:
-The table you insert into
-The dynamic sql in the procedure

## Examples:
-PKS_ToDo - Include code snippets for these
Uniqueness Measure - Count distinct of the dimension members (cells in column) 

Example Adding Multiple Procedures
**Note**: Not compatible with Tableau dashboards.


## Script Status
| Script/System | Status  					|
| ------------- |:-------------------------:|
|Microsoft Access | Planned |
|Microsoft SQL Server| Finished* |
|MySQL| Planned |
|Oracle | Planned |
|PostGres| Planned |
|Redshift| Considering |
|SAP HANA 	| 	Finished - Untested  	|
|SQLite|Considering|
|Teradata|Considering|
|Vertica|Considering|

*SQL Server - Known Bug for Geo datatype 



