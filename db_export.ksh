#!/bin/ksh
# *****************************************************************************#
# Purpose: This script is to perform export of database.                       #
# Author: Nagendra Chillale                                                    #
# *****************************************************************************#
usage()
{
  echo -e "
  Usage: This script should be invoked as follows
  $0 -s <SID> -p <PARFILE> -d <DEBUG>

  Where:
    -s accepts argument as database SID name.
    -p accepts argument as export parameter file.
    -d is for debugging and only 'x' is accepted.

  For example, $0 -s irptp -p export_iseva_owner.par
  For example, $0 -s irptp -p export_iseva_owner.par -d x
  "
}

# ------ #
#  Main  #
# ------ #
# Define stdout message colors to inform Warning/Info (FGBROWN), Error (FGRED) and Success (FGBLUE) signal.
FGRED='\033[01;31m'
FGBLUE='\033[00;34m'
FGBROWN='\033[00;33m'
RESET='\033[00;00m'

# Timestamp when script runs.
TIMESTAMP=$(date +%c|sed 's/ /_/g')
MY_SCRIPT_FILE=$(basename $0)

# Start: Process arguments passed to script and assign it to variables
while getopts hs:p:d:: o; do
  case "${o}" in
    s)
      SID=${OPTARG}
      ;;
    p)
      PARFILE=${OPTARG}
      ;;
    d)
      DEBUG=${OPTARG}
      ;;
    h)
      usage
      exit;
      ;;
  esac
done
# End: Process arguments passed to script and assign it to variables

shift $((OPTIND-1))

# Start: Check if variables are passed correctly.
if [ -z "$SID" ] || [ -z "$PARFILE" ]
then
  usage;
  exit;
fi
# End: Check if variables are passed correctly.

# Start: For debugging of this script.
if [ ! -z $DEBUG ]
then
  set -$DEBUG
fi
# End: For debugging of this script.

# Start: Logic to check if script is already running. Exit if it is. Else run.
if [ "$(uname)" = "SunOS" ] && [ -f /usr/ucb/ps ]; then
      pscmd="/usr/ucb/ps -alxwww"
      PPID=$$
elif [ "$(uname)" = "Linux" ]; then
      pscmd="ps axjf"
      PPID=`$pscmd |grep $$ | awk -v pid=$$ '$2==pid { print $3  }'`
else
      pscmd="ps -ef"
      PPID=$$
fi

SCRIPT_RUNNING_COUNT=`$pscmd|grep $ORACLE_SID|grep $MY_SCRIPT_FILE|grep -v grep|grep -v "sh -c" |grep -v $PPID|wc -l`

if [ $SCRIPT_RUNNING_COUNT -gt 0 ]
then
  echo -e $FGBROWN "$MY_SCRIPT_FILE is already running..exiting!"
  exit
fi
# End: Logic to check if script is already running. Exit if it is. Else run.

DIR_NAME=$(cat $PARFILE |grep DIRECTORY|awk -F'=' '{print $2}')

if [ -z $DIR_NAME ]
then
  echo -e $FGRED "Check the directory name in parameter file its not set..exiting! [ NOT OK ]" $RESET
  exit
fi

echo -e $FGBROWN "Checking if the directory $DIR_NAME exists in the database." $RESET

DIR_CHECK=$(sqlplus -s "/as sysdba" << EOF
set head off
set pause off
set pages 0
set feedback off
set term off
set echo off
set verify off
SELECT  COUNT(*)
FROM    dba_directories
WHERE   directory_name = '${DIR_NAME}'
/
exit
EOF
)

DIR_PATH=$(sqlplus -s "/as sysdba" << EOF
set head off
set pause off
set pages 0
set feedback off
set term off
set echo off
set verify off
SELECT  directory_path
FROM    dba_directories
WHERE   directory_name = '${DIR_NAME}'
/
exit
EOF
)

# Start: Check if the directory exists in the database and on the filesystem.
if [ $DIR_CHECK -ne 1 ]
then
  echo -e $FGRED "There is no directory with $DIR_NAME in dba_directories. Please enter the correct directory name..exiting! [ NOT OK ]" $RESET
  exit
