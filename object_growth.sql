SELECT  *
FROM    TABLE(
              DBMS_SPACE.OBJECT_GROWTH_TREND (
                  object_owner => UPPER('&&schema_name'),
                  object_name => UPPER('&&object_name'),
                  object_type => UPPER('&&object_type'),
                  partition_name => '&partition_name',
                  start_time => SYSDATE - 30,
                  end_time => SYSDATE + 30,
                  interval => to_dsinterval('1 00:00:00')
              )
);
