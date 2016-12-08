set pagesize 111
set linesize 211
set trimspool on
set heading on
set verify off
set feedback off

COLUMN "Event Name" FORMAT A38
COLUMN snapshot_end_time FORMAT A27

SELECT 		begin_snap_id,
			    end_snap_id,
			    snapshot_end_time,
			    event "Event Name",
			    waits "Waits",
			    time "Wait Time (s)",
			    avgwait "Avg Wait (ms)",
			    TRUNC((time/dbtime.total)*100) "% DB Time"
FROM 			(
			    SELECT 		b.snap_id begin_snap_id,
						        b.snap_id+1 end_snap_id,
						        dhs.END_INTERVAL_TIME snapshot_end_time,
						        e.event_name event,
						        e.total_waits - NVL(b.total_waits,0) waits,
						        TRUNC((e.time_waited_micro - NVL(b.time_waited_micro,0))/1000000) time,
						        DECODE((e.total_waits - NVL(b.total_waits, 0)), 0, TO_NUMBER(NULL),
						        TRUNC(((e.time_waited_micro - NVL(b.time_waited_micro,0))/1000) / (e.total_waits - NVL(b.total_waits,0)))) avgwait
     			FROM		  dba_hist_system_event b,
						        dba_hist_system_event e,
						        dba_hist_snapshot dhs
     			WHERE		  b.snap_id = (SELECT MAX(snap_id)-1 FROM dba_hist_snapshot WHERE DBID=(SELECT dbid FROM v$database))
                  	AND e.snap_id = (SELECT MAX(snap_id) FROM dba_hist_snapshot WHERE DBID=(SELECT dbid FROM v$database))
                  	AND b.dbid(+) = e.dbid
                  	AND dhs.DBID =e.dbid
		              	AND dhs.DBID = (SELECT dbid FROM v$database)
                  	AND b.instance_number(+)  = e.instance_number
                  	AND b.event_id(+) = e.event_id
                  	AND e.total_waits > NVL(b.total_waits,0)
                  	AND e.wait_class <> 'Idle'
                  	AND e.snap_id=dhs.snap_id
                  	AND b.event_name IN ('log file sync')
		    ) evnt,
    		(
                  	AND 		e.snap_id = (SELECT MAX(snap_id) FROM dba_hist_snapshot WHERE DBID=(SELECT dbid FROM v$database))
                  	AND 		b.dbid(+) = e.dbid
                  	AND 		dhs.DBID =e.dbid
		              	AND 		dhs.DBID = (SELECT DBID FROM v$database)
                  	AND 		b.instance_number(+)  = e.instance_number
                  	AND 		b.event_id(+) = e.event_id
                  	AND 		e.total_waits > NVL(b.total_waits,0)
                  	AND 		e.wait_class          <> 'Idle'
                  	AND 		e.snap_id=dhs.snap_id
                  	AND 		b.event_name IN ('log file sync')
		    	) evnt,
    			(
			    SELECT 		SUM(TRUNC((e.time_waited_micro - NVL(b.time_waited_micro,0))/1000000)) total
     			FROM 		  dba_hist_system_event b,
					          dba_hist_system_event e
	     		WHERE 		b.snap_id = (SELECT MAX(snap_id)-1 FROM dba_hist_snapshot WHERE dbid=(SELECT dbid FROM v$database))
          AND 		  e.snap_id = (SELECT MAX(snap_id) FROM dba_hist_snapshot WHERE dbid=(SELECT dbid FROM v$database))
                  	AND b.dbid(+) = e.dbid
                  	AND b.instance_number(+)  = e.instance_number
                  	AND b.event_id(+) = e.event_id
                  	AND e.total_waits > NVL(b.total_waits,0)
                  	AND e.wait_class <> 'Idle'
        ) dbtime
                  	AND 		b.dbid(+) = e.dbid
                  	AND 		b.instance_number(+)  = e.instance_number
                  	AND 		b.event_id(+) = e.event_id
                  	AND 		e.total_waits > NVL(b.total_waits,0)
                  	AND 		e.wait_class <> 'Idle'
        	) dbtime
WHERE 		time > 0
AND 		  avgwait >= 10
ORDER BY 	5 DESC;
