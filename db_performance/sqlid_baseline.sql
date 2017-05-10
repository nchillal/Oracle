BREAK ON sql_id SKIP 1

SELECT  sql_id, child_number, sql_handle, plan_name, a.parsing_schema_name
FROM    dba_sql_plan_baselines a, v$sql b
WHERE   a.signature = b.EXACT_MATCHING_SIGNATURE
AND     a.signature = b.FORCE_MATCHING_SIGNATURE;
