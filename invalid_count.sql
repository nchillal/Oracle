SET LINESIZE 230 PAGESIZE 200
SELECT    owner,
          COUNT(*)
FROM      dba_objects
WHERE     status='INVALID'
GROUP BY  owner
ORDER BY  2 desc;

SELECT    owner,
          object_name,
          object_type
FROM      dba_objects
WHERE     status = 'INVALID';
