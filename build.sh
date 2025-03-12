#!/bin/bash

setup() {
    name="blog"
    desc="cheni-zqs的blog网站，用hugo搭建，主题为stack。"
}

get_commit() {
    [[ -z $1 ]] && read -p "input commit info: " input && {
        [[ -z "$input" ]] && echo "no input." && return 1
    }
    [[ -z "$input" ]] && input=$*
    return 0
}

build_local() {
    [[ -d public ]] && rm -r public
    hugo --config hugo-local.yaml
}

build_github() {
    [[ -d docs ]] && rm -r docs
    hugo --config hugo-github.yaml --buildDrafts
}

update_git() {
    git add ./
    if [[ -z $1 ]] ; then
        content="update: Auto build by runsh at $(date +%F_%T)"
    else
        content="$* at $(date +%F_%T)"
    fi
    git commit -m "${content}"
}

push_git() {
    git push github master:main
}

#delete

init() {
    cd $(dirname $0)
    path=$(pwd)
    setup
}

p_help() {
    echo "desc: ${desc}"
    echo "args: -l | --local COMMIT   : build local"
    echo "      -g | --github COMMIT  : build github"
    echo "      -a | --all COMMIT     : build both"
    echo "      -n | --no local/github : build but not git"
    echo "      *                     : print help"
    echo "commit: TYPE: content"
    echo "   e.t. update: this is a simple update info."
}

init
case $1 in
    "-l"|"--local"|"local")
        build_local
        get_commit ${@:2} || exit 1
        update_git $input
        ;;
    "-g"|"--github"|"github")
        build_github
        get_commit ${@:2} || exit 1
        update_git $input
        push_git
        ;;
    "-a"|"--all"|"all")
        build_local
        build_github
        get_commit ${@:2} || exit 1
        update_git $input
        push_git
        ;;
    "-n"|"--no"|"no")
        case $2 in
            "l"|"local")
                build_local
                ;;
            "g"|"github")
                build_github
                ;;
            *)
                build_local
                build_github
                ;;
        esac
        exit 0
        ;;
    *)
        p_help && exit 0
        ;;
esac
