FROM openjdk:8

#Package Pantaho
ENV FILE_NAME_DOWNLOAD_PENTAHO="pdi-ce-7.0.0.0-25.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpentaho%2Ffiles%2FData%2520Integration%2F7.0%2F&ts=1502382494&use_mirror=ufpr"
ENV PENTAHO_URL="https://downloads.sourceforge.net/project/pentaho/Data%20Integration/7.0/${FILE_NAME_DOWNLOAD_PENTAHO}"
ENV PG_HOME=/opt/pentaho;

# Dependências
RUN apt-get update && apt-get install libwebkitgtk-1.0-0 -y

# PDI Pentaho
RUN cd /tmp && wget ${PENTAHO_URL}
RUN cd /tmp && mv ${FILE_NAME_DOWNLOAD_PENTAHO} pentaho-pdi.zip
RUN cd /tmp && unzip pentaho-pdi.zip
RUN mkdir -p /opt/pentaho/pdi
RUN cd /tmp && mv data-integration /opt/pentaho/pdi/
RUN cd /tmp && rm -rf pentaho-pdi.zip#

# Variável de ambiente
RUN echo "KETTLE_HOME=/opt/pentaho/pdi" >> /etc/environment
RUN export KETTLE_HOME=/opt/pentaho/pdi

# EXECUTE UM TESTE PARA QUE SEJA CRIADO DIRETORIO /opt/pentaho/pdi/.kettle/
#RUN /opt/pentaho/pdi/data-integration/kitchen.sh -listrep
RUN mkdir -p /opt/pentaho/pdi/.kettle/

# CRIE O DIRETORIO
RUN mkdir -p /var/www/pentaho/pdi
RUN mkdir -p /var/www/pentaho/config

# RUN PENTAHO
COPY ./runtime/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

CMD ["/sbin/entrypoint.sh"]