#!/bin/sh

# This script:
#   1) Reads PCFServices.list
#   2) Creates the Services
#      a) Hack 1 - handle the correct quotations for Github URI
#      b) Hack 2 - handles changed name of MySQL plan between PCF versions

#set -x
source ./commons.sh

create_single_service()
{
  line="$@"
  SI=`echo "$line" | cut -d " " -f 3`
  EXISTS=`cf services | grep ${SI} | wc -l | xargs`
  if [ $EXISTS -eq 0 ]
  then
      cf create-service $line
  else
    echo_msg "${SI} already exists"
  fi
}

create_all_services()
{
  # Read all the services that need to be created
  file="./PCFServices.list"
  while IFS= read -r line 
  do
    if [ ! "${line:0:1}" == "#" ]   #Skip comments
    then
      create_single_service "$line" 
    fi
  done < "$file"
  echo_msg "Services created"
}

main()
{
  create_all_services
  summaryOfServices
}

main
printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0
