SET pagesize 230 linesize 110 trims on 
COLUMN name FORMAT a30  
COLUMN username FORMAT a30 
BREAK ON username NODUP SKIP 1 

SELECT    vses.username||':'||vsst.sid||','||vses.serial# username, vstt.name, MAX(vsst.value) value  
FROM      v$sesstat vsst, v$statname vstt, v$session vses 
WHERE     vstt.statistic# = vsst.statistic# 
AND       vsst.sid = vses.sid 
AND       vstt.name IN (
                        'session pga memory',
                        'session pga memory max',
                        'session uga memory',
                        'session uga memory max',  
                        'session cursor cache count',
                        'session cursor cache hits',
                        'session stored procedure space', 
                        'opened cursors current',
                        'opened cursors cumulative'
                        ) 
AND       vses.username IS NOT NULL 
GROUP BY  vses.username, vsst.sid, vses.serial#, vstt.name 
ORDER BY  vses.username, vsst.sid, vses.serial#, vstt.name; 
