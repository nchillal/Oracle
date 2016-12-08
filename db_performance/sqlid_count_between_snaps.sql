set serveroutput on
declare
	min_snapid number(10);
	max_snapid number(10);
begin
	select min(snap_id), max(snap_id) into min_snapid, max_snapid from dba_hist_active_sess_history where SAMPLE_TIME > SYSDATE - &min/1440;
	IF min_snapid = max_snapid THEN
		min_snapid := min_snapid - 1;
	END IF;

	dbms_output.put_line(chr(10)||'Min snapid: '||min_snapid);
	dbms_output.put_line('Max snapid: '||max_snapid);
	dbms_output.put_line(chr(10)||'Top SQL_ID being executed between snapshots '||min_snapid||' and '||max_snapid);
	dbms_output.put_line(chr(10)||'--------------------------------------------------------');
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
end;
/
