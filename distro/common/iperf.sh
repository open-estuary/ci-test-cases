#!/bin/bash
iperf_url="https://sourceforge.net/projects/iperf/files/latest/download/iperf-2.0.5.tar.gz"
iperf_tar="iperf-2.0.5.tar.gz"
cur_path=$PWD
iperf_dir="iperf-2.0.5"
if [ ! -e $iperf_tar ];then
wget $iperf_url
tar -xvf $iperf_url
cd $cur_path/$iperf_dir
./configure --build=arm
make
make install
iperf --help
if [ $? -ne 1 ];then
	echo "install iperf fail"
else
	echo "install iperf success"
fi
fi


