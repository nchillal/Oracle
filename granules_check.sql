SELECT    inst_id, 'Granules_Count='||(current_size - user_specified_size)/granule_size granules_avail
FROM      gv$sga_dynamic_components
WHERE     component LIKE 'DEFAULT buffer cache'
ORDER BY  inst_id;
