#!/bin/sh
root=$PWD
download=~/Downloads
prefix=/usr/local/cellar
sysctl_dir=/usr/lib/systemd/system/


main() {
	if [ ! -d $download ]; then
	  mkdir $download
	fi
	cd $download
	if [ x$1 = "xinstall" ]; then
	  dependencies
	  download
	  usergroup
	  install
	  config
	else
	  echo "invalid option.quit."
	fi
}	

