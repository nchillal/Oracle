#!/usr/bin/env ksh
sql_id=${1}

if [[ -z ${sql_id} ]]; then 
    echo -e "\nUsage: ${0} <SQL_ID>\n"
    exit 1
fi

sqlplus -s / as sysdba <<!
SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
SET PAGESIZE 0
SET TRIM ON
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF
SPOOL /tmp/report_${sql_id}.html
SELECT DBMS_SQLTUNE.REPORT_SQL_DETAIL('${sql_id}', report_level => 'ALL') FROM dual;
SPOOL OFF
!
