#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR="${SCRIPT_DIR%/*}"

cd $ROOT_DIR

yarn install
yarn audit
jest
jest --config ./test/jest-e2e.json
eslint "./{src,test}/**/*.{js,jsx,ts,tsx}"