#!/bin/bash

USERNAME="testing"
PASSWD="test123"

. ./sys_info.sh

function add_user()
{
    case $distro in
        "ubuntu" | "debian" )
            adduser $USERNAME
            ./expect_adduser.sh $USERNAME $PASSWD
            ;;
        "fedora" )
            useradd $USERNAME -d /home/$USERNAME
            ./expect_adduser.sh $USERNAME $PASSWD
            ;;
        "opensuse" )
            useradd $USERNAME -d /home/$USERNAME
            ./expect_adduser.sh $USERNAME $PASSWD
            ;;
        "centos" )
            adduser $USERNAME
            ./expect_adduser.sh $USERNAME $PASSWD
            ;;
    esac
}

user_exists=$(cat /etc/passwd|grep ${USERNAME})
if [ "$user_exists"x != ""x ]; then
    . ./del_user.sh
fi

add_user
if [ $? -ne 0 ]; then
    echo "add user $USERNAME fail"
    lava-test-case add-user-in-$distro --result fail
else
    echo "add user $USERNAME success"
    lava-test-case add-user-in-$distro --result pass
fi

