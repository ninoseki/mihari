#!/bin/sh

CURRENT_DIR=${PWD}

# build the frontend app
mkdir -p tmp
cd tmp
git clone https://github.com/ninoseki/mihari-frontend.git
cd mihari-frontend
npm install
npm run build

cp -r dist/* ${CURRENT_DIR}/lib/mihari/web/public

# replace favicon path
sed -i "" 's/href="\/favicon.ico"/href="\/static\/favicon.ico"/' ${CURRENT_DIR}/lib/mihari/web/public/index.html

# remove tmp dir
rm -rf ${CURRENT_DIR}/tmp/mihari-frontend