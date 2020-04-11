SELECT DBMS_STATS.get_prefs('&pname', '&schema', '&table') FROM dual;

EXEC DBMS_STATS.set_table_prefs('&schema', '&table', '&pname', '&value');

EXEC DBMS_STATS.gather_table_stats('&owner', '&table', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO');
