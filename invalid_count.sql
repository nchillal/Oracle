set lines 230 pages 200
select owner, count(*) from dba_objects where status='INVALID' group by owner order by 2 desc;
