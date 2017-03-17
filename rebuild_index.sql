sqlplus -s "/as sysdba" <<!
SET LINES 155 PAGES 2000 FEED OFF HEAD OFF ECHO OFF TERM OFF TRIMSPOOL ON
SPOOL     index_partition.sql
SELECT    'SET ECHO ON TIMING ON' FROM DUAL;
SELECT    'ALTER INDEX '||index_owner||'.'||index_name||' REBUILD PARTITION '||PARTITION_NAME||' ONLINE PARALLEL 16;'
FROM      dba_ind_partitions
WHERE     index_name='&index_name'
ORDER BY  partition_name;
SPOOL OFF
!
