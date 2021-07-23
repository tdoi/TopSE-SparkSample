FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y wget vim

RUN apt-get install -y openjdk-8-jdk

ARG SPARK_VERSION=3.1.2
ARG HADOOP_VERSION=3.2

WORKDIR /opt
RUN wget -q http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark
RUN echo "export PATH=${PATH}:/opt/spark/bin" >> /root/.bashrc

RUN apt-get install -y gnupg curl
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update
RUN apt-get -y install sbt

RUN mkdir /var/tmp/sbt
WORKDIR /var/tmp/sbt
RUN sbt package

WORKDIR /root
EXPOSE 8080

CMD ["su", "-c", "bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
