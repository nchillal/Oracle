# Purpose: Drop AWR baseline.

BEGIN
  DBMS_WORKLOAD_REPOSITORY.drop_baseline(baseline_name => '&baseline_name');
END;
/
