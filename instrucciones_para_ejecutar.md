Vamos a generar la imagen:

//darwinapache va sewr el nombre de la imagen y conetendor apache2
// > :es tag la versionn
// . espacio y punto es importante para crear la imagen
~/apache$ docker build -t 11642590/myapache2:1.0.0 .

// para correr la imagen
**Vemos la Images
docker images 

 podemos crear un nuevo contenedor a partir de la nueva imagen:

$ docker run -p 3000:80 --name servidor_web darwinapache/apache2:1.0.1

Comprobamos que el contenedor está creado:

$ docker ps -a

$ docker ps -l

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
67013f91ba65        darwinapache/apache    "/usr/sbin/apache2ctl"   4 minutes ago       Up 4 minutes        0.0.0.0:80->80/tcp   servidor_web

Ejemplos de ficheros Dockerfile, creando imágenes docker
 6 minute read
En la entrada: Dockerfile: Creación de imágenes docker, estudiamos el mecanismo de creación de imágenes docker, con el comando docker buid y los ficheros Dockerfile. En esta entrada vamos a estudiar algunos ejemplos de ficheros Dockerfile y cómo creamos y usamos las imágenes generadas a partir de ellos.

Tenemos dos imágenes en nuestro sistema, que son las que vamos a utilizar como imágenes base para crear nuestras imágenes:

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
debian              latest              9a02f494bef8        2 weeks ago         125.1 MB
ubuntu              14.04               3876b81b5a81        3 weeks ago         187.9 MB
Creación una imagen con el servidor web Apache2Permalink
En este caso vamos a crear un directorio nuevo que va a ser el contexto donde podemos guardar los ficheros que se van a enviar al docker engine, en este caso el fichero index.html que vamos a copiar a nuestro servidor web:

$ mkdir apache
$ cd apache
~/apache$ echo "<h1>Prueba de funcionamiento contenedor docker</h1>">index.html
En ese directorio vamos a crear un fichero Dockerfile, con el siguiente contenido:

FROM debian
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
ADD ["index.html","/var/www/html/"]

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
En este caso utilizamos la imagen base de debian, instalamos el servidor web apache2, para reducir el tamaño, borramos la caché de paquetes apt y la lista de paquetes descargada, creamos varias variables de entorno (en este ejemplo no se van a utilizar, pero se podrían utilizar en cualquier fichero del contexto, por ejemplo para configurar el servidor web), exponemos el puerto http TCP/80, copiamos el fichero index.html al DocumentRoot y finalmente indicamos el comando que se va a ejecutar al crear el contenedor, y además, al usar el comando ENTRYPOINT, no permitimos ejecutar ningún otro comando durante la creación.

Vamos a generar la imagen:

~/apache$ docker build -t josedom24/apache2:1.0 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM debian
 ---> 9a02f494bef8
Step 2 : MAINTAINER José Domingo Muñoz "josedom24@gmail.com"
 ---> Running in 76f3f8fe0719
 ---> fda7bdbf761c
Removing intermediate container 76f3f8fe0719
Step 3 : RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
 ---> Running in c50b14cc967d
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [256 kB]
Ign http://httpredir.debian.org jessie InRelease
...
 ---> 0dedcfe17eb9
Removing intermediate container c50b14cc967d
Step 4 : ENV APACHE_RUN_USER www-data
 ---> Running in 85a85c09f96c
 ---> dac18d113b15
Removing intermediate container 85a85c09f96c
Step 5 : ENV APACHE_RUN_GROUP www-data
 ---> Running in 9e7511d92c74
 ---> 8f5824bdc71a
Removing intermediate container 9e7511d92c74
Step 6 : ENV APACHE_LOG_DIR /var/log/apache2
 ---> Running in 1b9173a822f8
 ---> 313e04f3a33a
Removing intermediate container 1b9173a822f8
Step 7 : EXPOSE 80
 ---> Running in 001ce73f08a6
 ---> 76f798e8d481
Removing intermediate container 001ce73f08a6
Step 8 : ADD index.html /var/www/html
 ---> 5ce11ae0b1e6
Removing intermediate container c8f418d3a0f6
Step 9 : ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
 ---> Running in 4ba6954632a5
 ---> 9109b0f27a08
Removing intermediate container 4ba6954632a5
Successfully built 9109b0f27a08
Generamos la nueva imagen con el comando docker build con la opción -t indicamos el nombre de la nueva imagen (para indicar el nombre de la imagen es recomendable usar nuestro nombre de usuario en el registro docker hub, para posteriormente poder guardarlas en el registro), mandamos todos los ficheros del contexto (indicado con el punto). Podemos comprobar que tenemos generado la nueva imagen:

$ docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
josedom24/apache2   1.0                 9109b0f27a08        4 minutes ago       183.7 MB
debian              latest              9a02f494bef8        2 weeks ago         125.1 MB
ubuntu              14.04               3876b81b5a81        3 weeks ago         187.9 MB
A continuación podemos crear un nuevo contenedor a partir de la nueva imagen:

$ docker run -p 3000:80 --name servidor_web darwinapache/apache2:1.0

#3000 es puesto del pc local
#80 es puesrto del contenedor
Comprobamos que el contenedor está creado:

 docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS         PORTS                                   NAMES
5dea41e98454   darwinapache/apache2:1.0   "/usr/sbin/apache2ct…"   2 minutes ago   Up 2 minutes   0.0.0.0:3000->80/tcp, :::3000->80/tcp   servidor_web

Y podemos acceder al servidor docker, para ver la página web:

http://127.0.0.1:3000/

