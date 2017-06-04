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
  dbms_space.unused_space('&schema','&object','&type', total_blocks, total_bytes, unused_blocks, unused_bytes, last_used_extent_file_id, last_used_extent_block_id, last_used_block);
  dbms_output.put_line('-----------------------------------');
  dbms_output.put_line('           UNUSED SPACE            ');
  dbms_output.put_line('-----------------------------------');
  dbms_output.put_line('TOTAL_BLOCKS              = '||total_blocks);
  dbms_output.put_line('TOTAL_BYTES               = '||total_bytes);
  dbms_output.put_line('UNUSED_BLOCKS             = '||unused_blocks);
  dbms_output.put_line('UNUSED BYTES              = '||unused_bytes);
  dbms_output.put_line('LAST_USED_EXTENT_FILE_ID  = '||last_used_extent_file_id);
  dbms_output.put_line('LAST_USED_EXTENT_BLOCK_ID = '||last_used_extent_block_id);
  dbms_output.put_line('LAST_USED_BLOCK           = '||last_used_block);
END;
/

SET SERVEROUTPUT ON
DECLARE
  su NUMBER;
  sa NUMBER;
  cp NUMBER;
BEGIN
  dbms_space.object_space_usage('&segment_owner', '&segment_name', '&segment_type', NULL, su, sa, cp);
  dbms_output.put_line('Space Used: '||ROUND(TO_CHAR(su)/1024, 2)||' K');
  dbms_output.put_line('Space Allocated: '||ROUND(TO_CHAR(sa)/1024, 2)||' K');
END;
/
