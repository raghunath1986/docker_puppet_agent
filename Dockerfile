FROM centos:latest
MAINTAINER WebEngg Webengg@sherwin.com
######### ENVIRONMENT VARIABLES ##############
ENV container docker
ENV http_proxy=http://proxy.proxysherwin.com:39000/

######### SYSTEMD & SYSTEMCTL ##################

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);
RUN rm -f /lib/systemd/system/multi-user.target.wants/* && rm -f /etc/systemd/system/*.wants/* && rm -f /lib/systemd/system/local-fs.target.wants/* && rm -f /lib/systemd/system/sockets.target.wants/*udev* && rm -f /lib/systemd/system/sockets.target.wants/*initctl* && rm -f /lib/systemd/system/basic.target.wants/* && rm -f /lib/systemd/system/anaconda.target.wants/*
VOLUME [ "/sys/fs/cgroup" ]

############# SUDO , TELNET, WHICH, PUPPET PACKAGES #######################
RUN dnf install -y sudo && dnf install -y telnet && dnf install -y which && dnf install -y http://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm && dnf install -y puppet 

COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf

CMD ["/usr/sbin/init"]
 
#docker run -it --name ppagent --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro --add-host=puppet-agent:172.17.0.3 --add-host=puppet-master:172.17.0.2 -d centos/puppetagent 
