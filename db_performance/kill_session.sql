SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   sid=&sid
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   username='&username'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   event='&event'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   status = 'INACTIVE'
AND     logon_time < SYSDATE - &hrs/1440
AND     type <> 'BACKGROUND'
AND     username = 'CONTENTNR_USER'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   status = 'INACTIVE'
AND     last_call_et > &seconds
AND     type <> 'BACKGROUND'
AND     username = 'CONTENTNR_USER'
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   sql_id = '&sql_id'
AND     sql_child_number = '&child_number'
/
