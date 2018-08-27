SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||',@'||INST_ID||Chr(39)||' IMMEDIATE;'
FROM    gv$session
WHERE   sid=&sid
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||',@'||INST_ID||Chr(39)||' IMMEDIATE;'
FROM    gv$session
WHERE   username='&username'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||',@'||INST_ID||Chr(39)||' IMMEDIATE;'
FROM    gv$session
WHERE   event='&event'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||',@'||INST_ID||Chr(39)||' IMMEDIATE;'
FROM    gv$session
WHERE   status = 'INACTIVE'
AND     logon_time < SYSDATE - INTERVAL '&minutes' MINUTE
AND     type <> 'BACKGROUND'
AND     username = '&username'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||',@'||INST_ID||Chr(39)||' IMMEDIATE;'
FROM    gv$session
WHERE   status = 'INACTIVE'
AND     last_call_et > &seconds
AND     type <> 'BACKGROUND'
AND     username = 'CONTENTNR_USER'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||',@'||INST_ID||Chr(39)||' IMMEDIATE;'
FROM    gv$session
WHERE   sql_id = '&sql_id'
AND     sql_child_number = '&child_number'
/
