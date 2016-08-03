SELECT  owner, 
        index_name, 
        index_type, 
        uniqueness, 
        status 
FROM    dba_indexes 
WHERE   table_name='&table_name'
/
