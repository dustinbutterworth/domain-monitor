#!/usr/bin/env bash

cd $(dirname $0)

if [[ $# -eq 0 ]]; then
   echo "Usage: $0 <domain_name>" 
   exit 1
fi

domain=${1}

if [ ! -e "${domain}-list.txt" ]; then
    echo "No files have been created yet, running for the first time." 
    echo "Running subfinder and generating domain lists."
    subfinder -d ${domain} -silent -o ${domain}.json -oJ 
    jq '.host' ${domain}.json -r | tee ${domain}-list.txt
    echo "Done."
    exit 0
else
    echo "Recon has been run before, checking for differences."
    echo "Backing up old files."
    cp ${domain}-list.txt ${domain}-list.txt.bak
    cp ${domain}.json ${domain}.json.bak

    echo "Cleaning up previous diff file."
    cat /dev/null > ${domain}-diff.txt

    echo "Running subfinder and generating domain lists."
    subfinder -d ${domain} -silent -o ${domain}.json -oJ 
    jq '.host' ${domain}.json -r | tee ${domain}-list.txt
fi

echo "Checking if any new domains from previous run"
cat ${domain}-list.txt | anew -d ${domain}-list.txt.bak | tee ${domain}-diff.txt

echo "Checking ${domain}-diff.txt"
if [ $(wc -l < "${domain}-diff.txt") -eq 0 ]; then
    echo "No new domains since last run."
else
    echo "New domains discovered since last run."
    notify -rate-limit=5 -data ${domain}-diff.txt -bulk
fi

