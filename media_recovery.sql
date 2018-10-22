SET LINESIZE 160 PAGESIZE 200
COLUMN name FORMAT a60
COLUMN status FORMAT A10
COLUMN file# FORMAT 999999
COLUMN control_file_scn FORMAT 999999999999999999
COLUMN datafile_scn FORMAT 999999999999999999

SELECT    a.name,
          a.status,
          a.file#,
          a.checkpoint_change# control_file_SCN,
          b.checkpoint_change# datafile_SCN,
          CASE
            WHEN ((a.checkpoint_change# - b.checkpoint_change#) = 0) THEN 'Startup Normal'
            WHEN ((b.checkpoint_change#) = 0) THEN 'File Missing?'
            WHEN ((a.checkpoint_change# - b.checkpoint_change#) > 0) THEN 'Media Rec Req'
            WHEN ((a.checkpoint_change# - b.checkpoint_change#) < 0) THEN 'Old Control File'
          ELSE 'what the ?'
          END datafile_status
FROM      v$datafile a,
          v$datafile_header b
WHERE     a.file# = b.file#
ORDER BY  a.file#;
