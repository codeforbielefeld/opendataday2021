#!/bin/bash
#
# fetchSensorCommunityArchives per Year
# based on fetchLuftDatenInfoArchive-2019
#
# requires: getSensorCommunityArchive.sh
#
# 2018/19 ; Andreas Cz ; initial
# 2020-01 ; Andreas Cz ; changes from Luftdaten.info to Sensor.Community

#### must be set
# BASEDIR is the main directory
BASEDIR="~/AirQualityData/archive.luftdaten.info"
####


if [ -z "$1" ]
  then
    YEAR="2019"
else
    if [ "--help" == "$1"]; then
      echo "Usage:  $0 [YEAR]"
      echo
      echo " --help :  this help"
      echo " [YEAR] :  like '2019' or '2020'"
      exit 2
    else
      YEAR=$1
    fi    
fi

####
CMDDATE=`which date`
####

for month in $(seq -f "%02g" 1 12) ; do
  for day in $(seq -f "%02g" 1 31) ; do

	MYDATE=`${CMDDATE} -d "${month}/${day}/${YEAR}" 2> /dev/null `
	RET=$?
	
	if [ "$RET" == "0" ] ; then
  	  echo ${YEAR}-$month-${day}
  	  CMONTH=`${CMDDATE} +%m_%h --date="${YEAR}-${month}-${day}"`
  	  if [ ! -d "${BASEDIR}/$YEAR/$CMONTH/${YEAR}-${month}-${day}" ] ; then 
            ./getSensorCommunityArchveFile.sh ${day} ${month} ${YEAR}
          fi
  	fi  	

  done
done
