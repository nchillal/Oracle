set lines 230
col object_name for a30

select  owner, 
        object_name, 
        object_type, 
        last_ddl_time, 
        status 
from    dba_objects 
where   object_name = UPPER('&objtect_name');
