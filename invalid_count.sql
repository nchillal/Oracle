set lines 230 pages 200
SELECT    owner,
          COUNT(*)
FROM      dba_objects
WHERE     status='INVALID'
GROUP BY  owner
ORDER BY  2 desc;
