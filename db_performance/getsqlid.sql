SELECT  sql_id,
        sql_child_number
FROM    v$session
WHERE   sid=&sid;
