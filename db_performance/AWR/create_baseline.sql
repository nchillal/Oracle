-- Purpose: Create baseline based on start & end snapshot id.
BEGIN
  DBMS_WORKLOAD_REPOSITORY.CREATE_BASELINE (
    start_snap_id => &start_snapid,
    end_snap_id   => &end_snapid,
    baseline_name => '&baseline_name');
END;
/
