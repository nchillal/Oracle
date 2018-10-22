# Purpose: Drop AWR baseline.

BEGIN
  DBMS_WORKLOAD_REPOSITORY.DROP_BASELINE(baseline_name => '&baseline_name');
END;
/
