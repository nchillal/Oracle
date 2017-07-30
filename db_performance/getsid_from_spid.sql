SET PAGESIZE 1000 LINESIZE 260

COLUMN "SID, SERIAL#" FORMAT a15
COLUMN module FORMAT a50
COLUMN spid FORMAT a7
COLUMN username FORMAT a20
COLUMN event FORMAT a50

SELECT  sid||','||serial# "SID, SERIAL#", b.spid, username, status, logon_time, last_call_et, sql_id, sql_child_number, event, module
FROM    (SELECT sid, serial#, paddr, username, status, sql_id, sql_child_number, event, module, client_info, type, logon_time, last_call_et FROM v$session) a,
        (SELECT spid, addr FROM v$process) b
WHERE   a.paddr = b.addr
AND     a.status = 'ACTIVE'
AND     a.type <> 'BACKGROUND';
