col sid format 99999
col username format a10
col osuser format a10
col program format a25
col process format 9999999
col spid format 999999
col logon_time format a13

set lines 150

set heading off
set verify off
set feedback off

undefine sid_number
undefine spid_number
rem accept sid_number number prompt "pl_enter_sid:"

col sid NEW_VALUE sid_number noprint
col spid NEW_VALUE spid_number noprint


         select  s.sid   sid,
                p.spid  spid
--              ,decode(count(*), 1,'null','No Session Found with this info') " "
         FROM v$session s,
              v$process p
         WHERE s.sid LIKE NVL('&sid', '%')
         AND p.spid LIKE NVL ('&OS_ProcessID', '%')
         AND s.process LIKE NVL('&Client_Process', '%')
         AND s.paddr = p.addr
--       group by s.sid, p.spid;

PROMPT Session and Process Information
PROMPT -------------------------------

col event for a30

select '    SID                         : '||v.sid      || chr(10)||
       '    Serial Number               : '||v.serial#  || chr(10) ||
       '    Oracle User Name            : '||v.username         || chr(10) ||
       '    Client OS user name         : '||v.osuser   || chr(10) ||
       '    Client Process ID           : '||v.process  || chr(10) ||
       '    Client machine Name         : '||v.machine  || chr(10) ||
       '    Oracle PID                  : '||p.pid      || chr(10) ||
       '    OS Process ID(spid)         : '||p.spid     || chr(10) ||
       '    Session''s Status           : '||v.status   || chr(10) ||
       '    Logon Time                  : '||to_char(v.logon_time, 'MM/DD HH24:MIpm')   || chr(10) ||
       '    Program Name                : '||v.program  || chr(10) ||
       '    module                      : '||v.module   || chr(10) ||
       '    Hashvalue                   : '||v.sql_hash_value   || chr(10)
from v$session v, v$process p
where v.paddr = p.addr
and v.serial# > 1
and p.background is null
and p.username is not null
and sid = &sid_number
order by logon_time, v.status, 1
/


PROMPT Sql Statement
PROMPT --------------

select sql_text
from v$sqltext , v$session
where v$sqltext.address = v$session.sql_address
and sid = &sid_number
order by piece
/

PROMPT
PROMPT Event Wait Information
PROMPT ----------------------

select '   SID '|| &sid_number ||' is waiting on event  : ' || x.event || chr(10) ||
       '   P1 Text                      : ' || x.p1text || chr(10) ||
       '   P1 Value                     : ' || x.p1 || chr(10) ||
       '   P2 Text                      : ' || x.p2text || chr(10) ||
       '   P2 Value                     : ' || x.p2 || chr(10) ||
       '   P3 Text                      : ' || x.p3text || chr(10) ||
       '   P3 Value                     : ' || x.p3
from v$session_wait x
where x.sid= &sid_number
/

PROMPT
PROMPT Session Statistics
PROMPT ------------------

select        '     '|| b.name  ||'             : '||decode(b.name, 'redo size', round(a.value/1024/1024,2)||' M', a.value)
from v$session s, v$sesstat a, v$statname b
where a.statistic# = b.statistic#
and name in ('redo size', 'parse count (total)', 'parse count (hard)', 'user commits')
and s.sid = &sid_number
and a.sid = &sid_number
--order by b.name
order by decode(b.name, 'redo size', 1, 2), b.name
/

COLUMN USERNAME FORMAT a10
COLUMN status FORMAT a8
column RBS_NAME format a10

PROMPT
PROMPT Transaction and Rollback Information
PROMPT ------------------------------------

select        '    Rollback Used                : '||t.used_ublk*8192/1024/1024 ||' M'          || chr(10) ||
              '    Rollback Records             : '||t.used_urec        || chr(10)||
              '    Rollback Segment Number      : '||t.xidusn           || chr(10)||
              '    Rollback Segment Name        : '||r.name             || chr(10)||
              '    Logical IOs                  : '||t.log_io           || chr(10)||
              '    Physical IOs                 : '||t.phy_io           || chr(10)||
              '    RBS Startng Extent ID        : '||t.start_uext       || chr(10)||
              '    Transaction Start Time       : '||t.start_time       || chr(10)||
              '    Transaction_Status           : '||t.status
FROM v$transaction t, v$session s, v$rollname r
WHERE t.addr = s.taddr
and r.usn = t.xidusn
and s.sid = &sid_number
/

PROMPT
PROMPT Sort Information
PROMPT ----------------

column username format a20
column user format a20
column tablespace format a20

SELECT        '    Sort Space Used(8k block size is asssumed    : '||u.blocks/1024*8 ||' M'             || chr(10) ||
              '    Sorting Tablespace                           : '||u.tablespace       || chr(10)||
              '    Sort Tablespace Type                 : '||u.contents || chr(10)||
              '    Total Extents Used for Sorting               : '||u.extents
FROM v$session s, v$sort_usage u
WHERE s.saddr = u.session_addr
AND s.sid = &sid_number
/


set heading on
set verify on

clear column

