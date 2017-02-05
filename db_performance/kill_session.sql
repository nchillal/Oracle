SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   sid=&sid
/

SELECT  'ALTER SYSTEM KILL SESSION '||Chr(39)||SID||','||SERIAL#||Chr(39)||' immediate;'
FROM    v$session
WHERE   username='&username'
/
