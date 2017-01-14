SET linesize 155 pagesize 200
COLUMN name FORMAT a30
COLUMN value FORMAT a120


SELECT  name, value
FROM    v$spparameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=*')
UNION
SELECT  name, value
FROM    v$spparameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_state_+\d')
AND     name IN (
                  SELECT  'log_archive_dest_state_'||REGEXP_SUBSTR(name, '[0-9]+')
                  FROM    v$spparameter
                  WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=*')
)
/
