FROM debian:buster

MAINTAINER Fabien Buthod-Garcon <fbuthod-@student.42lyon.fr>

COPY srcs/localhost-conf /tmp/

COPY srcs/nginx.conf /tmp/

COPY srcs/wp-config.php /tmp/

COPY srcs/config.inc.php /tmp/

COPY srcs/service_start.sh /usr/bin/service_start.sh

RUN chmod 755 /usr/bin/service_start.sh

ENTRYPOINT ["service_start.sh"]