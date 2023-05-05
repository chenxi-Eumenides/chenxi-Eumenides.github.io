#!/bin/bash

if [ -z "$1" ] ; then
    echo "无提交信息"
    exit
fi
echo "\"$@\""
git add .
git commit -m "test:test script 2"
hugo build
