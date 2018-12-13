-- Drop AWR snapshot in the range.
EXEC DBMS_WORKLOAD_REPOSITORY.drop_snapshot_range(low_snap_id=>40, high_snap_id=>80);
