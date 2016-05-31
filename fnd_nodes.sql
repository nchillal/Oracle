SELECT node_name,
            node_mode,
            status,
            support_cp "Concurrent Node",
            support_db "Database Node",
            support_admin "Admin Node",
            support_forms "Forms Node",
            support_web "Web Node",
            platform_code plat
FROM   apps.fnd_nodes;
