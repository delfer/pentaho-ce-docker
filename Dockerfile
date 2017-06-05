#Based on Tomcat images
FROM tomcat:8

#To generate charts, the Pentaho Reporting engine requires functions found in X11
RUN	apt-get update \
	&& apt-get install -y xvfb \
	&& apt-get clean all \
	&& rm -rf /var/lib/apt/lists/*

ENV	PENTAHO_VERSION=7.1 \
	PENTAHO_ARCHIVE=pentaho-server-ce-7.1.0.0-12.zip

#getting Pentaho distrib
ADD https://downloads.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/$PENTAHO_VERSION/$PENTAHO_ARCHIVE $CATALINA_HOME
#ADD $PENTAHO_ARCHIVE $CATALINA_HOME

#unpack and install
RUN	unzip $PENTAHO_ARCHIVE  \
	&& rm -rf webapps \
	&& mv pentaho-server/tomcat/webapps webapps \
	&& mv -n pentaho-server/tomcat/lib/* lib/ \
	&& mv pentaho-server/data /usr/data \
	&& mv pentaho-server/pentaho-solutions /usr/local/ \
	&& rm -rf pentaho-server \
	&& rm -f $PENTAHO_ARCHIVE

#Prepare persistent mount point
RUN	mkdir -p /volume/repository \
	&& cp -rp /usr/data/hsqldb /volume/ \
	&& rm -rf /usr/data/hsqldb \
	&& ln -s /volume/repository /usr/local/pentaho-solutions/system/jackrabbit/repository \
	&& ln -s /volume/hsqldb /usr/data/hsqldb 
	

#configure
ENV 	DI_HOME=/usr/local/pentaho-solutions/system/kettle \
	PENTAHO_JAVA_HOME="$JAVA_HOME"
ENV	CATALINA_OPTS="-Djava.awt.headless=true -Xms2048m -Xmx6144m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dfile.encoding=utf8 -DDI_HOME=$DI_HOME"

VOLUME /volume
EXPOSE 8080

