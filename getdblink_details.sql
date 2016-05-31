SET LINESIZE 165 PAGESIZE 100
COLUMN db_link FORMAT a45
COLUMN owner FORMAT a20
COLUMN username FORMAT a20
COLUMN host FORMAT a40

SELECT  * 
FROM    dba_db_links 
WHERE   db_link like '&db_link';
