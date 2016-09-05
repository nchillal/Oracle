select    to_char(FIRST_TIME, 'DD-MON-YYYY'), count(*)
from      v$log_history
where     to_char(FIRST_TIME, 'DD-MON-YYYY') >= to_char(SYSDATE - &num_days, 'DD-MON-YYYY')
group by  to_char(FIRST_TIME, 'DD-MON-YYYY')
order by  1
/

select    to_char(FIRST_TIME, 'HH24'), count(*)
from      v$log_history
where     to_char(FIRST_TIME, 'DD-MON-YYYY') = to_char(SYSDATE - &num_days, 'DD-MON-YYYY')
group by  to_char(FIRST_TIME, 'HH24')
order by  1
/
