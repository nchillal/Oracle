SET LINESIZE 155 PAGESIZE 2000
COLUMN column_name FORMAT a30
COLUMN tablespace_name FORMAT a20
COLUMN owner FORMAT a20
COLUMN index_name FORMAT a25
SELECT    s.owner,
          s.tablespace_name,
          l.segment_name,
          l.column_name,
          l.index_name,
          s.header_file,
          s.header_block
FROM      dba_segments s, dba_lobs l
WHERE     s.owner=l.owner
AND       s.segment_name=l.segment_name
AND       s.segment_type='LOBSEGMENT'
AND       s.owner='&owner_name'
AND       l.table_name='&table_name';


BREAK ON day SKIP 1
COMPUTE SUM LABEL 'TOTAL_BYTES' OF BYTES ON day
COLUMN bytes FORMAT 999,999,999,999,999

ACCEPT table_name CHAR PROMPT 'Enter table name: '
SELECT  TO_CHAR(SYSDATE, 'HH24:MI:SS') DAY, segment_name, bytes
FROM    dba_segments
WHERE   segment_name IN
(
  SELECT '&table_name' "object" FROM dual
  UNION
  SELECT segment_name "object" FROM dba_lobs WHERE table_name='&table_name'
  UNION
  SELECT index_name "object" FROM dba_lobs WHERE table_name='&table_name'
)
ORDER BY 3;
