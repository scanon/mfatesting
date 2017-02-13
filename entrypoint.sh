#!/bin/sh

if [ $# -gt 0 ] ;then
  /usr/local/bin/google-authenticator -t -d -f -r 3 -R 30 -w 3 -l "$1"
  echo "Place the below in .google_authenticator in your NERSC Home Directory"
  echo "=========================="
  cat /root/.google_authenticator
  echo "=========================="
  exit
fi

if [ -d /config ] ; then
   echo "Copying configs"
   cp /config/* /etc/ssh/
fi

nslcd
sshd-keygen
/usr/sbin/sshd -D
