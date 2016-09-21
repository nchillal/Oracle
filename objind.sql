SET LINESIZE 155 PAGESIZE 200 HEADING OFF
COLUMN  column_name FORMAT a30

-- Create bind variable for storing table_name
VARIABLE  v_table_name VARCHAR2(30);
variable  v_table_owner VARCHAR2(30);

-- Referencing the bind variable
exec :v_table_name := UPPER('&table_name');
exec :v_table_owner := UPPER('&table_owner');

-- List indexes defined on the table.
SELECT  index_name,
        index_type,
        uniqueness,
        status
FROM    dba_indexes
WHERE   table_name=:v_table_name
AND     owner=:v_table_owner
/

-- List columns on which these indexes are defined.
SELECT  index_owner,
        index_name,
        column_name,
        column_position,
        column_length
FROM    dba_ind_columns
WHERE   table_name=:v_table_name
AND     table_owner=:v_table_owner
/
