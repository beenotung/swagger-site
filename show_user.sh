#!/usr/bin/env bash

# ---- util functions ----

function hasCommand {
  if hash $1 2>/dev/null; then
    echo "1"
  else
    echo "0"
  fi
}

function checkCommand {
  res=$(hasCommand "$1");
  if [ "$res" == "0" ]; then
    echo "Error : missing $1";
    echo "  Please install $1 and add the path";
    exit 1;
  fi
};

# ---- check requirement ----

$(checkCommand htpasswd);

# ---- main body ----

# input project
echo "project list :"
find -type f -name ".htaccess" | awk -F '.' '{print $2}' | grep -v '^/$' | awk -F '/' '{print $2}' | grep -v '_publish$' | grep -v '^seed$' | uniq | sed 's/^/  > /'
echo -n "which project is this user for? ";
read project_name;
if [ ! -d "$project_name" ]; then
  echo "Error : project not found";
  exit 1;
elif [ "$project_name" == "seed" ]; then
  echo "Error : project seed is not editable";
  exit 1;
fi

# input user type
echo -n "user type ? [e]ditor / [g]uest (e/g): ";
read line;
project_folder="";
permission="";
if [ $line == "g" ]; then
#  echo "creating read only account...";
  project_folder=$project_name"_publish";
  permission="guest"
elif [ $line == "e" ]; then
#  echo "creating read write account...";
  project_folder="$project_name";
  permission="editor"
else
  echo "Error : invalid permission";
  exit 1;
fi

echo "The ($permission) users under project \"$project_name\":";
cat "$project_folder/.htpasswd" | grep ':' | awk -F ':' '{print $1}' | sed 's/^/  \> /';

# ---- summary ----

echo "All Done."
