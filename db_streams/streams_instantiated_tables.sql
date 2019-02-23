BREAK ON source_object_owner SKIP 1
SELECT      source_object_owner, source_object_name, instantiation_scn, ignore_scn
FROM        dba_apply_instantiated_objects
ORDER BY    source_object_owner;