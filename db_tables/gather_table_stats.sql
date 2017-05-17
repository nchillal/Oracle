SELECT DBMS_STATS.GET_PREFS('&pname', '&schema', '&table') FROM dual;

EXEC DBMS_STATS.SET_TABLE_PREFS('&schema', '&table', '&pname', '&value');

EXEC DBMS_STATS.GATHER_TABLE_STATS('&owner', '&table', estimate_percent => &est_percent);
