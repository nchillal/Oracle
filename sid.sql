COLUMN sid FORMAT 99999
COLUMN username FORMAT a10
COLUMN osuser FORMAT a10
COLUMN program FORMAT a25
COLUMN process FORMAT 9999999
COLUMN spid FORMAT 999999
COLUMN logon_time FORMAT a13

set lines 150

set heading off
set verify off
set feedback off

undefine sid_number
undefine spid_number
rem accept sid_number number prompt "pl_enter_sid:"

COLUMN sid NEW_VALUE sid_number noprint
COLUMN spid NEW_VALUE spid_number noprint


SELECT    s.sid   sid,
          p.spid  spid
          --,decode(count(*), 1,'null','No Session Found with this info') " "
FROM      v$session s, v$process p
WHERE     s.sid LIKE NVL('&sid', '%')
AND       p.spid LIKE NVL ('&OS_ProcessID', '%')
AND       s.process LIKE NVL('&Client_Process', '%')
AND       s.paddr = p.addr
--group by s.sid, p.spid;

PROMPT Session AND Process InFORMATion
PROMPT -------------------------------

col event for a30

SELECT    '    SID                         : '||v.sid      || CHR(10)||
          '    Serial Number               : '||v.serial#  || CHR(10) ||
          '    Oracle User Name            : '||v.username         || CHR(10) ||
          '    Client OS user name         : '||v.osuser   || CHR(10) ||
          '    Client Process ID           : '||v.process  || CHR(10) ||
          '    Client machine Name         : '||v.machine  || CHR(10) ||
          '    Oracle PID                  : '||p.pid      || CHR(10) ||
          '    OS Process ID(spid)         : '||p.spid     || CHR(10) ||
          '    Session''s Status           : '||v.status   || CHR(10) ||
          '    Logon Time                  : '||to_char(v.logon_time, 'MM/DD HH24:MIpm')   || CHR(10) ||
          '    Program Name                : '||v.program  || CHR(10) ||
          '    module                      : '||v.module   || CHR(10) ||
          '    Hashvalue                   : '||v.sql_hash_value   || CHR(10)
FROM      v$session v, v$process p
WHERE     v.paddr = p.addr
AND       v.serial# > 1
AND       p.background IS NULL
AND       p.username IS NOT NULL
AND       sid = &sid_number
ORDER BY  logon_time, v.status, 1
/


PROMPT Sql Statement
PROMPT --------------

SELECT    sql_text
FROM      v$sqltext , v$session
WHERE     v$sqltext.address = v$session.sql_address
AND       sid = &sid_number
ORDER BY  piece
/

PROMPT
PROMPT Event Wait InFORMATion
PROMPT ----------------------

SELECT    '   SID '|| &sid_number ||' is waiting on event  : ' || x.event || CHR(10) ||
          '   P1 Text                      : ' || x.p1text || CHR(10) ||
          '   P1 Value                     : ' || x.p1 || CHR(10) ||
          '   P2 Text                      : ' || x.p2text || CHR(10) ||
          '   P2 Value                     : ' || x.p2 || CHR(10) ||
          '   P3 Text                      : ' || x.p3text || CHR(10) ||
          '   P3 Value                     : ' || x.p3
FROM      v$session_wait x
WHERE     x.sid= &sid_number
/

PROMPT
PROMPT Session Statistics
PROMPT ------------------

SELECT    '     '|| b.name  ||'             : '||decode(b.name, 'redo size', round(a.value/1024/1024,2)||' M', a.value)
FROM      v$session s, v$sesstat a, v$statname b
WHERE     a.statistic# = b.statistic#
AND       name IN ('redo size', 'parse count (total)', 'parse count (hard)', 'user commits')
AND       s.sid = &sid_number
AND       a.sid = &sid_number
--ORDER BY b.name
ORDER BY  DECODE(b.name, 'redo size', 1, 2), b.name
/

COLUMN USERNAME FORMAT a10
COLUMN status FORMAT a8
COLUMN RBS_NAME FORMAT a10

PROMPT
PROMPT Transaction AND Rollback Information
PROMPT ------------------------------------

SELECT        '    Rollback Used                : '||t.used_ublk*8192/1024/1024 ||' M'          || CHR(10) ||
              '    Rollback Records             : '||t.used_urec        || CHR(10)||
              '    Rollback Segment Number      : '||t.xidusn           || CHR(10)||
              '    Rollback Segment Name        : '||r.name             || CHR(10)||
              '    Logical IOs                  : '||t.log_io           || CHR(10)||
              '    Physical IOs                 : '||t.phy_io           || CHR(10)||
              '    RBS Startng Extent ID        : '||t.start_uext       || CHR(10)||
              '    Transaction Start Time       : '||t.start_time       || CHR(10)||
              '    Transaction_Status           : '||t.status
FROM          v$transaction t, v$session s, v$rollname r
WHERE         t.addr = s.taddr
AND           r.usn = t.xidusn
AND           s.sid = &sid_number
/

PROMPT
PROMPT Sort InFORMATion
PROMPT ----------------

COLUMN username FORMAT a20
COLUMN user FORMAT a20
COLUMN tablespace FORMAT a20

SELECT        '    Sort Space Used(8k block size is asssumed    : '||u.blocks/1024*8 ||' M'             || CHR(10) ||
              '    Sorting Tablespace                           : '||u.tablespace       || CHR(10)||
              '    Sort Tablespace Type                 : '||u.contents || CHR(10)||
              '    Total Extents Used for Sorting               : '||u.extents
FROM          v$session s, v$sort_usage u
WHERE         s.saddr = u.session_addr
AND           s.sid = &sid_number
/

set heading on
set verify on

clear COLUMN
