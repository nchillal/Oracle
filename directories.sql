SET LINESIZE 230 PAGESIZE 200
COLUMN directory_path FORMAT a80
SELECT  *
FROM    dba_directories;

SELECT      directory_name, grantee, privilege
FROM        dba_tab_privs t, all_directories d
WHERE       t.table_name(+)=d.directory_name
ORDER BY    1,2,3;