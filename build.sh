#!/bin/bash

config() {
    name="blog" # 必填
    desc="我自己的blog网站，用hugo搭建，主题为stack。支持新建文章、构建、git推送。" # 描述

    # 0:verbose 1:info 2:warning 3:error 4:panic 5:quiet
    log_level=1 # 输出日志等级
    enable_log_file=true # 是否开启日志

    log_file="${file_name%.*}.log" # 日志文件名
    log_file_max_line=10000

    hugo_arg_local="--config hugo-local.yaml"
    hugo_arg_github="--config hugo-github.yaml --buildDrafts"
    arg_quiet="--quiet"
}

# 新建文章: -n <title>
new_content() {
    local title=$1
    [[ -z "$title" ]] && log 3 "post title required" && return 1
    log 1 "creating new post: $title"
    hugo new content "content/post/$(date +%F)_${title}/index.md"
}

# 构建
build_local() {
    log 1 "start build local"
    [[ -d public ]] && rm -r public
    if $enable_log_file ; then
        hugo ${hugo_arg_local} ${arg_quiet} >> $log_file 2>&1
    else
        hugo ${hugo_arg_local} ${arg_quiet}
    fi
}

build_github() {
    log 1 "start build github"
    [[ -d github ]] && rm -r github
    if $enable_log_file ; then
        hugo ${hugo_arg_github} ${arg_quiet} >> $log_file 2>&1
    else
        hugo ${hugo_arg_github} ${arg_quiet}
    fi
}

build_all() {
    build_local || { log 3 "local build failed"; return 1; }
    build_github || { log 3 "github build failed"; return 1; }
}

# git add all + commit + push (不做构建)
git_push() {
    local commit_msg=$1
    log 1 "start git push"

    # 追加时间戳
    local content="${commit_msg} at $(date +%F_%T)"

    if $enable_log_file ; then
        git add --all >> $log_file 2>&1
        git commit -m "${content}" >> $log_file 2>&1
        git push github master:main >> $log_file 2>&1
    else
        git add --all
        git commit -m "${content}"
        git push github master:main
    fi

    log 1 "git push done"
}

main() {
    case $1 in
        "-n"|"--new"|"new")
            new_content "${@:2}" || return 1
            ;;
        "-b"|"--build"|"build")
            build_all || return 1
            ;;
        "-g"|"git")
            local commit_msg="${@:2}"
            [[ -z "$commit_msg" ]] && log 3 "commit message required" && return 1
            git_push "$commit_msg" || return 1
            ;;
        "-a"|"--all"|"all")
            local commit_msg="${@:2}"
            [[ -z "$commit_msg" ]] && log 3 "commit message required" && return 1
            build_all || return 1
            git_push "$commit_msg" || return 1
            ;;
        "-h"|"--help"|"help"|*)
            print_help && return 0
            ;;
    esac
}

init() {
    cd "$(dirname "$0")"
    file_name=$(basename "$0")
    path=$(pwd)
    config && config_check || return 1
    echo "" >> $log_file
    log 1 "start init"
}

close() {
    local main_return=$1
    if [[ ${main_return-default} == "default" ]] ; then
        log 1 "init failed"
        $enable_log_file && echo "init failed"
    elif [[ $main_return == "0" ]] ; then
        log 1 "main success"
        $enable_log_file && echo "main success"
    else
        log 1 "main failed"
        $enable_log_file && echo "main failed"
    fi
    log_flash
    exit 0
}

print_help() {
    echo "desc: ${desc}"
    echo ""
    echo "用法: ./build.sh <模式> [参数]"
    echo ""
    echo "模式:"
    echo "  -n POST_TITLE  新建文章"
    echo "  -b             构建（本地 + github）"
    echo "  -g COMMIT_MSG  git: add all → commit → push"
    echo "  -a COMMIT_MSG  构建 + git 推送（一步到位）"
    echo "  -h             输出帮助信息"
    echo ""
    echo "示例:"
    echo "  ./build.sh -n my-new-post"
    echo "  ./build.sh -b"
    echo "  ./build.sh -g \"new: add new blog post\""
    echo "  ./build.sh -a \"new: add new blog post\""
    echo ""
    echo "commit 类型:"
    echo "   init:  初始化"
    echo "   new:   新增文章/文件"
    echo "   fix:   修复"
    echo "   feat:  新功能/特性"
    echo "   update: 更新内容"
    echo "   merge:  合并代码"
    echo "   test:   测试"
    echo "   perf:   性能优化"
    echo "   docs:   文档"
    echo "   sync:   同步分支"
}

config_check() {
    return_code=0
    [[ -z "${name}" ]] && log 3 "empty name, disable to run" && return_code=1
    ! [[ $log_level =~ ^[0-5]$ ]] && log_level=2 && log 2 "log level wrong, set default. ($log_level)"
    $enable_log_file && ! [[ -f $log_file ]] && enable_log_file=false && log 2 "log file ${log_file} not exist, disable log file."
    $enable_log_file && ! [[ $log_file_max_line =~ ^[0-9]+$ ]] && log_file_max_line=2 && log 2 "log file max line wrong, set default. ($log_file_max_line line)"
    return $return_code
}

log() {
    # 0:verbose 1:info 2:warning 3:error 4:panic 5:output
    local level=$1
    local msg=${@:2}
    local func=${FUNCNAME[1]}
    local log_level_name=("VERBOSE" "INFO" "WARN" "ERROR" "PANIC")
    local log_color=("\e[37m" "\e[97m" "\e[33m" "\e[31m" "\e[91m")

    ! [[ $level =~ ^[0-5]$ ]] && level=3 && msg="args error ( \$1 : $1 )"
    [[ $func == "log_return" ]] && func=${FUNCNAME[2]}

    if $enable_log_file ; then
        local log_content="[${log_level_name[${level}]}] (${func}) : ${msg}"
        if (( $level >= $log_level )) ; then
            echo "$log_content" >> $log_file 2>&1
        fi
    else
        local log_content="[${log_color[${level}]}${log_level_name[${level}]}\e[0m] (${func}) : ${msg}"
        if [[ $level = 5 ]] || (( $level >= $log_level )) ; then
            echo -e "$log_content"
        fi
    fi
}

log_return() {
    return_code=$1
    ! [[ $return_code =~ ^[0-9]+$ ]] && return_code=1
    log ${@:2}
    return $return_code
}

log_flash() {
    $enable_log_file || return 0
    line=$(wc -l ${log_file} | awk '{print $1}')
    [ $line -gt $log_file_max_line ] && {
        log 2 "log file line ${line}, too large."
        [[ -f ${log_file}.temp ]] || touch ${log_file}.temp
        tail -n ${log_file_max_line:0:$[${#log_file_max_line}-1]} $log_file > ${log_file}.temp
        rm ${log_file}
        mv ${log_file}.temp $log_file
    }
    unset line
}

init && {
    main $*
    main_return=$?
}
close $main_return
