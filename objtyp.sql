SET lines 230
COLUMN object_name FOR a30

SELECT  owner, 
        object_id
        object_name, 
        object_type, 
        last_ddl_time, 
        status 
FROM    dba_objects 
WHERE   object_name = UPPER('&objtect_name');
