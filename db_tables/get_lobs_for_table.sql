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
