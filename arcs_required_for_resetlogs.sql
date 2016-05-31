set numwidth 30 lines 230
select thread#, sequence#, first_change#, next_change# from v$archived_log where &change between first_change# and next_change#;
