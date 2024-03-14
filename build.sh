#!/bin/bash

cd `dirname $0`
path=`pwd`

unsafe=("v2raya-install")

build_safe() {
    for file in "${unsafe[@]}" ; do
        mv content/post/${file} temp/
    done
    unset file
    build
    for file in "${unsafe[@]}" ; do
        mv temp/${file} content/post/
    done
}

build() {
    hugo
}

try() {
    sh ./test.sh $*
}

help() {
    printf "args: build | safe | try .\n"
}

case $1 in
  "safe")
    build_safe
    ;;
  "build")
    build
    ;;
  "try")
    try ${@:2}
    ;;
  *)
    help
    ;;
esac
