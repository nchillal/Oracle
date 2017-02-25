SET LINESIZE 200
COLUMN originating_timestamp FORMAT a40
COLUMN message_text FORMAT a160

SELECT    originating_timestamp,
          message_text
FROM      x$dbgalertext
WHERE     originating_timestamp > SYSDATE-1
ORDER BY  1;
