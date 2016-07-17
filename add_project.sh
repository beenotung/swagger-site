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

echo -n "new project name (do not contain \" ) : ";
read project_name

cmd="cp -r seed \"$project_name\"";
echo "$cmd";
echo "$cmd" | sh;

cd "$project_name";
echo "AuthType Basic"                                    > .htaccess
echo "AuthName \"Authentication Required\""             >> .htaccess
echo "AuthUserFile \"/var/www/api_doc/$project_name/.htpasswd\"" >> .htaccess
echo "Require valid-user"                               >> .htaccess

echo "demo:\$apr1$JJuyRiXp\$0ZFmCMPNzaDORrWFM098e1"     >> .htpasswd

echo -n "user name : ";
read username

htpasswd -c .htpasswd "$username"