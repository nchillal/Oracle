SELECT  *
FROM    table(DBMS_XPLAN.display_awr('&sql_id'));
