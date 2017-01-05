SELECT    object_name, object_type, session_id, type, lmode, request, block, ctime
FROM      v$locked_object, all_objects, v$lock
where     v$locked_object.object_id = all_objects.object_id
AND       v$lock.id1 = all_objects.object_id
AND       v$lock.sid = v$locked_object.session_id
ORDER BY  session_id, ctime DESC, object_name
/
