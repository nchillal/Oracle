COLUMN client_info FORMAT a30
COLUMN client_identifier FORMAT a30
COLUMN module FORMAT a40
COLUMN action FORMAT a40
SELECT client_info, client_identifier, module, action FROM v$session WHERE sid = (SELECT sid FROM v$mystat WHERE rownum = 1);
EXEC DBMS_APPLICATION_INFO.SET_CLIENT_INFO('&client_info_name');
EXEC DBMS_SESSION.SET_IDENTIFIER('&client_identifier');
EXEC DBMS_APPLICATION_INFO.SET_MODULE('&module_name', '&action_name');
