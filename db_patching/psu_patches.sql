SET LINESIZE 230 PAGESIZE 50

COLUMN action_time FORMAT a30
COLUMN comments FORMAT a50
COLUMN bundle FORMAT a6
COLUMN id FORMAT a10

SELECT  SUBSTR(action_time,1,30)
        action_time,
        SUBSTR(id,1,10) id,
        SUBSTR(action,1,10) action,
        SUBSTR(version,1,8) version,
        SUBSTR(BUNDLE_SERIES,1,6) bundle,
        SUBSTR(comments,1,20) comments
FROM    registry$history;

SET LINESIZE 200 PAGESIZE 100
COLUMN description FORMAT a80
COLUMN action_time FORMAT a30
COLUMN status FORMAT a10
COLUMN action FORMAT a10
 
SELECT  patch_id,
        patch_type,
        action,
        status,
        action_time,
        description,
        source_version,
        target_version
FROM    sys.dba_registry_sqlpatch;