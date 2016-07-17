#!/usr/bin/env bash

## requirement
# assume the apache document root is /var/www
# require to enable symbolic under the vhost
# require the /var/www/api_doc link to this folder (the working directory of this install.sh)
#
# the vhost conf file should looks like this:
# ```
# <VirtualHost *:8081>
#         #ServerName www.example.com
#
#         ServerAdmin webmaster@localhost
#         DocumentRoot /var/www/api_doc
#
#         #LogLevel info ssl:warn
#
#         ErrorLog ${APACHE_LOG_DIR}/error.log
#         CustomLog ${APACHE_LOG_DIR}/access.log combined
#
#         #Include conf-available/serve-cgi-bin.conf
#
#         <Directory /var/www/api_doc/>
#                 Options Indexes FollowSymLinks    # the folder will appear after login (first time need to know the folder name (full url) externally )
#                 #Options FollowSymLinks
#                 #AllowOverride None
#                 AllowOverride AuthConfig
#                 #Require all granted
#                 Order allow,deny
#                 Allow from all
#         </Directory>
#
# </VirtualHost>
# ```


# download swagger-editor bundle as seed project
wget https://github.com/swagger-api/swagger-editor/releases/download/v2.10.3/swagger-editor.zip
unzip swagger-editor.zip
rm swagger-editor.zip
mv swagger-editor seed

# set up seed project
cd seed;
echo "AuthType Basic"                                    > .htaccess
echo "AuthName \"Authentication Required\""             >> .htaccess
echo "AuthUserFile \"/var/www/api_doc/seed/.htpasswd\"" >> .htaccess
echo "Require valid-user"                               >> .htaccess

echo "demo:\$apr1$JJuyRiXp\$0ZFmCMPNzaDORrWFM098e1"      > .htpasswd
