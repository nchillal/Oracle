-- Purpose: Modify AWR Snapshot Settings.
EXEC DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings (retention => &retention_mins, interval => &interval_mins);
