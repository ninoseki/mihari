#!/bin/sh

CURRENT_DIR=${PWD}

mkdir -p tmp
cd tmp
git clone https://github.com/ninoseki/mihari-frontend.git
cd mihari-frontend
npm install
npm run build

cp -r dist/* ${CURRENT_DIR}/lib/mihari/web/public

rm -rf ${CURRENT_DIR}/tmp/mihari-frontend