# Purpose: Monitor transaction recovery by SMON.
SELECT  usn,
        state,
        undoblockstotal "Total",
        undoblocksdone "Done",
        undoblockstotal-undoblocksdone "ToDo",
        decode(cputime,0,'unknown',SYSDATE+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400)) "Estimated time to complete"
FROM    v$fast_start_transactions;
