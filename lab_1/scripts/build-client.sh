#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR="${SCRIPT_DIR%/*}"
BUILD_DIR=$ROOT_DIR/dist/static

clientBuildFile=$ROOT_DIR/dist/client-app.zip

export $(grep -v '^#' $ROOT_DIR/.env | xargs '\n')

if [ -e $clientBuildFile ]; then
	rm $clientBuildFile
	echo "$clientBuildFile was removed"
fi

npm install

ENV_CONFIGURATION=production

cd $ROOT_DIR && ng build --configuration=$ENV_CONFIGURATION --output-path=$BUILD_DIR
zip -r $clientBuildFile $BUILD_DIR

bash $ROOT_DIR/scripts/countfilesdeep.sh $BUILD_DIR

echo "Client app was build with $ENV_CONFIGURATION configuration."