else
  if [ -d $DIR_PATH ]
  then
    echo -e $FGBLUE "--Directory '$DIR_NAME' found in dba_directories and its path is $DIR_PATH [ OK ]" $RESET
  fi
fi
# End: Check if the directory exists in the database and on the filesystem.

# Get list of schemas to be exported from the parameter file.
SCHEMA_NAMES=$(cat $PARFILE |grep SCHEMAS|awk -F'=' '{print $2}'|sed "s/^/'/g"|sed "s/$/'/g"|sed "s/,/','/g"|tr "[:lower:]" "[:upper:]")

# Start: Check if the schema is defined in the parameter file. Exit if not defined.
if [ -z $SCHEMA_NAMES ]
then
  echo -e $FGRED "Check if the schema name in parameter file is defined..exiting! [ NOT OK ]" $RESET
  exit
else
  echo -e $FGBROWN "Schemas requested to be exported: $(cat $PARFILE |grep SCHEMAS|awk -F'=' '{print $2}'|sed "s/,/ /g") "
fi
# End: Check if the schema is defined in the parameter file. Exit if not defined.

# Count the number of schemas to be exported as defined in the parameter file.
SCHEMA_COUNT=$(cat $PARFILE |grep SCHEMAS|awk -F'=' '{print $2}'|sed "s/,/\\n/g"|wc -l)

echo -e $FGBROWN "Checking if the schema names exists in the database." $RESET

# Start: Count the number of schemas present using the schemas defined in the parameter file.
SCHEMA_CHECK=$(sqlplus -s "/as sysdba" << EOF
set head off
set pause off
set pages 0
set feedback off
set term off
set echo off
set verify off
SELECT  COUNT(*)
FROM    dba_users
WHERE   username in (${SCHEMA_NAMES})
/
exit
EOF
)
# End: Count the number of schemas present using the schemas defined in the parameter file.

# Start: Check if the all the schemas defined in the parameter file exists in the database.
if [ $SCHEMA_COUNT == $SCHEMA_CHECK ]
then
  echo -e $FGBLUE "--All the schema $SCHEMA_NAMES requested to be exported are in the database [ OK ]" $RESET
else
  echo -e $FGRED "--Some of the schema $SCHEMA_NAMES requested to be exported are not present in the database..exiting! [ NOT OK ]" $RESET
  exit
fi
# End: Check if the all the schemas defined in the parameter file exists in the database.

# Start: Estimate the amount of space required for export to complete successfully.
expdp userid= \'/ as sysdba\' parfile=$PARFILE estimate_only=y

ESTIMATED_SIZE=$(cat /u01/oracle/11.2.0.3/rdbms/log/export.log|grep 'Total estimation'|awk '{printf("%d\n"), $6;}')
GB_OR_MB=$(cat /u01/oracle/11.2.0.3/rdbms/log/export.log|grep 'Total estimation'|awk '{print $7}')
# End: Estimate the amount of space required for export to complete successfully.

# Start: Convert estimated size to kilobytes.
if [ "$GB_OR_MB" == "KB" ]
then
  ESTIMATED_SIZE=$ESTIMATED_SIZE
elif [ "$GB_OR_MB" == "MB" ]
then
  ESTIMATED_SIZE=$(expr "$ESTIMATED_SIZE" \* 1024)
elif [ "$GB_OR_MB" == "MB" ]
then
  ESTIMATED_SIZE=$(expr "$ESTIMATED_SIZE" \* 1024 \* 1024)
fi
# End: Convert estimated size to kilobytes.

FREE_SPACE=$(df -kP "$DIR_PATH"|grep -v Filesystem|awk '{print $3}')

# Start: Check if export directory has sufficient free space to successfully export.
if [ $FREE_SPACE -gt $ESTIMATED_SIZE ]
then
  echo -e $FGBLUE "There is sufficient space in $DIR_PATH. Proceeding with exporting..! [ OK ]" $RESET
else
  echo -e $FGRED "Space is not sufficient in $DIR_PATH..exiting!" $RESET
  exit
fi
# End: Check if export directory has sufficient free space to successfully export.
