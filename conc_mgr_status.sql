set lines 280 pages 200 
col USER_CONCURRENT_QUEUE_NAME for a60
select USER_CONCURRENT_QUEUE_NAME, TARGET_PROCESSES, RUNNING_PROCESSES, MAX_PROCESSES from apps.fnd_concurrent_queues_vl order by 2, 1 desc; 
