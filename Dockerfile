#FROM debian
FROM 11642590/myapache2:1.0.0
# Comment
RUN echo 'Darwin Uzcategui "darwin.uzcategui1973@gmail.com"'


#RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
#ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
#ADD ["index.html","/var/www/html/"]

# ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]