#!/bin/bash

cd `dirname $0`
path=`pwd`


build_draft() {
    delete_old_public
    hugo --buildDrafts
}

build() {
    delete_old_public
    hugo
}

delete_old_public(){
    rm -r ./public/
}

help() {
    printf "args: build | draft .\n"
}

case $1 in
  "draft")
    build_draft
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
