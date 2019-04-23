SET linesize 230 pagesize 30
COLUMN comp_name FORMAT a80
SELECT  comp_id,
        comp_name,
        version,
        status
FROM    dba_registry
/

COLUMN description FORMAT a55
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
