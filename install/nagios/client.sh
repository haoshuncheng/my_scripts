#!/bin/sh
source ../header.sh
plugin_version=2.2.1
nrpe_version=3.1.0


dependencies() {
        yum install perl-devel perl-CPAN -y
        yum install openssl-devel -y
        yum gcc -y
}

download() {
  plugin_tgz=nagios-plugins-$plugin_version.tar.gz
        if [ ! -f $download/$plugin_tgz ];
        then
                wget https://www.nagios-plugins.org/download/$plugin_tgz
                tar zxvf $plugin_tgz 
        fi

  nrpe_tgz=nrpe-$nrpe_version.tar.gz
    if [ ! -f $download/$nrpe_tgz ];
        then
                wget https://sourceforge.net/projects/nagios/files/nrpe-3.x/$nrpe_tgz
                tar zxvf $nrpe_tgz
        fi
}

install() {
        #plugin
        cd $download/nagios-plugins-$plugin_version
  ./configure --with-nagios-user=nagios --with-nagios-group=nagios --enable-perl-modules --prefix=${prefix}
        make;make install
  chown nagios.nagios ${prefix}/nagios
        chown -R nagios.nagios ${prefix}/nagios/libexec

        #nrpe
        cd $download/nrpe-$nrpe_version
        ./configure
        make all
        make install-plugin
        make install-daemon
        make install-daemon-config
}

usergroup() {
        useradd nagios -M -s /sbin/nologin
        #passwd nagios
}

config() {
        mkdir ${prefix}/nagios/etc/
                cp $root/config_file/nrpe.cfg ${prefix}/nagios/etc/nrpe.cfg
                ${prefix}/nagios/bin/nrpe -d -c ${prefix}/nagios/etc/nrpe.cfg 
                echo "${prefix}/nagios/bin/nrpe -d -c ${prefix}/nagios/etc/nrpe.cfg" >> /etc/rc.local
                chmod +x /etc/rc.d/rc.local 
                ${prefix}/nagios/libexec/check_nrpe -H localhost
                cp $root/config_file/check_mem.pl ${prefix}/nagios/libexec/check_mem.pl
                chmod 755 ${prefix}/nagios/libexec/check_mem.pl
}




main $1