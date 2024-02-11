#!/bin/bash
# shellcheck disable=1090
# shellcheck disable=2139

# get the wsl2 ip
WSL2_HOST_IP=$(grep -oP '(?<=nameserver\ ).*' /etc/resolv.conf) || { echo -e "\e[1;33mError to get the WSL2 ip.\e[0m" && exit 0; }

# start the proxy
if [ "$1" = "start" ];then
    # modify the .*rc
    if grep -q "&& source system_proxy_config.sh" ~/."${SHELL##*/}"rc;then
        sed -i 's/\&\& source system_proxy_config.sh [a-z]\+_system_proxy /\&\& source system_proxy_config.sh start_system_proxy /g' ~/."${SHELL##*/}"rc
    else
        echo -e "\e[1;31mYou should config clash_wsl2_tools first.\e[0m"
    fi
    # immediately effective
    source ~/."${SHELL##*/}"rc
# stop the proxy
elif [ "$1" = "stop" ];then
    if grep -q "&& source system_proxy_config.sh" ~/."${SHELL##*/}"rc;then
        sed -i 's/\&\& source system_proxy_config.sh [a-z]\+_system_proxy /\&\& source system_proxy_config.sh stop_system_proxy /g' ~/."${SHELL##*/}"rc
    else
        echo -e "\e[1;31mYou should config clash_wsl2_tools first.\e[0m"
    fi
    unset https_proxy http_proxy
# check the proxy
elif [ "$1" = "check" ];then
    response=$(curl -s --head https://www.google.com/)
    if echo "${response}" | grep "200 Connection established" > /dev/null; then
        if echo "${response}" | grep "HTTP/.* 200" > /dev/null; then
            echo -e "\e[1;32mDetect you can already connect to Google.\e[0m" && exit 0
        else echo -e "\e[1;31mERROR: Connection established but no response.\e[0m" && exit 0
        fi
    else
        echo -e "\e[1;33mCan't connect to Google.\e[0m"
        echo "Start checking whether can ping through WSL2 ip."
        # use ping to check the ip
        if ping -c 1 "${WSL2_HOST_IP}" > /dev/null 2>&1; then
            echo -e "\e[1;32mip: ${WSL2_HOST_IP} ping passed.\e[0m"
        else
            echo -e "\e[1;33mError: ip: ${WSL2_HOST_IP} ping failed, please refer to this url to configure your Windows firewall: https://l02hj41pak.feishu.cn/wiki/NaVbwISZoiMysYkwIFQcWt67nVf?from=from_copylink .\e[0m"
        fi
        exit 0
    fi
else
    # config or reconfig the port of Clash
    if [ -z "$2" ];then
        if grep -q "&& source system_proxy_config.sh" ~/."${SHELL##*/}"rc;then
            sed -i 's/_system_proxy [0-9]\+ \&\& cd ~/_system_proxy '"$1"' \&\& cd ~/g' ~/."${SHELL##*/}"rc
        else echo -e "\ncd $(pwd) && source system_proxy_config.sh stop_system_proxy $1 && cd ~" >> ~/."${SHELL##*/}"rc
        fi
        # immediately effective
        source ~/."${SHELL##*/}"rc
        echo -e "\e[1;32mConfig OK. Please don't delete or move the software folder, or the config will be ineffective.\e[0m"
    # use or not use proxy
    else
        # set cmd alias
        alias proxy_start="source $(pwd)/system_proxy_config.sh start"
        alias proxy_stop="source $(pwd)/system_proxy_config.sh stop"
        alias proxy_check="$(pwd)/system_proxy_config.sh check"
        # set the proxy
        if [ "$1" = "start_system_proxy" ];then
            export https_proxy="http://${WSL2_HOST_IP}:$2"
            export http_proxy="http://${WSL2_HOST_IP}:$2"
        elif [ "$1" != "stop_system_proxy" ];then
            echo -e "\e[1;33mThere must be something wrong with your system_proxy config, because the flag is $1. \e[0m"
        fi
    fi
fi
