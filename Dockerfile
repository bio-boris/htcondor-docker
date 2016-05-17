FROM centos:centos7

MAINTAINER Andy Pohl <apohl@morgridge.org>

RUN yum -y install \
         yum-utils \
         wget \
         jyum \
         install \
         sudo \
         which && \
	wget http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor && \
	rpm --import RPM-GPG-KEY-HTCondor && \
	yum-config-manager --add-repo https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo && \
	yum -y install --enablerepo=centosplus condor.x86_64 && \
    echo -e "TRUST_UID_DOMAIN = True\n" >> /etc/condor/condor_config.local && \
    echo -e "ALLOW_WRITE = *\n" >> /etc/condor/condor_config.local && \
    useradd --create-home --password 123456 htandy && \
    usermod -a -G condor htandy && \
    chmod -R g+w /var/{lib,log,lock,run}/condor && \    
	yum clean all

WORKDIR /home/htandy

USER htandy

RUN echo -e "condor_master > /dev/null 2>&1" >> /home/htandy/.bashrc

CMD [ "/bin/bash" ]
