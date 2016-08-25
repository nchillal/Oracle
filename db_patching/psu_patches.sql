set lines 230 pages 50

col action_time for a30 
col comments for a50
col bundle for a6

select  SUBSTR(action_time,1,30) 
        action_time,
        SUBSTR(id,1,10) id,
        SUBSTR(action,1,10) action,
        SUBSTR(version,1,8) version,
        SUBSTR(BUNDLE_SERIES,1,6) bundle,
        SUBSTR(comments,1,20) comments
from    registry$history; 
