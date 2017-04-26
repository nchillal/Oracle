COLUMN "Session Information" FORMAT A120
SET VERIFY OFF LINESIZE 155 PAGESIZE 2000
ACCEPT sid      PROMPT 'Please enter the value for Sid if known            : '
ACCEPT terminal PROMPT 'Please enter the value for terminal if known       : '
ACCEPT machine  PROMPT 'Please enter the machine name if known             : '
ACCEPT process  PROMPT 'Please enter the value for Client Process if known : '
ACCEPT spid     PROMPT 'Please enter the value for Server Process if known : '
ACCEPT osuser   PROMPT 'Please enter the value for OS User if known        : '
ACCEPT username PROMPT 'Please enter the value for DB User if known        : '
SELECT  'Inst ID, Sid, Serial#                    : '||s.inst_id||', '||s.sid||','||s.serial#|| CHR(10) ||
        'DB User / OS User                        : '||s.username||' / '||s.osuser|| CHR(10) ||
        'Machine - Terminal                       : '||s.machine||' - '||s.terminal|| CHR(10) ||
        'OS Process Ids                           : '||s.process||' (Client)  '||p.spid||' (Server)'|| ' (Since) '||TO_CHAR(s.logon_time,'DD-MON-YYYY HH24:MI:SS')|| CHR(10) ||
        'Client Program Name, Client Identifier   : '||s.program|| CHR(10) ||
        'Module / Action                          : '||s.module||' / '||s.action|| CHR(10) ||
        'Previous SQL_ID / Child Number           : '||s.prev_sql_id||','||s.prev_child_number|| CHR(10) ||
        'Current SQL_ID / Child Number            : '||s.sql_id||','||s.sql_child_number|| CHR(10) ||
        'Row Details (Obj#, File#, Block#, Row#)  : '||s.row_wait_obj#||', '||s.row_wait_file#||', '||s.row_wait_block#||', '||s.row_wait_row#|| CHR(10) "Session Information"
FROM    gv$process p, gv$session s
WHERE   p.addr = s.paddr
AND     s.sid = NVL('&sid',s.sid)
AND     NVL(s.terminal,' ') = NVL('&terminal',NVL(s.terminal,' '))
AND     NVL(s.process,-1) = NVL('&process',NVL(s.process,-1))
AND     p.spid = NVL('&spid',p.spid)
AND     s.inst_id = p.inst_id
AND     s.username = NVL('&username',s.username)
AND     NVL(s.osuser,' ') = NVL('&osuser',NVL(s.osuser,' '))
AND     NVL(s.machine,' ') = NVL('&machine',NVL(s.machine,' '))
AND     NVL('&sid',NVL('&terminal',NVL('&process',NVL('&spid',NVL('&username', NVL('&osuser',NVL('&machine','NO VALUES'))))))) <> 'NO VALUES'
/
