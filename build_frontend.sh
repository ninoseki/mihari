#!/bin/sh

CURRENT_DIR=${PWD}

cd frontend
npm install
npm run build

trash -r ${CURRENT_DIR}/lib/mihari/web/public/
mkdir -p ${CURRENT_DIR}/lib/mihari/web/public/
cp -r dist/* ${CURRENT_DIR}/lib/mihari/web/public
