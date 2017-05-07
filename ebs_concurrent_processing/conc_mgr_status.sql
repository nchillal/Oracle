SET LINESIZE 280 PAGESIZE 200
COLUMN user_concurrent_queue_name FORMAT a60
SELECT    user_concurrent_queue_name,
          target_processes,
          running_processes,
          max_processes
FROM      apps.fnd_concurrent_queues_vl
ORDER BY  2, 1 DESC;
