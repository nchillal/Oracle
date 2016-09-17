set linesize 230
COLUMN dest_name FORMAT a30

SELECT  dest_id,
        dest_name,
        status,
        error
FROM    V$ARCHIVE_DEST_STATUS
WHERE   dest_id < 3;
