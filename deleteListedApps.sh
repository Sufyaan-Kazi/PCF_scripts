#!/bin/sh

source ./commons.sh

delete()
{
  cf delete -f -r $1
}

summaryOfApps

file="./microServices.list"
while IFS= read -r app
do
  if [ ! "${app:0:1}" == "#" ]
  then
    delete ${app##*/} &
  fi
done < "$file"
wait

summaryOfApps
exit 0
