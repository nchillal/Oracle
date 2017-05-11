BREAK ON sql_id SKIP 1

SELECT  sql_id, child_number, sql_handle, plan_name, a.parsing_schema_name
FROM    dba_sql_plan_baselines a, v$sql b
WHERE   a.signature = b.exact_matching_signature
AND     a.signature = b.force_matching_signature;
