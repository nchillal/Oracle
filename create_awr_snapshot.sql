# Purpose: To create AWR snapshot manually.
BEGIN
  DBMS_WORKLOAD_REPOSITORY.create_snapshot();
END;
/
