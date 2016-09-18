set echo off
set linesize 150
set serveroutput on size 1000000
set heading off
set feed off
set veri off
undefine reqid
/* Script Prepared by Vikram Hebbar on 08-10-2002 */
accept reqid prompt 'Request ID: '
DECLARE
TYPE reqdet_rec IS RECORD( request_date DATE,
                            requested_start_date DATE,
                            actual_start_date DATE,
                            actual_completion_date DATE,
                            noa NUMBER(3),
                            paid NUMBER(15),
                            prid NUMBER(15),
                            phase_code VARCHAR2(1),
                            phase VARCHAR2(10),
                            status_code VARCHAR2(1),
                            status VARCHAR2(10),
                            priority NUMBER(15),
                            cmgr NUMBER(15),
                            log VARCHAR2(255),
                            outf VARCHAR2(255),
                            spid NUMBER(30),
                            pid VARCHAR2(240),
                            uname VARCHAR2(100),
                            description VARCHAR2(240),
                            rname VARCHAR2(100),
                            pname VARCHAR2(30),
                            uprname VARCHAR2(240),
                            qaid NUMBER(15),
                            qid NUMBER(15),
                            argument_text VARCHAR2(240),
                            hold_flag VARCHAR2(30));
  reqdet reqdet_rec;
  TYPE q_rec IS RECORD(qname VARCHAR2(30),
                       quname VARCHAR2(240));
  que q_rec;
  l_argq_str VARCHAR2(100);
  l_argo_l VARCHAR2(240);
  CURSOR cparam IS
    SELECT form_left_prompt
    FROM   apps.fnd_descr_flex_col_usage_vl
    WHERE  application_id = reqdet.paid AND
           descriptive_flexfield_name = '$SRS$.' || reqdet.pname
    ORDER  BY column_seq_num ASC;
  noa NUMBER(15);
  l_parm_cnt_o NUMBER(4);
  arg_len NUMBER;
  com_occur NUMBER;
  com_prev NUMBER := 0;
  p_start NUMBER;
  p_length NUMBER;
  l_parm_cnt_q VARCHAR2(240);
  dummy NUMBER;
  label_flag VARCHAR2(1) := 'N';

