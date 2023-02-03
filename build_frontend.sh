#!/bin/sh

CURRENT_DIR=${PWD}

# build the frontend app
mkdir -p tmp
cd tmp
git clone https://github.com/ninoseki/mihari-frontend.git

cd mihari-frontend
npm install
npm run build

trash -r ${CURRENT_DIR}/lib/mihari/web/public/
mkdir -p ${CURRENT_DIR}/lib/mihari/web/public/
cp -r dist/* ${CURRENT_DIR}/lib/mihari/web/public

# remove tmp dir
rm -rf ${CURRENT_DIR}/tmp/mihari-frontend