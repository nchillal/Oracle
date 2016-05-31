rem ********************************************************************
rem * Filename          : sessinfo.sql - Version 1.0
rem * Author            : Virag Saksena
rem * Original          : 20-OCT-95
rem * Last Update       : 14-DEC-95
rem * Description       : Information about a specified session
rem * Usage             : start sessinfo.sql
rem ********************************************************************

def aps_prog    = 'sessinfo.sql'
def aps_title   = 'Session information'

col "Session Info" form A85
set verify off
accept sid      prompt 'Please enter the value for Sid if known            : '
accept terminal prompt 'Please enter the value for terminal if known       : '
accept machine  prompt 'Please enter the machine name if known             : '
accept process  prompt 'Please enter the value for Client Process if known : '
accept spid     prompt 'Please enter the value for Server Process if known : '
accept osuser   prompt 'Please enter the value for OS User if known        : '
accept username prompt 'Please enter the value for DB User if known        : '
select ' Sid, Serial#, Aud sid : '|| s.sid||' , '||s.serial#||' , '||
       s.audsid||' , '||s.inst_id||chr(10)|| '     DB User / OS User : '||s.username||
       '   /   '||s.osuser||chr(10)|| '    Machine - Terminal : '||
       s.machine||'  -  '|| s.terminal||chr(10)||
       '        OS Process Ids : '||
       s.process||' (Client)  '||p.spid||' (Server)'|| ' (Since) '||to_char(s.logon_time,'DD-MON-YYYY HH24:MI:SS')||chr(10)||
       '   Client Program Name : '||s.program||chr(10) "Session Info",
	   '   Action / Module     : '||s.action||'  / '||s.module||chr(10) ||'User Name : '
  from gv$process p,gv$session s 
 where p.addr = s.paddr
   and s.sid = nvl('&SID',s.sid)
   and nvl(s.terminal,' ') = nvl('&Terminal',nvl(s.terminal,' '))
   and nvl(s.process,-1) = nvl('&Process',nvl(s.process,-1))
   and p.spid = nvl('&spid',p.spid)
   and s.inst_id=p.inst_id
   and s.username = nvl('&username',s.username)
   and nvl(s.osuser,' ') = nvl('&OSUser',nvl(s.osuser,' '))
   and nvl(s.machine,' ') = nvl('&machine',nvl(s.machine,' '))
   and nvl('&SID',nvl('&TERMINAL',nvl('&PROCESS',nvl('&SPID',nvl('&USERNAME',
       nvl('&OSUSER',nvl('&MACHINE','NO VALUES'))))))) <> 'NO VALUES'
/
undefine sid
