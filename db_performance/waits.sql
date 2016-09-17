set linesize 150
set feedback on
set pagesize 1000
column    sid format 99999
column    event format a30
column    module format a35
column    username format a12
column    seconds_in_wait format 999999
column    p1 format 999999999999

select    b.inst_id,
          b.sid,
          b.event,
          SUBSTR(a.action,1,1)||'-'||a.module module ,
          a.username ,
          b.p1,
          b.p2,
          b.p3,
          b.seconds_in_wait
from      gv$session_wait b, gv$session a
where     b.event not in  (
                          'slave wait',
                          'SQL*Net message from client',
                          'rdbms ipc message',
                          'pmon timer',
                          'smon timer',
                          'pipe get',
                          'queue messages',
                          'wakeup time manager',
                          'jobq slave wait',
                          'gcs remote message',
                          'DIAG idle wait',
                          'Streams AQ: waiting for time management or cleanup tasks',
                          'Streams AQ: waiting for messages in the queue',
                          'ges remote message',
                          'Streams AQ: qmn slave idle wait',
                          'Streams AQ: qmn coordinator idle wait'
                          )
and       a.sid  = b.sid
and       a.inst_id = b.inst_id
order by  1, Last_call_ET;
