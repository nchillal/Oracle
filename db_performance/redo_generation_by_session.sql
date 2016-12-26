COLUMN machine FORMAT a45
COLUMN username FORMAT a20
COLUMN redo_MB FORMAT 999G990 HEADING "Redo |Size MB"
COLUMN sid_serial FORMAT a13;

SELECT  b.inst_id,
        LPAD((b.sid || ',' || LPAD(b.serial#,5)),11) sid_serial,
        b.username,
        machine,
        b.osuser,
        b.status,
        a.redo_mb
FROM   (SELECT    n.inst_id, sid,
                  ROUND(value/1024/1024) redo_mb
        FROM      gv$statname n, gv$sesstat s
        WHERE     n.inst_id=s.inst_id
        AND       n.name = 'redo size'
        AND       s.statistic# = n.statistic#
        ORDER BY  value DESC
        )a, gv$session b
WHERE   b.inst_id = a.inst_id
AND     a.sid = b.sid
AND     rownum <= 30
;
