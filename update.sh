#!/usr/bin/env bash

# update the published api document
# copy api to publish folder

# ---- main body ----

find -type f -name ".htaccess" | awk -F '.' '{print $2}' | grep -v '^/$' | awk -F '/' '{print $2}' | grep -v '_publish$' | grep -v '^seed$' | uniq
echo "All Done.";
