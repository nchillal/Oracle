select  sql_id, 
        sql_child_number 
from    v$session 
where   sid=&sid;
