set lines 280 pages 200
col USER_CONCURRENT_QUEUE_NAME for a60
SELECT    USER_CONCURRENT_QUEUE_NAME,
          TARGET_PROCESSES,
          RUNNING_PROCESSES,
          MAX_PROCESSES
FROM      apps.fnd_concurrent_queues_vl
ORDER BY  2, 1 DESC;
