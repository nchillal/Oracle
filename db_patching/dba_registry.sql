SET lines 230 pages 30
COLUMN comp_name for a80
SELECT    comp_id, 
          comp_name, 
          version, 
          status 
FROM      dba_registry
/
