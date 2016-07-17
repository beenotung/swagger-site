#!/usr/bin/env bash

## download swagger-editor
#git clone https://github.com/swagger-api/swagger-editor.git seed
#
## build swagger-editor
#cd seed
#res=$(npm install && npm run build)
#if [ res != 0 ]; then
#  echo "failed to build swagger-editor, please update the npm and node(js)";
#  exit 1;
#fi
#cd ../
#
## clean up swagger-editor


# download swagger-editor bundle
wget https://github.com/swagger-api/swagger-editor/releases/download/v2.10.3/swagger-editor.zip
unzip swagger-editor.zip
rm swagger-editor.zip
mv swagger-editor seed


# set project