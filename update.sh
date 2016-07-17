#!/usr/bin/env bash

# update the published api document
# copy api to publish folder

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Name"
  echo "  update.sh [flag]"
  echo ""
  echo "Default Flag : --loop 30"
  echo ""
  echo "Flags"
  echo "  -h | --help   show this help message"
  echo "  -o | --once   update without loop"
  echo "  -l | --loop   fork into background, update per $2 second"
  echo "  -k | --kill   stop background update"
  echo "             "
  echo "Examples"
  echo "  update.sh --once"
  echo "    (update once in foreground)"
  echo ""
  echo "  update.sh --loop 30"
  echo "    (update in each 30 seconds in background)"
  echo ""
  echo "  update.sh --kill"
  echo "    (stop previous background update process)"
  exit 0;
fi

# ---- main body ----

function syncProject() {
  project_name="$1";
  echo "syncing project \"$project_name\"...";
  cp -rf "$project_name" "$project_name""_publish"
  return 0;
}
export -f syncProject

function update() {
  find -type f -name ".htaccess" | awk -F '.' '{print $2}' | grep -v '^/$' | awk -F '/' '{print $2}' | grep -v '_publish$' | grep -v '^seed$' | uniq | xargs -I {} echo syncProject {} | bash
  echo "finished update all projects.";
}

function update_loop() {
  while [ -f ".run" ]; do
    update
    duration=30
    if [ "$#" == 2 ]; then
      duration="$2"
    fi
    echo "sleep for $duration seconds"
    sleep "$duration"
  done
}

if [ "$1" == "-o" ] || [ "$1" == "--once" ]; then
  update
elif [ "$1" == "-k" ] || [ "$1" == "--kill" ]; then
  if [ -f ".run" ]; then
    rm .run;
    echo "stopped background update";
  else
    echo "no background update is running";
  fi
elif [ "$#" == 0 ] || [ "$1" == "-l" ] || [ "$1" == "--loop" ]; then
  if [ -f ".run" ]; then
    echo "already running? run with --help to show help message";
  else
    touch .run
    echo "forked into background"
    update_loop &
  fi
else
  echo "Invalid paramenter";
  sh update.sh -h
fi

