set lines 230 pages 200

break on inst_id

col event for a50
col machine for a40

select  inst_id, 
        sid, 
        event, 
        seconds_in_wait, 
        status, 
        machine, 
        program 
from    gv$session 
where   wait_time=0 
and     type <> 'BACKGROUND' 
and     event not in ('dispatcher timer','pipe get','pmon timer','PX Idle Wait','PX Deq Credit: need buffer','rdbms ipc message','shared server idle wait','smon timer','SQL*Net message from client');
