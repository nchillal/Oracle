# Purpose: Modify AWR Snapshot Settings. 

BEGIN
  DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings(
    retention => &retention_mins,  
    interval  => &interval_mins); 
END;
/
