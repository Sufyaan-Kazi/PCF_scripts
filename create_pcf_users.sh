#!/bin/sh

# Input args:
#  1) Template username
#  2) Org Name
#  3) api URL of PCF env
#  4) admin password

if [[ $# -eq 0 ]] ; then
    echo 'Enter a username to use as a template'
    exit 1
fi

adminUser=admin
adminPassword=$4
spaceName=dev
api=https://$3
args=--skip-ssl-validation
userName=$1
max=10
orgName=$2

date
cf api $api $args
cf auth $adminUser $adminPassword
cf delete-org -f $orgName
cf create-org $orgName
for ((i=1; i<=$max; ++i )) ;
 do
  echo "$userName$i"
  cf create-space $spaceName$i -o $orgName
  cf delete-user -f $userName$i
  cf create-user $userName$i $userName$i
  cf set-org-role $userName$i $orgName OrgManager
  cf set-space-role $userName$i $orgName $spaceName$i SpaceDeveloper
 done
cf logout
date
exit 0
