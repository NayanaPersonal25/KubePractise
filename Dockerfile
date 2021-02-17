#Maven
FROM openjdk:8-jdk

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]


#Gradle
ADD file ... in /

/bin/sh -c set -xe &&

/bin/sh -c [ -z "$(apt-get

/bin/sh -c mkdir -p /run/systemd

CMD ["/bin/bash"]

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

/bin/sh -c apt-get update

ENV JAVA_VERSION=jdk8u282-b08

/bin/sh -c set -eux;

ENV JAVA_HOME=/opt/java/openjdk PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["gradle"]

ENV GRADLE_HOME=/opt/gradle

/bin/sh -c set -o errexit

VOLUME [/home/gradle/.gradle]

WORKDIR /home/gradle

/bin/sh -c apt-get update

ENV GRADLE_VERSION=6.8.2

ARG GRADLE_DOWNLOAD_SHA256=8de6efc274ab52332a9c820366dd5cf5fc9d35ec7078fd70c8ec6913431ee610

|1 GRADLE_DOWNLOAD_SHA256=8de6efc274ab52332a9c820366dd5cf5fc9d35ec7078fd70c8ec6913431ee610 /bin/sh -c set

