SET linesize 200 pagesize 200
COLUMN name FORMAT a30
COLUMN value FORMAT a140

SELECT  name, value
FROM    v$parameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=*|SERVICE=*')
UNION
SELECT  name, value
FROM    v$parameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_state_+\d')
AND     name IN (
                  SELECT  'log_archive_dest_state_'||REGEXP_SUBSTR(name, '[0-9]+')
                  FROM    v$parameter
                  WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=*|SERVICE=*')
)
/

SELECT  name, value
FROM    v$parameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=&&service_name|SERVICE=&&service_name')
UNION
SELECT  name, value
FROM    v$parameter
WHERE   REGEXP_LIKE(name, 'log_archive_dest_state_+\d')
AND     name IN (
                  SELECT  'log_archive_dest_state_'||REGEXP_SUBSTR(name, '[0-9]+')
                  FROM    v$parameter
                  WHERE   REGEXP_LIKE(name, 'log_archive_dest_\d+') AND REGEXP_LIKE (value, 'service=&&service_name|SERVICE=&&service_name')
)
/
