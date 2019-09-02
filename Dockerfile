FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y wget vim

RUN apt-get install -y openjdk-8-jdk

WORKDIR /opt
RUN wget ftp://ftp.kddilabs.jp/infosystems/apache/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
RUN tar xzf spark-2.4.3-bin-hadoop2.7.tgz
RUN ln -s /opt/spark-2.4.3-bin-hadoop2.7 /opt/spark
RUN echo "export PATH=${PATH}:/opt/spark/bin" >> /root/.bashrc

RUN apt-get install -y gnupg
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get install -y sbt

RUN mkdir /var/tmp/sbt
WORKDIR /var/tmp/sbt
RUN sbt package

WORKDIR /root
EXPOSE 8080

CMD ["su", "-c", "bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
