#!/bin/sh

# This script:
#   1) Reads microservices.list
#   2) Performs a gradle build on each line in the file

source ./commons.sh

build()
{
  echo_msg "Building $1"
  cd $1
  BUILD_TYPE=`ls | grep build.gradle`
  if [ -z $BUILD_TYPE ]
  then
    #Assume Maven
    mvn compile package ; sleep 4
  else
    #Assume Gradle
    ./gradlew build ; sleep 4
  fi
}

main()
{
  file="microServices.list"
  while IFS= read -r app
  do
    if [ ! "${app:0:1}" == "#" ]
    then
      build ${app} &
    fi
  done < "$file"
  wait
}

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0
