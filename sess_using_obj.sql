set linesize 230
COLUMN object FORMAT a30
SELECT  *
FROM    gv$access
WHERE   object='&obj_name';
