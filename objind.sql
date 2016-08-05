COLUMN  column_name FOR a30

SELECT  owner, 
        index_name, 
        index_type, 
        uniqueness, 
        status 
FROM    dba_indexes 
WHERE   table_name='&table_name'
/

SELECT  index_owner, 
        index_name, 
        column_name, 
        column_position, 
        column_length
FROM    dba_ind_columns
WHERE   table_name='&tname'
AND     table_owner='&owner'
/
