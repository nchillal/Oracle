SELECT  EXTRACT(day FROM snap_interval) *24*60 + EXTRACT(hour FROM snap_interval) *60 + EXTRACT(minute FROM snap_interval) "Snapshot Interval",
        EXTRACT(day FROM retention) *24*60 + EXTRACT(hour FROM retention) *60 + EXTRACT(minute FROM retention) "Retention Interval"
FROM    dba_hist_wr_control;
