set linesize 230 pagesize 200
SELECT    owner,
          COUNT(*)
FROM      dba_objects
WHERE     status='INVALID'
GROUP BY  owner
ORDER BY  2 desc;
