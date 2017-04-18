SELECT    *
FROM      (
          SELECT  snap_id,
                  end_time,
                  metric_name,
                  maxval
          FROM    dba_hist_sysmetric_summary
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('Current Logons Count' ,'Process Limit %','Session Limit %')
          )
ORDER BY  snap_id;
