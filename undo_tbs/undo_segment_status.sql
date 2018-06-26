SELECT    tablespace_name,
          ROUND(SUM(case when status = 'UNEXPIRED' then bytes else 0 end) / (1024 * 1024 * 1024), 2.2) unexp_MB ,
          ROUND(SUM(case when status = 'EXPIRED' then bytes else 0end) / (1024 * 1024 * 1024), 2.2) exp_MB ,
          ROUND(SUM(case when status = 'ACTIVE' then bytes else 0 end) / (1024 * 1024 * 1024), 2.2) act_MB
FROM      dba_undo_extents
GROUP BY  tablespace_name;
