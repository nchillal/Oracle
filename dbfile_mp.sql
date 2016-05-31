SELECT SUBSTR(name, 1, (INSTR(name, '/', -1)-1)) FROM v$datafile
UNION
SELECT SUBSTR(member, 1, (INSTR(member, '/', -1)-1)) FROM v$logfile
UNION
SELECT SUBSTR(name, 1, (INSTR(name, '/', -1)-1)) FROM v$controlfile
UNION
SELECT SUBSTR(name, 1, (INSTR(name, '/', -1)-1)) FROM v$tempfile;
