set serveroutput on
DECLARE
	min_snapid NUMBER(10);
	max_snapid NUMBER(10);
BEGIN
	SELECT MIN(snap_id), MAX(snap_id) INTO min_snapid, max_snapid FROM dba_hist_active_sess_history WHERE SAMPLE_TIME > SYSDATE - &min/1440;
	SELECT MAX(snap_id) into max_snapid from dba_hist_active_sess_history where SAMPLE_TIME > SYSDATE - &end_min/1440;

	dbms_output.put_line(chr(10)||'Min snapid: '||min_snapid);
	dbms_output.put_line('Max snapid: '||max_snapid);
	dbms_output.put_line(chr(10)||'Top SQL_ID being executed between snapshots '||min_snapid||' and '||max_snapid);
	dbms_output.put_line('--------------------------------------------------------');
	dbms_output.put_line(RPAD('SQL_ID', 15, ' ')||'        '||RPAD('Child Number', 15, ' ')||'        '||'Count');
	dbms_output.put_line('--------------------------------------------------------');
  FOR row IN  (
              SELECT    *
              FROM      (
                        SELECT    sql_id, sql_child_number, COUNT(*) count
                        FROM      dba_hist_active_sess_history
                        WHERE     snap_id between min_snapid AND max_snapid
                        AND       sql_id IS NOT NULL
                        GROUP BY  sql_id, sql_child_number
                        ORDER BY  3 DESC
                        )
              WHERE     rownum < 10
              )
  LOOP
    dbms_output.put_line(RPAD(row.sql_id, 15, ' ')||'        '||RPAD(row.sql_child_number, 15, ' ')||'        '||row.count);
  END LOOP;
END;
/
