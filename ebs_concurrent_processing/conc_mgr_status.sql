set linesize 280 pagesize 200
COLUMN user_concurrent_queue_name FORMAT a60
SELECT    USER_CONCURRENT_QUEUE_NAME,
          TARGET_PROCESSES,
          RUNNING_PROCESSES,
          MAX_PROCESSES
FROM      apps.fnd_concurrent_queues_vl
ORDER BY  2, 1 DESC;
