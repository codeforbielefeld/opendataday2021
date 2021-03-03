#!/bin/bash
#
# get data files from Sensor.Community archive from a specific day(s)
#
# 2018/19 ; Andreas Cz ; inital
# 2020-01 ; Andreas Cz ; changes from Luftdaten.info to Sensor.Community archive
#

#### must be set
# BASENAME is the subdir to store and organize the data files
BASENAME="archive.sensor.community"
# BASEDIR is the main directory
BASEDIR="~/AirQualityData/${BASENAME}"
####

if [ -z "$1" ]
  then
    echo "No argument supplied."
    echo "usage example: $0 25 [02 [2019]]"
    echo "  - for Februar 25 2019"
    exit 2
fi

DAY=$1

####
CMDDATE=`which date`
CMDWGET=`which wget`
CMDLS=`which ls`
CMDMKDIR=`which mkdir`
CMDMV=`which mv`
CMDXZ=`which xz`

FILEPARTS="_sds _b _d _h _p html txt"
####

if [ -z "$2" ]
  then
    MONTH=`${CMDDATE} +%m`
    echo "set month"
else
  MONTH=$2
fi

if [ -z "$3" ]
  then
    YEAR=`${CMDDATE} +%Y`
    echo "set year"
else
  YEAR=$3
fi


echo -e "\nget data from Sensor.Community archive for ${YEAR}-${MONTH}-${DAY}*"
#wget -m -I "${YEAR}-${MONTH}-${DAY}*" https://archive.luftdaten.info/
${CMDWGET} -m -I "${YEAR}-${MONTH}-${DAY}*" https://archive.sensor.community/


COLLECTEDDATES=`ls ${BASENAME} | egrep '20[0-2][0-9]-[0-3][0-9]-[0-3][0-9]' `
for d in ${COLLECTEDDATES}; do
  echo $d
  CYEAR=`${CMDDATE} +%Y --date="$d"`
  CMONTH=`${CMDDATE} +%m_%h --date="$d"`
  ${CMDMKDIR} -p "${BASEDIR}/$CYEAR/$CMONTH"
  ${CMDMV} -f ${BASENAME}/$d ${BASEDIR}/$CYEAR/$CMONTH
  # compress csv files to save storage space
  for filepart in ${FILEPARTS}; do
    CSVFILES=`${CMDLS} ${BASEDIR}/$CYEAR/$CMONTH/$d/*${filepart}* | grep -v "\.xz" | grep -v "_indoor" `
    ${CMDXZ} --compress --threads=3 --quiet -7 ${CSVFILES} > /dev/null &
  done
  wait
done

