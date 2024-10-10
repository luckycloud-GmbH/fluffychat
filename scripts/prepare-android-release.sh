#!/usr/bin/env bash
cd android
echo $FDROID_KEY | base64 --decode --ignore-garbage > key.jks
echo "storePassword=${FDROID_KEY_PASS}" >> key.properties
echo "keyPassword=${FDROID_KEY_PASS}" >> key.properties
echo "keyAlias=key" >> key.properties
echo "storeFile=../key.jks" >> key.properties
ls | grep key
cd ..