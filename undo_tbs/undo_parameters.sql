COLUMN Parameter FORMAT a40
COLUMN "Session Value" FORMAT a30 
COLUMN "Instance Value" FORMAT a30 

SELECT    a.ksppinm "Parameter",
          b.ksppstvl "Session Value",
          c.ksppstvl "Instance Value"
FROM      sys.x$ksppi a, sys.x$ksppcv b, sys.x$ksppsv c
WHERE     a.indx = b.indx
AND       a.indx = c.indx
AND       a.ksppinm in ( '_undo_autotune', '_smu_debug_mode', '_highthreshold_undoretention', 'undo_tablespace', 'undo_retention', 'undo_management')
ORDER BY  2
/
