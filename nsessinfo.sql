rem ********************************************************************
rem * Filename          : sessinfo.sql - Version 1.0
rem * Description       : Information about a specified session
rem * Usage             : start sessinfo.sql
rem ********************************************************************

def aps_prog    = 'sessinfo.sql'
def aps_title   = 'Session information'

COLUMN "Session Info" FORMAT A85
set verify off
ACCEPT sid      PROMPT 'Please enter the value for Sid if known            : '
ACCEPT terminal PROMPT 'Please enter the value for terminal if known       : '
ACCEPT machine  PROMPT 'Please enter the machine name if known             : '
ACCEPT process  PROMPT 'Please enter the value for Client Process if known : '
ACCEPT spid     PROMPT 'Please enter the value for Server Process if known : '
ACCEPT osuser   PROMPT 'Please enter the value for OS User if known        : '
ACCEPT username PROMPT 'Please enter the value for DB User if known        : '
SELECT  ' Sid, Serial#, Aud sid : '|| s.sid||' , '||s.serial#||' , '||
       s.audsid||' , '||s.inst_id||chr(10)|| '     DB User / OS User : '||s.username||
       '   /   '||s.osuser||chr(10)|| '    Machine - Terminal : '||
       s.machine||'  -  '|| s.terminal||chr(10)||
       '        OS Process Ids : '||
       s.process||' (Client)  '||p.spid||' (Server)'|| ' (Since) '||to_char(s.logon_time,'DD-MON-YYYY HH24:MI:SS')||chr(10)||
       '   Client Program Name : '||s.program||chr(10) "Session Info",
	   '   Action / Module     : '||s.action||'  / '||s.module||chr(10) ||'User Name : '
FROM    gv$process p,gv$session s
WHERE   p.addr = s.paddr
AND     s.sid = NVL('&SID',s.sid)
AND     NVL(s.terminal,' ') = NVL('&Terminal',NVL(s.terminal,' '))
AND     NVL(s.process,-1) = NVL('&Process',NVL(s.process,-1))
AND     p.spid = NVL('&spid',p.spid)
AND     s.inst_id=p.inst_id
AND     s.username = NVL('&username',s.username)
AND     NVL(s.osuser,' ') = NVL('&OSUser',NVL(s.osuser,' '))
AND     NVL(s.machine,' ') = NVL('&machine',NVL(s.machine,' '))
AND     NVL('&SID',NVL('&TERMINAL',NVL('&PROCESS',NVL('&SPID',NVL('&USERNAME',
        NVL('&OSUSER',NVL('&MACHINE','NO VALUES'))))))) <> 'NO VALUES'
/
undefine sid
