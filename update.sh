#!/bin/bash

if [ -z "$1" ] ; then
    echo "无提交信息"
    exit
fi
git add .
git commit -m \""$@"\"
hugo build
