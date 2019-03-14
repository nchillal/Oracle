-- Drop streams capture process.
EXEC DBMS_CAPTURE_ADM.DROP_CAPTURE ( capture_name => '&capture_name', drop_unused_rule_sets => true);
-- Drop streams propagation process.
EXEC DBMS_PROPAGATION_ADM.DROP_PROPAGATION(propagation_name => '&propagation_name', drop_unused_rule_sets => true);
-- Drop streams apply process.
EXEC DBMS_APPLY_ADM.DROP_APPLY(apply_name => '&apply_name', drop_unused_rule_sets => true);
-- Drop streams queue
EXEC DBMS_STREAMS_ADM.REMOVE_QUEUE ( queue_name => '&queue_name', cascade => FALSE, drop_unused_queue_table => TRUE );