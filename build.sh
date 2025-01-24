#!/bin/bash

setup() {
    name="blog"
    desc="cheni-zqs的blog网站，用hugo搭建，主题为stack。"
}

build_draft() {
    update_git $*
    delete_old_public
    hugo --buildDrafts
}

build() {
    update_git $*
    delete_old_public
    hugo
}

update_git() {
    git add ./
    if [[ -z $1 ]] ; then
        content="update: Auto build by ./build.sh at $(date +%F_%T)"
    else
        content="update: $*. Auto build by ./build.sh at $(date +%F_%T)"
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
    echo "desc: ${desc}"
    echo "args: build | draft ."
}

init
case $1 in
  "draft")
    build_draft ${@:2}
    ;;
  "build")
    build ${@:2}
    ;;
  *)
    help
    ;;
esac
