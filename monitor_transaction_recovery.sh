# Purpose: Monitor transaction recovery by SMON.
select  usn, 
        state, 
        undoblockstotal "Total", 
        undoblocksdone "Done", 
        undoblockstotal-undoblocksdone "ToDo", 
        decode(cputime,0,'unknown',sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400)) "Estimated time to complete" 
from    v$fast_start_transactions;
