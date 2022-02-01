Presto (Athena's underlying engine) has a "show stats" command that would simplify this, but it is not currently available in Athena
https://docs.aws.amazon.com/athena/latest/ug/unsupported-ddl.html

Need to check dynamic sql, possibly with:
prepare,
execute,
cte's / subqueries
--show tables from schema
--show columns from schema.table
