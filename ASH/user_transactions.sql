BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(user_transaction_per_sec, 2)
FROM      (
          SELECT  snap_id,
                  instance_number,
                  end_time,
                  metric_name,
                  maxval
          FROM    dba_hist_sysmetric_summary
          WHERE   end_time >= SYSDATE - INTERVAL '&days' day
          AND     REGEXP_LIKE(instance_number, '&instance_number')
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('User Transaction Per Sec' AS USER_TRANSACTION_PER_SEC)
          )
ORDER BY  snap_id;
