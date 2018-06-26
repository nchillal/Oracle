SELECT    tablespace_name,
          ROUND(SUM(CASE WHEN status = 'UNEXPIRED' THEN bytes ELSE 0 END) / (1024 * 1024 * 1024), 2.2) unexp_MB ,
          ROUND(SUM(CASE WHEN status = 'EXPIRED' THEN bytes ELSE 0 END) / (1024 * 1024 * 1024), 2.2) exp_MB ,
          ROUND(SUM(CASE WHEN status = 'ACTIVE' THEN bytes else 0 END) / (1024 * 1024 * 1024), 2.2) act_MB
FROM      dba_undo_extents
GROUP BY  tablespace_name;
