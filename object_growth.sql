break on begin_time on end_time SKIP 1
SELECT    TRUNC(begin_interval_time) begin_time,
          TRUNC(begin_interval_time + 1) end_time,
          c.tablespace_name,
          ROUND(SUM(space_used_delta/1024/1024/1024), 2) "Growth MB"
FROM      dba_hist_snapshot sn,
          dba_hist_seg_stat a,
          dba_objects b,
          dba_segments c
WHERE     begin_interval_time >= TRUNC(SYSDATE) - &&days
AND       sn.snap_id = a.snap_id
AND       b.object_id = a.obj#
AND       b.owner = c.owner
AND       b.object_name = c.segment_name
GROUP BY  TRUNC(begin_interval_time), TRUNC(begin_interval_time + 1), tablespace_name
ORDER BY  1, 2, 3;


BREAK ON begin_time ON end_time ON tablespace_name SKIP 1
SELECT    *
FROM      (
SELECT    TRUNC(begin_time) begin_time, TRUNC(end_time) end_time, tablespace_name, segment_name, object_type, ROUND(SUM(space_used_delta) / 1024 / 1024, 2) "Growth MB"
FROM      (
          SELECT    begin_interval_time begin_time, (begin_interval_time + 1) end_time, tablespace_name, segment_name, object_type, space_used_delta
          FROM      (
                      SELECT    begin_interval_time,
                                c.tablespace_name,
                                c.segment_name,
                                b.object_type,
                                space_used_delta
                      FROM      dba_hist_snapshot sn,
                                dba_hist_seg_stat a,
                                dba_objects b,
                                dba_segments c
                      WHERE     begin_interval_time >= TRUNC(SYSDATE) - &&days
                      AND       sn.snap_id = a.snap_id
                      AND       b.object_id = a.obj#
                      AND       b.owner = c.owner
                      AND       c.tablespace_name = 'DATA_NEW_TS'
                      AND       b.object_name = c.segment_name
                    )
)
GROUP BY  TRUNC(begin_time), TRUNC(end_time), tablespace_name, segment_name, object_type
ORDER BY  6 DESC
)
WHERE rownum <= 100
ORDER BY 1, 2, 6;


BREAK ON begin_time ON end_time SKIP 1
SELECT    *
FROM      (
            SELECT    SYSDATE - INTERVAL '&&hours' HOUR begin_time,
                      SYSDATE - INTERVAL '&&hours' HOUR + 1/24 end_time,
                      c.tablespace_name,
                      c.segment_name "Object Name",
                      b.object_type,
                      ROUND(SUM(space_used_delta) / 1024 / 1024, 2) "Growth (MB)"
            FROM      dba_hist_snapshot sn,
                      dba_hist_seg_stat a,
                      dba_objects b,
                      dba_segments c
            WHERE     begin_interval_time > SYSDATE - INTERVAL '&&hours' HOUR
            AND       begin_interval_time < SYSDATE - INTERVAL '&&hours' HOUR + 1/24
            AND       sn.snap_id = a.snap_id
            AND       b.object_id = a.obj#
            AND       b.owner = c.owner
            AND       c.tablespace_name = 'DATA_NEW_TS'
            AND       b.object_name = c.segment_name
            GROUP BY  c.tablespace_name, c.segment_name, b.object_type
            ORDER BY  6 DESC
          )
WHERE rownum <= 10;
