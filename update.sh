#!/bin/bash

if [ -z "$1" ] ; then
    echo "无提交信息"
    exit
fi
echo "1: $1:${@:2}"
git add .
git commit -m "$1:${@:2}"
hugo
