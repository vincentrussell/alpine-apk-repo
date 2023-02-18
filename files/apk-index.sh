#!/bin/sh

set -x

VERSION=3.6
ARCH=x86_64

while getopts "v:a:" arg; do
  case $arg in
    v)
      VERSION=$OPTARG
      ;;
    a)
      ARCH=$OPTARG
      ;;      
  esac
done

mkdir -p $APK_ROOT/v$VERSION/main/$ARCH
sudo chown -R ${USER}:${GROUP} $APK_ROOT/v$VERSION/main/$ARCH
cd $APK_ROOT/v$VERSION/main/$ARCH
sudo rm -f APKINDEX.tar.gz
sudo apk index -vU -o APKINDEX.tar.gz *.apk
sudo chown -R ${USER}:${GROUP} .

if [[ ! -f /certs/repo.rsa.private.key ]]; then
    echo "generating certs...."
    abuild-keygen -n
    ls -alh /home/$USER/.abuild/
    mv /home/$USER/.abuild/*.rsa /certs/repo.rsa.private.key
    mv /home/$USER/.abuild/*.pub $APK_ROOT
fi

if [[ -f $APK_ROOT/v$VERSION/main/$ARCH/APKINDEX.tar.gz ]]; then
    sudo abuild-sign -k /certs/repo.rsa.private.key $APK_ROOT/v$VERSION/main/$ARCH/APKINDEX.tar.gz
    sudo chown ${USER}:${GROUP} $APK_ROOT/v$VERSION/main/$ARCH/APKINDEX.tar.gz
fi

