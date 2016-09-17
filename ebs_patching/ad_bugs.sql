set linesize 230
COLUMN APPLICATION_SHORT_NAME FORMAT a6 HEADING ASN
SELECT  *
FROM    apps.ad_bugs
WHERE   bug_number='&bug_number';
