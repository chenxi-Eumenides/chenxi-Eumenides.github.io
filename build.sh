#!/bin/bash

setup() {
    name="blog"
    desc="just for test, dont run this file."
}

build_draft() {
    update_git draft
    delete_old_public
    hugo --buildDrafts
}

build() {
    update_git
    delete_old_public
    hugo
}

update_git() {
    git add ./
    if [[ -z $1 ]] ; then
        content="update:auto build by ./build.sh at $(date +%F_%T)"
    else
        content="update:auto build by ./build.sh at $(date +%F_%T) with $*"
    fi
    git commit -m "${content}"
}

delete_old_public(){
    rm -r ./public/
}

init() {
    cd $(dirname $0)
    path=$(pwd)
    setup
}

help() {
    printf "desc: %s\n" ${desc}
    printf "args: build | draft .\n"
}

case $1 in
  "draft")
    build_draft
    ;;
  "build")
    build
    ;;
  *)
    help
    ;;
esac
