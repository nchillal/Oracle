set lines 230 
col ACTION_TIME for a40
col id for a10
col comments for a30 
select substr(action_time,1,30) action_time, 
substr(id,1,10) id, 
substr(action,1,10) action, 
substr(version,1,8) version, 
substr(BUNDLE_SERIES,1,6) bundle, 
substr(comments,1,20) comments 
from registry$history;
