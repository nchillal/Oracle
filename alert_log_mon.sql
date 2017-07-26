SET LINESIZE 200
COLUMN originating_timestamp FORMAT a40
COLUMN message_text FORMAT a90

SELECT    TO_CHAR(originating_timestamp, 'DD-MON-YYYY HH24:MI:SS'),
          message_text
FROM      x$dbgalertext
WHERE     originating_timestamp > SYSDATE-1/24
ORDER BY  1;
