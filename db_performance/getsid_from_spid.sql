SELECT  sid, serial#, sql_id, event, type, module, client_info, status
FROM    v$session
WHERE   paddr IN (SELECT addr FROM v$process WHERE spid=&spid)
/
