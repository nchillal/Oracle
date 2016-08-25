select  process, 
        status, 
        thread#, 
        sequence#, 
        block#, 
        blocks 
from    v$managed_standby;
