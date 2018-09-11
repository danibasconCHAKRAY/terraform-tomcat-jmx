# terraform ssh

Este repositorio nos creará una instancia en aws en la cual vamos a desplegar un tomcat mediante ansible. Los pasos a seguir serían:

1. Lanzar el terraform:
	- terraform apply -> yes.

2. Obtener las siguientes variables de nuestra instancia de aws:
	- ip publica.
	- hostname.

3. Editar el fichero hosts.ini que encontramos en el ansible y sustituirlo:
	- donde ponga ip-xxxxxxxx: añadir el hostname
	- y en la parte de ssh: añadir la ip publica
	- por ultimo e muy iportante deberemos añadir nuestra ruta de nuestro fichero .pem.
	- además la ruta del binero de python, en mi caso python3 por utilizar ubuntu.
	- una ultima cosa, tener cuidado con los usuarios, si utilizamos por ejemplo centos, el usuario será otro.

4. Lanzamos nuestro ansible ya editado:
	- ansible-playbook -i hosts.ini playbook.yml

5. Una vez finalizado estas tareas, seguir este manual para desplegarlo, yo de todas formas lo explicare:
	- http://rm-rf.es/como-conectar-forma-remota-jconsole-jmx-tomcat/

6. Una vez desplegado todo, nos conectamos a la instancia de aws y realizamos uno cambios antes de conectarnos con el usuario tomcat:
	- editamos el fichero /etc/passwd : en la ultima linea, el usuario tomcat pone false en su shell, cambiar solo el false por bash, y ya nos dejará loguearnos.

7. Accedemos con el usuario tomcat o como root (recomiendo root), y realizamos lo siguiente:
	- accedemos a la sigueinte ruta, que es donde crearemos el ejecutable:
		- /opt/tomcat/apache-tomcat-8.5.32/bin
	- creamos el ejecutable setenv.sh y dentro de el añadimos lo siguiente:
	'''
	CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote \
	-Dcom.sun.management.jmxremote.port=11111 \
	-Dcom.sun.management.jmxremote.authenticate=false \
	-Dcom.sun.management.jmxremote.ssl=false"
	'''
	- las ''' no añadirlas

8. Reinicamos el servicio de tomcat:
	- systemctl restart tomcat

9. Ahora deberemos de abrir una serie de puertos en nuestro equipo para poder conectarnos a travez de tuneles a nuestra instancia de aws:
	-  ssh -D 9999 ubuntu@ip_aws
	-  ssh -L 11111:localhost:11111 ubuntu@ip_aws 

10. Por ultimo nos conectamos con jconsole desde nuestro equipo:
	- jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=9999  service:jmx:rmi:///jndi/rmi://localhost:11111/jmxrmi 



Si alguno de los pasos no funciona seguir el manual que he pasado, es muy bueno
Tambien podeis ver si los puertos se van abriendo:
- netstat -nat | grep LISTEN | grep 11111
