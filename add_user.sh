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
find -type f -name ".htaccess" | awk -F '.' '{print $2}' | awk -F '/' '{print $2}' | grep -v '_publish$' | uniq | xargs -I {} echo "  " {}
echo -n "which project is this user for? ";
read project_name;
if [ ! -d "$project_name" ]; then
  echo "Error : project not found";
  exit 1;
fi

# input user type
echo -n "user permission (R/RW): ";
read permission;
project_folder="";
if [ $permission == "R" ]; then
#  echo "creating read only account...";
  project_folder=$project_name"_publish";
elif [ $permission == "RW" ]; then
#  echo "creating read write account...";
  project_folder="$project_name";
else
  echo "Error : invalid permission";
  exit 1;
fi

# input username
echo -n "username: ";
read username;
linecount=$(grep "^$username:" "$project_name/.htpasswd" | wc -l);
if [ $linecount != 0 ]; then
  echo "Error : user already exist";
  exit 1;
fi

# init password file
if [ ! -f "$project_folder/.htpasswd" ]; then
  touch "$project_folder/.htpasswd";
fi

# input password
res=$(htpasswd "$project_folder/.htpasswd" "$username");
if [ res != 0 ]; then
  echo "Error : password not match";
  exit 1;
fi

# ---- summary ----

if [ $permission == "R" ]; then
  echo "created read only account : $username";
elif [ $permission == "RW" ]; then
  echo -n "creating read write account : $username";
else
  echo "Assert Error : undefined permission $permission";
  exit 1;
fi

echo "All Done."
