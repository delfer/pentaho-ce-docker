#Based on Tomcat images
FROM tomcat:8

#To generate charts, the Pentaho Reporting engine requires functions found in X11
RUN	apt-get update \
	&& apt-get install -y xvfb \
	&& apt-get clean all \
	&& rm -rf /var/lib/apt/lists/*

#getting Pentaho distrib
ADD https://downloads.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/7.1/pentaho-server-ce-7.1.0.0-12.zip /usr/local/tomcat/
#ADD pentaho-server-ce-7.1.0.0-12.zip /usr/local/tomcat/

#unpack and install
RUN	unzip pentaho-server-ce-7.1.0.0-12.zip  \
	&& rm -rf /usr/local/tomcat/webapps \
	&& mv pentaho-server/tomcat/webapps /usr/local/tomcat/webapps \
	&& mv -n pentaho-server/tomcat/lib/* /usr/local/tomcat/lib/ \
	&& mv  pentaho-server/data /usr/ \
	&& mv pentaho-server/pentaho-solutions /usr/local/ \
	&& rm -rf pentaho-server \
	&& rm -f pentaho-server-ce-7.1.0.0-12.zip

#configure
ENV 	DI_HOME=/usr/local/pentaho-solutions/system/kettle \
	PENTAHO_JAVA_HOME="$JAVA_HOME"
ENV	CATALINA_OPTS="-Djava.awt.headless=true -Xms2048m -Xmx6144m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dfile.encoding=utf8 -DDI_HOME=$DI_HOME"

EXPOSE 8080
