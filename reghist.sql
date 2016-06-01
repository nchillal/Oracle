set lines 230 

col ACTION_TIME for a40
col id for a10
col comments for a30 

select  SUBSTR(action_time,1,30) action_time, 
        SUBSTR(id,1,10) id, 
        SUBSTR(action,1,10) action, 
        SUBSTR(version,1,8) version, 
        SUBSTR(BUNDLE_SERIES,1,6) bundle, 
        SUBSTR(comments,1,20) comments 
from    registry$history;
