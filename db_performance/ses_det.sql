CLEAR COLUMNS BREAK COMPUTE
SET LINES 100 PAGES 100 PAUSE OFF VERIFY OFF FEEDBACK ON ECHO OFF
PROMPT

COLUMN Active4 FORMAT A7 HEADING STATUS
COLUMN sssu FORMAT A23 HEADING "SPID   SID   UPID"
COLUMN hoo  FORMAT A68 HEADING "USERNAME [ OSUSER ] MACHINE [ MODULE ] PROGRAM [ ACTION ]" TRUN

SELECT    v.username||'['||v.osuser||']'||v.machine||'['||NVL(module,'x')||']'||NVL(v.program,'x')||'['||NVL(action,'x')||']' hoo,
          LPAD(NVL(p.spid,'x'),6)||' '||LPAD(v.sid,5)||' '||ltrim(v.process) sssu,
          SUBSTR(v.status,1,1) || LPAD(((last_call_et/60)-mod((last_call_et/60),60))/60,2,'0') ||':'|| LPAD(ROUND(mod((last_call_et/60),60)),2,'0')||'H' Active4
FROM      v$session v, v$process p
WHERE     v.paddr = p.addr
AND       v.username IS NOT NULL
AND       UPPER(v.sid) LIKE UPPER(NVL('&sid________', v.sid))
AND       UPPER(p.spid) LIKE UPPER(NVL('&spid_______', p.spid))
AND       UPPER(v.process) LIKE UPPER(NVL('&process_______', v.process))
AND       UPPER(v.username) LIKE UPPER(NVL('&ora_usr____', v.username))
AND       UPPER(v.osuser) LIKE UPPER(NVL('&os_usr_____', v.osuser))
AND       UPPER(v.machine) LIKE UPPER(NVL('&machine____', v.machine))
AND       SUBSTR(v.status,1,1) LIKE UPPER(NVL('&status_I_A_','A'))
AND       p.username IS NOT NULL
ORDER  BY status, last_call_et
/

SET PAGES 32 PAUSE OFF VERIFY OFF FEEDBACK ON ECHO OFF
PROMPT
