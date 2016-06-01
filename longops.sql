select  * 
from    v$session_longops 
where   sofar<>totalwork 
and     time_remaining!=0;
