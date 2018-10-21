-- Important database metrics from AWR.
BREAK ON snap_id SKIP 1
SELECT    instance_number,
          end_time,
          AAS, UCPS, UTPS, EPS, DTPS, DBGPS, PRBPS, TSU, LRPS, PWBPS
FROM      (
          SELECT  snap_id,
                  instance_number,
                  end_time,
                  metric_name,
                  ROUND(maxval) maxval
          FROM    dba_hist_sysmetric_summary
          WHERE   end_time >= SYSDATE - INTERVAL '&days' day
          AND     REGEXP_LIKE(instance_number, '&instance_number')
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('Average Active Sessions' AS AAS, 'User Commits Per Sec' AS UCPS, 'User Transaction Per Sec' AS UTPS, 'Executions Per Sec' AS EPS, 'Database Time Per Sec' AS DTPS, 'DB Block Gets Per Sec' AS DBGPS, 'Physical Read Bytes Per Sec' AS PRBPS, 'Temp Space Used' AS TSU, 'Logical Reads Per Sec' AS LRPS, 'Physical Write Bytes Per Sec' AS PWBPS)
          )
ORDER BY  snap_id;
