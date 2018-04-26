# Sphinx Search
#
# @version 	2.2.9
# Heavily customized from https://github.com/leodido/dockerfiles
FROM tianon/centos:latest

MAINTAINER Tomas Jacik <tomas.jacik@sunfox.cz>

# add public key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
# install utils
RUN yum install wget tar -y -q
# install sphinxsearch build dependencies
RUN yum install autoconf automake libtool gcc-c++ -y -q
# install sphinxsearch dependencies for mysql support
RUN yum install mysql-devel -y -q
# download sphinxsearch source and extract it
RUN wget -nv -O - http://sphinxsearch.com/files/sphinx-2.2.9-release.tar.gz | tar zx
# compile and install sphinxsearch
RUN cd sphinx-2.2.9-release && ./configure --enable-id64 --with-mysql --with-iconv
RUN cd sphinx-2.2.9-release && make
RUN cd sphinx-2.2.9-release && make install
# remove sources
RUN rm -rf sphinx-2.2.9-release/

# expose ports
EXPOSE 9312 9306

# prepare directories
RUN mkdir -p /var/idx/sphinx && \
    mkdir -p /var/log/sphinx && \
    mkdir -p /var/lib/sphinx && \
    mkdir -p /var/run/sphinx

# Expose some folders for configurations
VOLUME ["/var/idx/sphinx", "/var/log/sphinx", "/var/lib/sphinx", "/var/run/sphinx"]

# scripts
ADD searchd.sh /
RUN chmod a+x searchd.sh
ADD indexall.sh /
RUN chmod a+x indexall.sh

# run the script
CMD ["./indexall.sh"]
