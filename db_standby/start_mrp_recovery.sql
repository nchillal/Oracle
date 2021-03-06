-- Start standby managed recovery
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DELAY 360 DISCONNECT FROM SESSION;

-- Start standby managed recovery Real-Time Apply (Physical Standby)
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
