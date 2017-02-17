set serveroutput on
declare
	min_snapid number(10);
	max_snapid number(10);
begin
	SELECT 	MIN(snap_id) INTO min_snapid FROM dba_hist_active_sess_history
	WHERE 	dbid = (SELECT dbid FROM v$database)
	AND			TO_CHAR(sample_time, 'DD-MON-YYYY HH24:MI') > '&start_time';

	SELECT 	MAX(snap_id) into max_snapid from dba_hist_active_sess_history
	WHERE 	dbid = (SELECT dbid FROM v$database)
	AND			TO_CHAR(sample_time, 'DD-MON-YYYY HH24:MI') > '&end_time';

  dbms_output.put_line(chr(10)||'Min snapid: '||min_snapid);
  dbms_output.put_line('Max snapid: '||max_snapid);
  dbms_output.put_line(chr(10)||'Wait evetns between snapshots '||min_snapid||' and '||max_snapid);
  dbms_output.put_line(chr(10)||'--------------------------------------------------------------------------------------------------------------------------------------------------');
  dbms_output.put_line(RPAD('Event Name', 45, ' ')||'        '||RPAD('Total Waits', 10, ' ')||'        '||RPAD('Timeouts', 10, ' ')||'        '||RPAD('Time', 10, ' ')||'        '||RPAD('Avg Wait (ms)', 5, ' ')||'        '||RPAD('Waitclass', 20, ' '));
  dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------------------');
  FOR row IN (
              SELECT    event,
                        waits,
                        timeouts,
                        time,
                        avgwait,
                        waitclass
              FROM      (
                        SELECT  e.event_name event,
                                e.total_waits - NVL(b.total_waits,0) waits,
                                e.total_timeouts - NVL(b.total_timeouts,0) timeouts,
                                (e.time_waited_micro - NVL(b.time_waited_micro,0))/1000000  time,
                                DECODE((e.total_waits - NVL(b.total_waits, 0)), 0, TO_NUMBER(NULL),((e.time_waited_micro - NVL(b.time_waited_micro,0))/1000) / (e.total_waits - NVL(b.total_waits,0)) ) avgwait,
                                e.wait_class waitclass
                        FROM    dba_hist_system_event b ,
                                dba_hist_system_event e
                        WHERE   b.snap_id(+) = min_snapid
                        AND     e.snap_id = max_snapid
                        AND     b.event_id(+) = e.event_id
                        AND     e.total_waits > NVL(b.total_waits,0)
                        AND     e.wait_class <> 'Idle'
                        )
              ORDER BY  avgwait desc
              )
  LOOP
    dbms_output.put_line(RPAD(row.event, 45, ' ')||'        '||RPAD(row.waits, 10, ' ')||'        '||RPAD(row.timeouts, 10, ' ')||'        '||RPAD(row.time, 10, ' ')||'        '||RPAD(row.avgwait, 5, ' ')||'        '||RPAD(row.waitclass, 20, ' '));
  END LOOP;
END;
/
