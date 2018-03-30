-- User commits per second from AWR.
BREAK ON snap_id SKIP 1
SELECT    *
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
          FOR metric_name IN ('User Commits Per Sec' AS USER_COMMITS_PER_SEC)
          )
ORDER BY  snap_id;

-- User transaction per second from AWR.
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

-- Executions per second from AWR.
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(EXEC_PER_SEC, 2) "EXEC_PER_SEC"
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
          FOR metric_name IN ('Executions Per Sec' AS EXEC_PER_SEC)
          )
ORDER BY  snap_id;

-- DB Time per second from AWR.
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(DB_TIME_PER_SEC, 2) "DB_TIME_PER_SEC"
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
          FOR metric_name IN ('Database Time Per Sec' AS DB_TIME_PER_SEC)
          )
ORDER BY  snap_id;

-- Block Gets per second from AWR.
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(DB_BLOCK_GETS_PER_SEC, 2) "DB_BLOCK_GETS_PER_SEC"
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
          FOR metric_name IN ('DB Block Gets Per Sec' AS DB_BLOCK_GETS_PER_SEC)
          )
ORDER BY  snap_id;

-- Physical Reads per second from AWR.
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(PHY_READ_BYTES_PER_SEC, 2) "PHY_READ_BYTES_PER_SEC"
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
          FOR metric_name IN ('Physical Read Bytes Per Sec' AS PHY_READ_BYTES_PER_SEC)
          )
ORDER BY  snap_id;
