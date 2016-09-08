SELECT    thread#,
          MAX(sequence#)
FROM      v$log_history
GROUP BY  thread#;
