SELECT    *
FROM      (
          SELECT  snap_id,
                  end_time,
                  metric_name,
                  maxval
          FROM    dba_hist_sysmetric_summary
          )
PIVOT     (
          MAX(ROUND(maxval, 2))
          FOR metric_name IN ('Current Logons Count' AS CURRENT_LOGON_COUNT ,'Process Limit %' AS PROCESSES_PERCENTAGE,'Session Limit %' AS SESSIONS_PERCENTAGE)
          )
ORDER BY  snap_id;
