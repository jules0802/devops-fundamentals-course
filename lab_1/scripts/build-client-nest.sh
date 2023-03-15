#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR="${SCRIPT_DIR%/*}"
BUILD_DIR=$ROOT_DIR/dist

clientBuildFile=$ROOT_DIR/dist/client-app.zip

export $(grep -v '^#' $ROOT_DIR/.env | xargs '\n')

cd $ROOT_DIR
yarn install

rimraf dist

ENV_CONFIGURATION=production

nest build
zip -r $clientBuildFile $BUILD_DIR

echo "Client app was build with $ENV_CONFIGURATION configuration."
