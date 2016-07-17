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

# init password file
if [ ! -f "$project_folder/.htpasswd" ]; then
  touch "$project_folder/.htpasswd";
fi

# input username
## if remove user, exit after done
## if edit password or add new user, continue after this block
echo -n "username: ";
read username;
is_user_exist=$(grep "^$username:" "$project_folder/.htpasswd" | wc -l);
should_ask_password=1;
summary_message="";
if [ "$is_user_exist" == 0 ]; then
  echo "User \"$username\" not found.";
  echo -n "Are you going to create new user \"$username\"? (y/n) ";
  read line;
  if [ $line == "y" ]; then
    # -- create user --
    summary_message="created ($permission) user \"$username\" from project \"$project_name\"";
  elif [ $line == "n" ]; then
    echo "cancelled.";
    exit 0;
  else
    echo "Error : invalid input";
    exit 1;
  fi
else
  echo "User \"$username\" found.";
  echo -n "Are you going to [c]hange password or [r]emove this user? (c/r) :";
  read line;
  if [ $line == "r" ]; then
    # -- remove user --
    should_ask_password=0;
    summary_message="removed ($permission) user \"$username\" from project \"$project_name\"";
    cat "$project_folder/.htpasswd" | grep -v "^$username:" > temp
    mv temp "$project_folder/.htpasswd"
  elif [ $line == "c" ]; then
    summary_message="changed password of ($permission) user \"$username\" from project \"$project_name\"";
  else
    echo "Error : invalid input";
    exit 1;
  fi
fi

# input password
trap catch_errors ERR;
function catch_errors() {
  echo "Error : password not matched";
  exit 1;
}
if [ "$should_ask_password" == 1 ]; then
  res=$(htpasswd "$project_folder/.htpasswd" "$username");
fi
#echo "password result = \"$res\""
#if [ res != 0 ]; then
#  echo "Error : password not match";
#  exit 1;
#fi

# ---- summary ----

echo "$summary_message";
#if [ "$is_user_exist" == 0 ]; then
#  if [ ${permission} == "r" ]; then
#    echo "created read only account : $username";
#  elif [ ${permission} == "rw" ]; then
#    echo -n "creating read write account : $username";
#  else
#    echo "Assert Error : undefined permission $permission";
#    exit 1;
#  fi
#fi


echo "All Done."
