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

echo "project list :"
find -type f -name ".htaccess" | awk -F '.' '{print $2}' | awk -F '/' '{print $2}' | xargs -I {} echo "  " {}
echo -n "which project is this user for? ";
read project_name;
if [ ! -d "$project_name" ]; then
  echo "Error : project not found";
  exit 1;
fi

echo -n "username: ";
read username;
linecount=$(grep "^$username:" "$project_name/.htpasswd" | wc -l);
if [ $linecount != 0 ]; then
  echo "Error : user already exist";
  exit 1;
fi

echo -n "user permission (R/RW): ";
read permission;
if [ $permission == "R" ]; then
  echo "creating read only account...";
elif [ $permission == "RW" ]; then
  echo "creating read write account...";
else
  echo "Error : invalid permission";
  exit 1;
fi

echo "All Done."
