sqlplus -s "/as sysdba" <<EOF
set linesize 230
COLUMN dest_name FORMAT a30

SELECT  dest_id,
        dest_name,
        db_unique_name,
        status,
        error
FROM    v\$archive_dest_status
WHERE   db_unique_name != 'NONE';
EOF
