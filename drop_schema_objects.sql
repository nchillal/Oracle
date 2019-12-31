SELECT 	'DROP '||UPPER(object_type)||' '||owner||'.'||object_name||';'
FROM    dba_objects
WHERE 	owner='&schema_name';
