SET LINESIZE 230 PAGESIZE 200

COLUMN description FORMAT a100
COLUMN property_name FORMAT a50
COLUMN property_value FORMAT a80

SELECT  *
FROM    database_properties;
