SET LINESIZE 230
COLUMN tablespace_size FORMAT 999,999,999,999
COLUMN allocated_space FORMAT 999,999,999,999
COLUMN free_space FORMAT 999,999,999,999

SELECT *
FROM   dba_temp_free_space
/
