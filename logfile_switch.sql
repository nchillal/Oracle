set serveroutput on 
declare
	v_arch_log_idle_mins_threshold number:=25;
	v_arch_log_idle_mins number; 
begin 
	SELECT 	(SYSDATE-COMPLETION_TIME)*24*60 INTO v_arch_log_idle_mins 
	FROM 		v$archived_log 
	WHERE 	sequence# = (SELECT max(sequence#) FROM v$log_history) AND dest_id=1;

	IF v_arch_log_idle_mins > v_arch_log_idle_mins_threshold THEN
		DBMS_OUTPUT.PUT_LINE(CHR(10)||'Archive log idle minutes is '||v_arch_log_idle_mins||' which is above threshold '||v_arch_log_idle_mins_threshold);
		execute immediate 'alter system switch logfile';
	ELSE
		DBMS_OUTPUT.PUT_LINE(CHR(10)||'Archive log idle minutes is '||v_arch_log_idle_mins||' which is within threshold '||v_arch_log_idle_mins_threshold);
	END IF;
end; 
/
