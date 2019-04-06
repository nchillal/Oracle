-- Drop AWR snapshot in the range.
EXEC DBMS_WORKLOAD_REPOSITORY.DROP_SNAPSHOT_RANGE(low_snap_id => &begin_snap, high_snap_id=> &end_snap);
