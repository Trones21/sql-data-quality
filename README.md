# sql-data-quality

SQL scripts to create a Data Quality table (metadata about your database) for use with data viz software such as Tableau or PowerBI.

![Data Quality Overview](https://imgur.com/DVvNMjM.png)

## Purpose/Reasoning:
1. To get a birds eye view of your database.

2. To drill down into specific tables and columns to find insights 

   

Databases have valuable meta-data such as: 

- the number of nulls and blanks(completeness), 
- the distinct number of values in a column (uniqueness)  

### Example Use Cases:
- Continuous Monitoring / Improvement: As more records are inserted into the database, the metadata will change 
- When you takeover responsibility for pre-existing databases.
- The database is pulling data directly from an api. You have no nullable control. (Real world situation I wrote this for)

- Apps may be written to just insert a blank. In technical terms this may not be the same thing as a null, but in terms of business value it's as useful as null.

### Obtaining Business value from this Script:
Lets say you have two fields EmailAddress and Company. In the origin application EmailAddress is required, but company is not. Upon Analyzing the Tableau workbook you see that 8% of records have a company and 100% have an email address.

You want to know which companies your contacts work for. You could send out an email asking people to update their info, but let's say you don't have time to wait for responses,
nor do you know how many will respond.

Most email address are text@<company>.<com|org|etc> . So just do a little Regex in Tableau to isolate the company :) 




## Description:
SQL scripts to create Data Quality tables for use with data visualization software such as Tableau or PowerBI

I have included some sample Tableau dashboards that use the output data. Examples use the sample WideWorldImporters database from Microsoft. You can also find these dashboards on my Tableau Public profile:
https://public.tableau.com/profile/thomas.j.rones#!/

The default output table looks like this example:

| Schema | Table  | Column | RecordCount | nonValCount  | distinctCount |
|----------| ---------- |-------------|-----| ----- | ----- |
| MySchema | Users | FirstName | 3678 | 2167| 1400 |
| MySchema | Users | Age | 2567 | 2141| 56 |
| MySchema | Orders | ID | 7986 | 7986 | 7986 |

**nonValCount** - The number of rows where the value is null or an empty string



## Modification:
This format can be modified to output anything desired - just modify:

- The table you insert into
- The dynamic sql

**Note**: If you **remove** any columns, then this data will not be compatible with the sample Tableau dashboards. Adding columns will have no effect as long as the granularity remains consistent (1 output row per db column).

### Modification Examples:

-PKS_Section ToDo - Include some code snippets



## Youtube Videos

[Explanation of Initial Dashboards](https://www.youtube.com/watch?v=y6bVVeqySCw)




## Script Status
| System               | Base Script (Snapshot) | With History / Periodic Trigger | Notes |
| ------------- | ------------- | ------------- | -------------- |
|AWS Athena | In Progress | | No Dynamic SQL, Must Automate UI with JavaScript instead |
|Microsoft SQL Server| Finished** | In Progress |
|MySQL| Finished |  |
|Oracle | Considering |  |
|PostGres| Considering |  |
|Redshift| Considering |  |
|SAP HANA 	| 	Finished** - Untested  | 	  	|
|SQLite|Considering||
|Teradata|Considering||
|Vertica|Considering||

*SQL Server - Script works, but there is 1 known bug - cannot use R/LTRIM() for geo datatype.   

** Doesn't have the distinct count yet, I added this in the MySQL one.

