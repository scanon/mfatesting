FROM centos:7

MAINTAINER Shane Canon <scanon@lbl.gov>

# Update and install various packages
RUN \
  echo "%_netsharedpath /sys:/proc" >> /etc/rpm/macros.dist && \
  yum -y update && \
  yum install -y wget nss-pam-ldapd openldap openssh openssh-server \
      openssh-ldap openssh-server-sysvinit \
      autoconf pam-devel make gcc-c++ git automake libtool

# Install Google Authenticator
RUN \
   wget https://github.com/google/google-authenticator-libpam/archive/1.03.tar.gz && \
   tar xzf 1.03.tar.gz  && cd google-authenticator-libpam-1.03  && \
   sh ./bootstrap.sh && ./configure  && make && make install && \
   cp /usr/local/lib/security/pam_google_authenticator.so /lib64/security/

# Add LDAP  configs
ADD ldap /tmp/ldap/
RUN \
  cp /tmp/ldap/ldap.conf /etc/openldap/ldap.conf && \
  cp /tmp/ldap/nslcd.conf /etc/nslcd.conf && \
  cp /tmp/ldap/nsswitch.conf /etc/nsswitch.conf && \
  cp /tmp/ldap/pam_ldap.conf /etc/pam_ldap.conf && \
  cp /tmp/ldap/password-auth /etc/pam.d/password-auth

# Add google authenticator configs and set a clustername
ADD ./ga /src
RUN \
    echo dtn > /etc/clustername && \
    cp /src/pam_sshd /etc/pam.d/sshd && \
    cp /src/sshd_config /etc/ssh/sshd_config

ADD ./entrypoint.sh /entrypoint.sh

#ADD pam_sshd  /etc/pam.d/sshd
#
#ADD sshd_config /etc/ssh/sshd_config

EXPOSE 22
CMD [ ]
ENTRYPOINT [ "/entrypoint.sh" ]
