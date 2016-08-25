select    thread#, 
          MAX(sequence#) 
from      v$log_history 
group by  thread#;
