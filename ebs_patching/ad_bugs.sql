SET LINESIZE 230
COLUMN application_short_name FORMAT a6 HEADING ASN
SELECT  *
FROM    apps.ad_bugs
WHERE   bug_number='&bug_number';
