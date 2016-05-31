define v_dbid=NULL;
select &v_dbid from dual;
col f_dbid new_value v_dbid
select &database_id f_dbid from dual;
select &v_dbid from dual;
select nvl(&v_dbid,dbid) f_dbid from v$database;
select &v_dbid from dual;

col mx for 999999
col mn for 999999
col av for 999999.9
 
select
       sql_id,
       count(*),
       max(tm) mx,
       avg(tm) av,
       min(tm) min
from (
   select
        sql_id,
        sql_exec_id,
        max(tm) tm
   from ( select
              sql_id,
              sql_exec_id,
              ((cast(sample_time  as date)) -
              (cast(sql_exec_start as date))) * (3600*24) tm
           from
              dba_hist_active_sess_history
           where sql_exec_id is not null
             and dbid=&v_dbid
    )
   group by sql_id,sql_exec_id
   )
group by sql_id
having count(*) > 10
order by mx,av
/
