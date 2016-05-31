select thread#, max(sequence#) from v$log_history group by thread#;
