-- Purpose: To create AWR snapshot manually.
BEGIN
  DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT();
END;
/
