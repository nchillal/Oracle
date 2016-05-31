# Purpose: Drop AWR snapshot in the range. 

BEGIN
  DBMS_WORKLOAD_REPOSITORY.drop_snapshot_range(low_snap_id=>40,High_snap_id=>80);
END;
/
