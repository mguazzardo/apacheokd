FROM fedora:31

MAINTAINER Carlos Alberto
LABEL version="0.1"

RUN dnf -y update && dnf -y install httpd && dnf -y clean all

RUN [ -d /var/log/httpd ] || mkdir /var/log/httpd
RUN [ -d /var/run/httpd ] || mkdir /var/run/httpd
RUN [ -d /var/lock/httpd ] || mkdir /var/lock/httpd

RUN sed -i.orig 's/#ServerName/ServerName/' /etc/httpd/conf/httpd.conf

RUN sed -i.orig 's/Listen 80/Listen 8080/'  /etc/httpd/conf/httpd.conf
RUN sed -i.orig 's/ServerName www.example.com:80/ServerName www.example.com:8080/'  /etc/httpd/conf/httpd.conf
RUN chown -R apache:apache /var/log/httpd/ && \
    chown -R apache:apache /var/run/httpd && \
    chown -R apache:apache /var/lock/httpd



ENV APACHE_RUN_USER apache
ENV APACHE_RUN_GROUP apache
ENV APACHE_LOG_DIR /var/log/httpd
ENV APACHE_LOCK_DIR /var/lock/httpd
ENV APACHE_RUN_DIR /var/run/httpd
ENV APACHE_PID_FILE /var/run/httpd/httpd.pid

EXPOSE 8080


USER apache

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
