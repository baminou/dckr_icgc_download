FROM ubuntu:16.04

MAINTAINER Name <brice.aminou@gmail.com>

RUN apt-get update && apt-get install -y git && apt-get install -y wget

RUN apt-get update --fix-missing

RUN apt-get install -y python-pip

RUN apt-get update && apt-get install -y software-properties-common && apt-get install -y python-software-properties
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN mkdir /icgc-storage-client
RUN wget -O icgc-storage-client.tar.gz https://artifacts.oicr.on.ca/artifactory/dcc-release/org/icgc/dcc/icgc-storage-client/1.0.23/icgc-storage-client-1.0.23-dist.tar.gz
RUN tar -zxvf icgc-storage-client.tar.gz -C /icgc-storage-client --strip-components=1

RUN git clone https://github.com/icgc-dcc/icgconnect.git /icgconnect
RUN cd icgconnect
RUN pip install /icgconnect
RUN pip install jsonschema

#RUN touch /icgc-storage-client/conf/application-aws.properties
RUN echo "accessToken=\$ACCESSTOKEN" > /icgc-storage-client/conf/application-aws.properties
RUN echo "storage.url=\${STORAGEURL}" >> /icgc-storage-client/conf/application-aws.properties
RUN echo "metadata.url=\${METADATAURL}" >> /icgc-storage-client/conf/application-aws.properties
RUN echo "logging.file=./storage-client.log" >> /icgc-storage-client/conf/application-aws.properties

RUN echo "accessToken=\$ACCESSTOKEN" > /icgc-storage-client/conf/application.properties
RUN echo "storage.url=\${STORAGEURL}" >> /icgc-storage-client/conf/application.properties
RUN echo "metadata.url=\${METADATAURL}" >> /icgc-storage-client/conf/application.properties
RUN echo "logging.file=./storage-client.log" >> /icgc-storage-client/conf/application.properties

RUN mkdir /scripts
COPY tools/download_icgc_file.py /scripts/download

RUN chmod +x /scripts/download

ENV PATH="/scripts/:${PATH}"
ENV PATH="/icgc-storage-client/bin:${PATH}"

#ENTRYPOINT ["download"]
