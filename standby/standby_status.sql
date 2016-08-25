set lines 230 
col dest_name for a30

select  dest_id, 
        dest_name, 
        status, 
        error 
from    V$ARCHIVE_DEST_STATUS 
where   dest_id < 3;
