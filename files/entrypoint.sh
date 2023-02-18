#!/bin/sh

export PUBLIC_KEY=/certs/repo.rsa.public.key
if [[ -f $PUBLIC_KEY && ! -r $PUBLIC_KEY ]]; then
    echo "copying $PUBLIC_KEY to $APK_ROOT/repo.rsa.public.key because it is not readable by $USER user" 
    sudo cp $PUBLIC_KEY $APK_ROOT/repo.rsa.public.key
    sudo chown ${USER}:${GROUP} $APK_ROOT/repo.rsa.public.key
    export PUBLIC_KEY=$APK_ROOT/repo.rsa.public.key
fi

if  [[ -f $SSL_CERTIFICATE && ! -r "$SSL_CERTIFICATE" ]] ; then
    echo "copying $SSL_CERTIFICATE to /tmp/server.cert because it is not readable by $USER user"
    sudo cp $SSL_CERTIFICATE /tmp/server.cert
    sudo chown ${USER}:${GROUP} /tmp/server.cert
    export SSL_CERTIFICATE=/tmp/server.cert
fi

if  [[ -f $SSL_CERTIFICATE_KEY && ! -r "$SSL_CERTIFICATE_KEY" ]] ; then
    echo "copying $SSL_CERTIFICATE_KEY to /tmp/server.key because it is not readable by $USER user"
    sudo cp $SSL_CERTIFICATE_KEY /tmp/server.key
    sudo chown ${USER}:${GROUP} /tmp/server.key
    export SSL_CERTIFICATE_KEY=/tmp/server.key
fi

rm -f /etc/nginx/nginx.conf
ruby /etc/nginx/nginx.conf.erb > /etc/nginx/nginx.conf 

exec /docker-entrypoint.sh "nginx" "-g" "daemon off;"