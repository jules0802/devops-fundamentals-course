#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR="${SCRIPT_DIR%/*}"

cd $ROOT_DIR

npm install
npm audit
ng test --watch=false
ng e2e
ng lint
