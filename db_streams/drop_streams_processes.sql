BEGIN
  DBMS_APPLY_ADM.DROP_APPLY
  (
    apply_name => '&apply_name'
  );
END;
/

BEGIN
  DBMS_PROPAGATION_ADM.DROP_PROPAGATION
  (
    propagation_name => '&propagation_name'
  );
END;
/

BEGIN
  DBMS_CAPTURE_ADM.DROP_CAPTURE
  (
    capture_name => '&capture_name'
  );
END;
/

BEGIN
  DBMS_STREAMS_ADM.REMOVE_QUEUE
  (
    queue_name              => '&queue_name',
    cascade                 => FALSE,
    drop_unused_queue_table => TRUE
  );
END;
/
