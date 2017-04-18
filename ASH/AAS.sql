SELECT    snap_id, end_time, ROUND(aas, 2) AS AAS
FROM      (
          SELECT  snap_id,
                  end_time,
                  metric_name,
                  maxval
          FROM    dba_hist_sysmetric_summary
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('Average Active Sessions' AS AAS)
          )
ORDER BY  snap_id;