BEGIN
    --
  SELECT req.request_date,
         req.requested_start_date,
         req.actual_start_date,
         req.actual_completion_date,
         req.number_of_arguments,
         req.program_application_id,
         req.concurrent_program_id,
         req.phase_code,
         decode(req.phase_code,
                'P',
                'Pending',
                'R',
                'Running',
                'C',
                'Completed',
                req.phase_code),
         req.status_code,
         decode(req.status_code,
                'Q',
                'Standby',
                'I',
                'Normal',
                'H',
                'On Hold',
                'C',
                'Normal',
                'M',
                'No Manager',
                'R',
                'Normal',
                'P',
                'Scheduled',
                'S',
                'Suspended',
                'T',
                'Terminating',
                'U',
                'Disabled',
                'W',
                'Paused',
                'X',
                'Terminated',
                'Z',
                'Waiting',
                'B',
                'Resuming',
                'E',
                'Error',
                'D',
                'Cancelled',
                'E',
                'Error',
                req.status_code),
         req.priority,
         req.controlling_manager,
         req.logfile_name,
         req.outfile_name,
         req.oracle_process_id,
         req.os_process_id,
         u.user_name,
         u.description,
         r.responsibility_name,
         p.concurrent_program_name,
         ptl.user_concurrent_program_name,
         req.queue_app_id,
         req.queue_id,
         req.argument_text,
         decode(req.hold_flag,
                'Y',
                '[INACTIVE - ON HOLD]',
                '')
  INTO   reqdet
  FROM   applsys.fnd_concurrent_requests    req,
         applsys.fnd_user                   u,
         applsys.fnd_concurrent_programs    p,
         applsys.fnd_concurrent_programs_tl ptl,
         applsys.fnd_responsibility_tl      r
  WHERE  req.request_id = &reqid AND req.requested_by = u.user_id AND
         req.program_application_id = p.application_id AND
         req.concurrent_program_id = p.concurrent_program_id AND
         p.application_id = ptl.application_id AND
         p.concurrent_program_id = ptl.concurrent_program_id AND
         req.responsibility_application_id = r.application_id AND
         req.responsibility_id = r.responsibility_id AND 
         ROWNUM = 1;

  dbms_output.put_line(rpad('=',110, '='));
  dbms_output.put_line('Concurrent Request Details for Request Id - ' || &reqid);
  dbms_output.put_line(rpad('=', 110, '='));
  dbms_output.put_line(rpad('Request Id', 25,' ') || ' : ' || &reqid);
  dbms_output.put_line(rpad('Phase / Status', 25,' ') || ' : ' || reqdet.phase || ' - ' || reqdet.status || ' - ' || reqdet.hold_flag);
  dbms_output.put_line(rpad('Submitted By', 25, ' ') || ' : ' || reqdet.uname || ' - ' || reqdet.description || ' - ' || reqdet.rname);
  dbms_output.put_line(rpad('Shadow  / Client Process', 25, ' ') || ' : ' || reqdet.spid || ' / ' || reqdet.pid);
  dbms_output.put_line(rpad('Submitted On ', 25, ' ') || ' : ' || to_char(reqdet.request_date, 'MM/DD/YYYY HH24:MI:SS'));
  dbms_output.put_line(rpad('Requested to Run On ', 25,' ') || ' : ' || to_char(reqdet.requested_start_date, 'MM/DD/YYYY HH24:MI:SS'));

  IF reqdet.phase_code = 'C' THEN
    dbms_output.put_line(rpad('Started On / Exec Time', 25, ' ') || ' : ' || to_char(reqdet.actual_start_date, 'MM/DD/YYYY HH24:MI:SS') || ' and ran for ' || to_char(round((reqdet.actual_completion_date - reqdet.actual_start_date) * 1440, 2)) || ' Mins');
  ELSIF reqdet.phase_code = 'R' THEN
    dbms_output.put_line(rpad('Started On / Exec Time', 25, ' ') || ' : ' || to_char(reqdet.actual_start_date, 'MM/DD/YYYY HH24:MI:SS') || ' and is running for ' || to_char(round((SYSDATE - reqdet.actual_start_date) * 1440, 2)) || ' Mins');
  ELSIF reqdet.phase_code = 'P' THEN
    dbms_output.put_line(rpad('Requested On / Wait Time', 25, ' ') || ' : ' || to_char(reqdet.requested_start_date, 'MM/DD/YYYY HH24:MI:SS') || ' and is Pending for ' || to_char(round((SYSDATE - reqdet.requested_start_date) * 1440, 2)) || ' Mins');
  END IF;
  dbms_output.put_line(rpad('Start Date / End Date', 25, ' ') || ' : ' || to_char(reqdet.actual_start_date, 'MM/DD/YYYY HH24:MI:SS') || ' - ' || to_char(reqdet.actual_completion_date, 'MM/DD/YYYY HH24:MI:SS'));
  dbms_output.put_line(rpad('Program Details', 25, ' ') || ' : ' || reqdet.paid || '-' || reqdet.prid || ' - ' || reqdet.pname || ' - ' || reqdet.uprname);
  dbms_output.put_line(rpad('Outfile / Logfile', 25, ' ') || ' : ' || reqdet.outf || ' and ' || reqdet.log);
  IF reqdet.cmgr IS NULL THEN
    dbms_output.put_line('Concurrent Queue Details Not Available');
  ELSE
    BEGIN
      SELECT q.concurrent_queue_name,
             q.user_concurrent_queue_name
      INTO   que
      FROM   apps.fnd_concurrent_queues_tl q,
             apps.fnd_concurrent_processes pr
      WHERE  pr.concurrent_process_id = reqdet.cmgr AND
             pr.queue_application_id = q.application_id AND
             pr.concurrent_queue_id = q.concurrent_queue_id AND 
             ROWNUM = 1;
             
      dbms_output.put_line(rpad('Conc Queue Dtls', 25, ' ') || ' : ' || que.qname || ' - ' || que.quname || ' - w' || reqdet.cmgr);
    EXCEPTION
      WHEN no_data_found THEN
        dbms_output.put_line('Concurrent Queue Details Not Available');
        --return;
    END;
  END IF;
  l_parm_cnt_q := 'SELECT count(form_left_prompt) FROM apps.fnd_descr_flex_col_usage_vl  where application_id=' || reqdet.paid || ' and  descriptive_flexfield_name = ''$SRS$.' || reqdet.pname || '''';
  EXECUTE IMMEDIATE l_parm_cnt_q
    INTO l_parm_cnt_o;
  dbms_output.put_line(rpad('Number of User Args', 25,' ') || ' : ' || l_parm_cnt_o);
  dbms_output.put_line(rpad('Number of Args', 25,' ') || ' : ' || to_char(reqdet.noa));
  SELECT length(reqdet.argument_text)
  INTO   arg_len
  FROM   dual;
  IF l_parm_cnt_o > 0 THEN
    label_flag := 'D';
  ELSIF reqdet.noa > 0 THEN
    label_flag := 'P';
  ELSE
    label_flag := 'N';
  END IF;
  dbms_output.put_line(rpad('-',
                            110,
                            '-'));
  dbms_output.put_line('Parameter Listing');
  dbms_output.put_line(rpad('-', 110, '-'));
  IF label_flag = 'D' THEN
    noa := 1;
    FOR parm_rec IN cparam
    LOOP
      IF noa <> l_parm_cnt_o THEN
        SELECT instr(reqdet.argument_text, ',',  1, noa)
        INTO   com_occur
        FROM   dual;
        p_start  := com_prev + 1;
        p_length := com_occur - p_start;
        com_prev := com_occur;
      ELSE
        p_start  := com_prev + 1;
        p_length := arg_len - p_start + 1;
      END IF;
      SELECT substr(reqdet.argument_text, p_start, p_length)
      INTO   l_argo_l
      FROM   dual;
      dbms_output.put_line(rpad(to_char(noa) || '. ' || parm_rec.form_left_prompt, 40, ' ') || ' : ' || nvl(ltrim(rtrim(l_argo_l)), 'NULL'));
      noa := noa + 1;
    END LOOP;
  ELSIF label_flag = 'P' THEN
    noa := 0;
    FOR i IN 1 .. reqdet.noa - 1
    LOOP
      SELECT instr(reqdet.argument_text, ',', 1, i)
      INTO   dummy
      FROM   dual;
      IF dummy <> 0 THEN
        noa := noa + 1;
      END IF;
    END LOOP;
    noa      := noa + 1;
    com_prev := 0;
    FOR i IN 1 .. noa
    LOOP
      IF i <> noa THEN
        SELECT instr(reqdet.argument_text, ',', 1, i)
        INTO   com_occur
        FROM   dual;
        p_start  := com_prev + 1;
        p_length := com_occur - p_start;
        com_prev := com_occur;
      ELSE
        p_start  := com_prev + 1;
        p_length := arg_len - p_start + 1;
      END IF;
      SELECT substr(reqdet.argument_text,
                    p_start,
                    p_length)
      INTO   l_argo_l
      FROM   dual;
      dbms_output.put_line(rpad('Parameter ' || to_char(i), 25,' ') || ' : ' || nvl(ltrim(rtrim(l_argo_l)), 'NULL'));
    END LOOP;
  ELSIF label_flag = 'N' THEN
    dbms_output.put_line('No arguments exist for this request. The argument text is given below.');
    dbms_output.put_line(reqdet.argument_text);
  END IF;
  dbms_output.put_line(rpad('=', 110, '='));
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    dbms_output.put_line(rpad('=', 110, '='));
    RETURN;
END;
/
set heading on
set feed on
set veri on
undefine reqid
set echo on
