set linesize 230 pagesize 200
SELECT    NVL(b.tablespace_name, NVL(a.tablespace_name,'UNKNOWN')) "Tablespace",
          ROUND(kbytes_alloc, 2) "Allocated MB",
          ROUND(kbytes_alloc-NVL(kbytes_free,0), 2) "Used MB",
          ROUND(NVL(kbytes_free,0), 2) "Free MB",
          TRUNC(((kbytes_alloc-NVL(kbytes_free,0))/kbytes_alloc) * 100, 2) "Used %",
          data_files "Data Files"
FROM      ( SELECT    SUM(bytes)/1024/1024 Kbytes_free,
                      MAX(bytes)/1024/1024 largest,
                      tablespace_name
            FROM      sys.dba_free_space
            GROUP BY  tablespace_name
          ) a,
          (   SELECT  SUM(bytes)/1024/1024 Kbytes_alloc,
                      tablespace_name,
                      COUNT(*) data_files
            FROM      sys.dba_data_files
            GROUP BY  tablespace_name
          ) b
WHERE     a.tablespace_name (+) = b.tablespace_name
ORDER BY  1;
