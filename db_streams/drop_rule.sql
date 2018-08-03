SELECT    'EXEC DBMS_'||streams_type||'_ADM.ALTER_'||streams_type||'('||DECODE(streams_type, 'APPLY', 'apply_name', 'PROPAGATION', 'propagation_name')||' => '||''''||streams_name||''''||', remove_rule_set => true);' "DDL Remove Rule"
FROM      dba_streams_rules
WHERE     rule_name IN (SELECT RULE_NAME FROM dba_streams_table_rules WHERE TABLE_OWNER = '&table_owner')
AND       streams_type = '&streams_type';
