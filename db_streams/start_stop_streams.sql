-- Stop Apply/Capture/Propagation
EXEC DBMS_CAPTURE_ADM.STOP_CAPTURE(capture_name => '&capture_name');
EXEC DBMS_PROPAGATION_ADM.STOP_PROPAGATION(propagation_name => '&propagation_name');
EXEC DBMS_APPLY_ADM.STOP_APPLY(apply_name => '&apply_name');

-- Start Apply/Capture/Propagation
EXEC DBMS_CAPTURE_ADM.START_CAPTURE(capture_name => '&capture_name');
EXEC DBMS_PROPAGATION_ADM.START_PROPAGATION(propagation_name => '&propagation_name');
EXEC DBMS_APPLY_ADM.START_APPLY(apply_name => '&appl_name');