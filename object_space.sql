SET SERVEROUTPUT ON
DECLARE
  total_blocks              NUMBER;
  total_bytes               NUMBER;
  unused_blocks             NUMBER;
  unused_bytes              NUMBER;
  last_used_extent_file_id  NUMBER;
  last_used_extent_block_id NUMBER;
  last_used_block           NUMBER;
BEGIN
  DBMS_SPACE.UNUSED_SPACE('&segment_owner','&segment_name','&segment_type', total_blocks, total_bytes, unused_blocks, unused_bytes, last_used_extent_file_id, last_used_extent_block_id, last_used_block);
  DBMS_OUTPUT.PUT_LINE('TOTAL_BLOCKS              = '||total_blocks);
  DBMS_OUTPUT.PUT_LINE('TOTAL_BYTES               = '||total_bytes);
  DBMS_OUTPUT.PUT_LINE('UNUSED_BLOCKS             = '||unused_blocks);
  DBMS_OUTPUT.PUT_LINE('UNUSED BYTES              = '||unused_bytes);
  DBMS_OUTPUT.PUT_LINE('LAST_USED_EXTENT_FILE_ID  = '||last_used_extent_file_id);
  DBMS_OUTPUT.PUT_LINE('LAST_USED_EXTENT_BLOCK_ID = '||last_used_extent_block_id);
  DBMS_OUTPUT.PUT_LINE('LAST_USED_BLOCK           = '||last_used_block);
END;
/

SET SERVEROUTPUT ON
DECLARE
  su NUMBER;
  sa NUMBER;
  cp NUMBER;
BEGIN
  DBMS_SPACE.OBJECT_SPACE_USAGE('&segment_owner', '&segment_name', '&segment_type', NULL, su, sa, cp);
  DBMS_OUTPUT.PUT_LINE('Space Used: '||ROUND(TO_CHAR(su)/1024, 2)||' K');
  DBMS_OUTPUT.PUT_LINE('Space Allocated: '||ROUND(TO_CHAR(sa)/1024, 2)||' K');
END;
/
