SELECT  a.tablespace_name, SIZEMB, USAGEMB, (SIZEMB - USAGEMB) FREEMB
FROM      (
          SELECT ROUND(SUM(bytes)/1024/1024) SIZEMB, b.tablespace_name
          FROM      dba_data_files a, dba_tablespaces b
          WHERE     a.tablespace_name = b.tablespace_name
          AND       b.contents = 'UNDO'
          GROUP BY  b.tablespace_name
          ) a,
          (
          SELECT    c.tablespace_name, ROUND(SUM(bytes)/1024/1024) USAGEMB
          FROM      dba_undo_extents c
          WHERE     status <> 'EXPIRED'
          GROUP BY  c.tablespace_name
          ) b
WHERE     a.tablespace_name = b.tablespace_name;
