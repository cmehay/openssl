FROM    debian:jessie

# Key name
ENV     KEY_NAME cert

# Common name
ENV     COMMON_NAME localhost

# Key lifetime
ENV     LIFETIME 365

# Is key to pem format?
ENV     PEM true

# Is pem key should be displayed to stdout?
ENV     DISPLAY true


RUN     apt-get update && apt-get -y install openssl
RUN     mkdir /certs
CMD     /usr/bin/openssl genrsa -out /certs/${KEY_NAME}.key 1024 && \
        /usr/bin/openssl req -new -newkey rsa:4096 -days ${LIFETIME} -nodes -subj "/C=/ST=/L=/O=/CN=${COMMON_NAME}" -keyout /certs/${KEY_NAME}.key -out /certs/${KEY_NAME}.csr  && \
        /usr/bin/openssl x509 -req -days ${LIFETIME} -in /certs/${KEY_NAME}.csr -signkey /certs/${KEY_NAME}.key -out /certs/${KEY_NAME}.crt && \
        test ${PEM} = true && cat /certs/${KEY_NAME}.key /certs/${KEY_NAME}.crt > /certs/${KEY_NAME}.pem && \
        test ${DISPLAY} = true && awk 1 ORS='\\n' /certs/${KEY_NAME}.pem
