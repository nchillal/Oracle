SET lines 155 pages 200
COLUMN name FORMAT a40
COLUMN value FORMAT a80

SELECT  name, value 
FROM    v$spparameter 
WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND regexp_like (value, 'service=*')
UNION 
SELECT  name, value
FROM    v$spparameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_state_+\d')
AND     value IS NOT NULL
/
