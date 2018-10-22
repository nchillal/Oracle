SET LINESIZE 230;
SET PAGESIZE 1000;
SET FEEDBACK OFF;
SET COLSEP '|';
WHENEVER SQLERROR EXIT SQL.SQLCODE;

COLUMN "Host Name" FORMAT A40;
COLUMN "Option/Management Pack" FORMAT A60;
COLUMN "Used" FORMAT A5;
WITH features AS(
SELECT a OPTIONS, b NAME
FROM (
      SELECT 'Active Data Guard' a,  'Active Data Guard - Real-Time Query on Physical Standby' b FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'HeapCompression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Backup BZIP2 Compression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Backup DEFAULT Compression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Backup HIGH Compression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Backup LOW Compression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Backup MEDIUM Compression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Backup ZLIB, Compression' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'SecureFile Compression (user)' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'SecureFile Deduplication (user)' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Data Guard' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Oracle Utility Datapump (Export)' FROM dual
      UNION ALL
      SELECT 'Advanced Compression', 'Oracle Utility Datapump (Import)' FROM dual
      UNION ALL
      SELECT 'Advanced Security',	'ASO native encryption and checksumming' FROM dual
      UNION ALL
      SELECT 'Advanced Security', 'Transparent Data Encryption' FROM dual
      UNION ALL
      SELECT 'Advanced Security', 'Encrypted Tablespaces' FROM dual
      UNION ALL
      SELECT 'Advanced Security', 'Backup Encryption' FROM dual
      UNION ALL
      SELECT 'Advanced Security', 'SecureFile Encryption (user)' FROM dual
      UNION ALL
      SELECT 'Change Management Pack',	'Change Management Pack (GC)' FROM dual
      UNION ALL
      SELECT 'Data Masking Pack',	'Data Masking Pack (GC)' FROM dual
      UNION ALL
      SELECT 'Data Mining',	'Data Mining' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'Diagnostic Pack' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'ADDM' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'AWR Baseline' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'AWR Baseline Template' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'AWR Report' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'Baseline Adaptive Thresholds' FROM dual
      UNION ALL
      SELECT 'Diagnostic Pack', 'Baseline Static Computations' FROM dual
      UNION ALL
      SELECT 'Tuning  Pack', 'Tuning Pack' FROM dual
      UNION ALL
      SELECT 'Tuning  Pack', 'Real-Time SQL Monitoring' FROM dual
      UNION ALL
      SELECT 'Tuning  Pack', 'SQL Tuning Advisor' FROM dual
      UNION ALL
      SELECT 'Tuning  Pack', 'SQL Access Advisor' FROM dual
      UNION ALL
      SELECT 'Tuning  Pack', 'SQL Profile' FROM dual
      UNION ALL
      SELECT 'Tuning  Pack', 'Automatic SQL Tuning Advisor' FROM dual
      UNION ALL
      SELECT 'Database Vault', 'Oracle Database Vault' FROM dual
      UNION ALL
      SELECT 'WebLogic Server Management Pack Enterprise Edition', 'EM AS Provisioning and Patch Automation (GC)' FROM dual
      UNION ALL
      SELECT 'Configuration Management Pack for Oracle Database', 'EM Config Management Pack (GC)' FROM dual
      UNION ALL
      SELECT 'Provisioning and Patch Automation Pack for Database', 'EM Database Provisioning and Patch Automation (GC)' FROM dual
      UNION ALL
      SELECT 'Provisioning and Patch Automation Pack', 'EM Standalone Provisioning and Patch Automation Pack (GC)' FROM dual
      UNION ALL
      SELECT 'Exadata', 'Exadata' FROM dual
      UNION ALL
      SELECT 'Label Security', 'Label Security' FROM dual
      UNION ALL
      SELECT 'OLAP', 'OLAP - Analytic Workspaces' FROM dual
      UNION ALL
      SELECT 'Partitioning', 'Partitioning (user)' FROM dual
      UNION ALL
      SELECT 'Real Application Clusters', 'Real Application Clusters (RAC)' FROM dual
      UNION ALL
      SELECT 'Real Application Testing', 'Database Replay: Workload Capture' FROM dual
      UNION ALL
      SELECT 'Real Application Testing', 'Database Replay: Workload Replay' FROM dual
      UNION ALL
      SELECT 'Real Application Testing', 'SQL Performance Analyzer' FROM dual
      UNION ALL
      SELECT 'Spatial' ,'Spatial (Not used because this does not differential usage of spatial over locator, which is free)' FROM dual
      UNION ALL
      SELECT 'Total Recall', 'Flashback Data Archive' FROM dual
    )
)
SELECT t.o "Option/Management Pack",
       t.u "Used",
       d.DBID "DBID",
       d.name "DB Name",
       i.version "DB Version",
       i.host_name "Host Name",
       to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') "ReportGen Time"
FROM
(
SELECT OPTIONS o, DECODE(sum(num),0,'NO','YES') u
FROM
(
SELECT  f.OPTIONS OPTIONS,
        case
        when f_stat.name is null then 0
        when  (
                (
                  f_stat.currently_used = 'TRUE' and f_stat.detected_usages > 0 and (sysdate - f_stat.last_usage_date) < 366 and f_stat.total_samples > 0
                )
                or
                (
                  f_stat.detected_usages > 0 and (sysdate - f_stat.last_usage_date) < 366 and f_stat.total_samples > 0
                )
              )
              and
              (
              f_stat.name not in('Data Guard', 'Oracle Utility Datapump (Export)', 'Oracle Utility Datapump (Import)')
              or
                (
                  f_stat.name in('Data Guard', 'Oracle Utility Datapump (Export)', 'Oracle Utility Datapump (Import)')
                  and f_stat.feature_info is not null
                  and TRIM(substr(to_char(feature_info), instr(to_char(feature_info), 'compression used: ',1,1) + 18, 2)) != '0'
                )
              ) then 1
        else 0
        end num
FROM    features f,
        sys.dba_feature_usage_statistics f_stat
WHERE   f.name = f_stat.name(+)
)
GROUP BY options
) t,
v$instance i,
v$database d
ORDER BY 2 DESC, 1
;

exit;
