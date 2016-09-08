#!/bin/bash
#apt-get install samba
#smbclient
#expect

pushd ../../distro/common/utils
    . ./sys_info.sh
popd

USER="guanhe"
PASSWD="123456"
NEW_DIR="share"
CONF_FILE="/etc/samba/smb.conf"
set -x
deluser $USER

/usr/bin/expect << EOD
set timeout 10
spawn adduser $USER
expect "password:"
send "$PASSWD\n"
expect "password:"
send "$PASSWD\n"
expect "Full Name"
send "\n"
expect "Room Number"
send "\n"
expect "Work Phone"
send "\n"
expect "Home Phone"
send "\n"
expect "Other"
send "\n"
expect "information correct"
send "Y\n"
expect eof
EOD


/usr/bin/expect <<EOF
spawn smbpasswd -a $USER
expect "New SMB password"
send "$PASSWD\n"
expect "Retype new SMB password"
send "$PASSWD\n"
expect eof
EOF

if [ ! -d /opt/$NEW_DIR ];then
mkdir /opt/$NEW_DIR
fi

cat<<EOF>>$CONF_FILE
[share]
comment = /root
writeable = yes
security = share
path = /opt/$NEW_DIR
browseable = yes
public = yes
EOF

/etc/init.d/smbd restart
if [ $? -ne 0 ];then
    printf_info 1 smbd_restart
    exit 0
else
    printf_info 0 smbd_restart
fi

/usr/bin/expect <<EOF
spawn smbclient //127.0.0.1/$NEW_DIR
expect "smb: \>"
send "exit\n"
expect eof
EOF
deluser $USER 
