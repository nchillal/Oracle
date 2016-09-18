set linesize 230
COL tablespace_size FORMAT 999,999,999,999
COL allocated_space FORMAT 999,999,999,999
COL free_space FORMAT 999,999,999,999

SELECT *
FROM   dba_temp_free_space
/
