SELECT  TO_CHAR(begin_interval_time, 'YYYY-MM-DD HH24:MI:SS') begin_interval_time,
        instance_number,
        total_waits,
        CASE WHEN total_waits=0 THEN 0 ELSE TRUNC(TIME_WAITED_milli/total_waits, 2) END avg_wait,
        time_waited_milli
FROM    (
        SELECT  begin_interval_time,
                instance_number,
                event_name,
                CASE WHEN time_waited_micro=0 THEN 0 ELSE time_waited_micro/1000 END time_waited_milli, total_waits
        FROM    (
                    SELECT  begin_interval_time,
                            instance_number,
                            event_name,
                            time_waited_micro - LAG(time_waited_micro) OVER(PARTITION BY instance_number, startup_time  ORDER BY begin_interval_time ASC) time_waited_micro,
                            total_waits - LAG(total_waits) OVER(PARTITION BY instance_number, startup_time ORDER BY begin_interval_time ASC) total_waits
                    FROM    (
                                SELECT  /*+ leading (en, sn, e) use_hash (en, sn) */ sn.begin_interval_time,
                                        sn.startup_time,
                                        e.snap_id,
                                        e.dbid,
                                        e.instance_number,
                                        e.event_id,
                                        en.event_name,
                                        en.wait_class_id,
                                        en.wait_class,
                                        total_waits,
                                        total_timeouts,
                                        time_waited_micro
                                FROM    dba_hist_snapshot sn, dba_hist_system_event e,
                                        dba_hist_event_name en
                                WHERE   e.event_id         = en.event_id
                                AND     e.dbid             = en.dbid
                                AND     e.snap_id          = sn.snap_id
                                AND     e.dbid             = sn.dbid
                                AND     e.instance_number  = sn.instance_number
                            )
                    WHERE event_name='&event_name'
                    AND   begin_interval_time > SYSDATE - INTERVAL '&minutes' MINUTE
                )
        )
ORDER BY instance_number, begin_interval_time;
