sqlplus -s "/as sysdba" <<-EOF
SET LINESIZE 160 PAGESIZE 100
-- This is used to value of service_names init parameter.
show parameter service_names
show parameter unique

-- This query display dataguard process status.
SELECT    inst_id, pid, delay_mins, process, status, group#, thread#, sequence#, block#, blocks
FROM      gv\$managed_standby
/

-- This query checks if MRP is running in Real-Time apply mode.
SELECT    recovery_mode
FROM      v\$archive_dest_status
WHERE     recovery_mode <> 'IDLE'
/

-- Verify the last sequence# received and the last sequence# applied to standby database.
SELECT    al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied"
FROM      (
          SELECT    thread# thrd, MAX(sequence#) almax
          FROM      v\$archived_log
          WHERE     resetlogs_change# = (SELECT resetlogs_change# FROM v\$database)
          GROUP BY  thread#
          ) al,
          (
          SELECT    thread# thrd,
                    MAX(sequence#) lhmax
          FROM      v\$log_history
          WHERE     resetlogs_change#=(SELECT resetlogs_change# FROM v\$database)
          GROUP BY  thread#
          ) lh
WHERE     al.thrd = lh.thrd
/

SELECT    value, time_computed
FROM      v\$dataguard_stats
WHERE     name='apply lag'
/
EOF
