SET linesize 155 pagesize 200
COLUMN name FORMAT a40
COLUMN value FORMAT a80

SELECT  name, value
FROM    v$spparameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=*')
UNION
SELECT  name, value
FROM    v$spparameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_state_+\d')
AND     value IS NOT NULL
/

SELECT  value
FROM    v$parameter
WHERE   name='&param_name'
/
