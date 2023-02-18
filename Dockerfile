FROM nginx:1.23.3-alpine-slim

ENV USER docker
ENV GROUP docker
ENV ALPINE_VERSION 3.6
ENV ALPINE_ARCH x86_64
ENV APK_ROOT /apk
ENV APK_HOME ${APK_ROOT}/v${ALPINE_VERSION}/main/${ALPINE_ARCH}

COPY files/entrypoint.sh /bin/entrypoint.sh
COPY files/apk-index.sh /bin/apk-index
COPY files/nginx.conf.erb /etc/nginx/nginx.conf.erb

RUN apk add gcc abuild sudo ruby util-linux ca-certificates --no-cache \ 
 && mkdir -p ${APK_HOME} \
 && mkdir -p /certs \
 && chmod +x /bin/entrypoint.sh \
 && addgroup -S ${GROUP} \
 && adduser -S ${USER} -G $GROUP \
 && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel \
 && adduser ${USER} wheel \
 && mkdir -p /var/run \
 && chown -R ${USER}:${GROUP} /usr/sbin/nginx \
 && chown -R ${USER}:${GROUP} /certs \
 && chown -R ${USER}:${GROUP} /etc/nginx* \
 && chown -R ${USER}:${GROUP} /etc/logrotate.d/nginx \
 && chown -R ${USER}:${GROUP} /etc/init.d/nginx \
 && chown -R ${USER}:${GROUP} /var/cache/nginx/ \
 && chown -R ${USER}:${GROUP} ${APK_ROOT} \
 && chown ${USER}:${GROUP} /docker-entrypoint.sh \
 && chown ${USER}:${GROUP} /bin/entrypoint.sh \
 && chown ${USER}:${GROUP} /bin/apk-index \
 && chmod +x /bin/apk-index \
 && chown -R ${USER}:${GROUP} /docker-entrypoint.d \
 && rm -f /var/run/nginx.pid \
 && rm -f /run/nginx.pid \
 && chown -R ${USER}:${GROUP} /var/run \
 && chown -R ${USER}:${GROUP} /run \
 && chown -R ${USER}:${GROUP} /var/log/nginx

 RUN apk --version

 EXPOSE 8443
 EXPOSE 8080

USER $USER

ENTRYPOINT /bin/entrypoint.sh
