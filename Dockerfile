FROM alpine:3.13.2
RUN apk update
RUN apk add --no-cache \
        python3==3.8.7-r1 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli==1.18.25 \
    && pip3 install \
        boto3==1.12.25 \
    && rm -rf /var/cache/apk/*

#Install additional packages
RUN apk add bash ncurses git zip curl==7.74.0-r0 jq=1.6-r1 bc==1.07.1-r1

RUN aws --version
#Symbolic link forpython
RUN ln -s /usr/bin/python3 /usr/bin/python

#Install jdk-jre 8
RUN apk --update add openjdk8-jre
#Set Java environment
#ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:${JAVA_HOME}/jre/bin:${JAVA_HOME}/bin
#ENV PATH ${PATH}:${JAVA_HOME}/bin
RUN java -version

#install Maven
ENV MAVEN_VERSION 3.6.3
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH ${PATH}:$MAVEN_HOME/bin

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN mvn -version

#install Gradle
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions

ENV GRADLE_VERSION 6.8.2
ENV GRADLE_HOME /usr/lib/gradle
ENV GRADLE_USER_HOME /cache
ENV PATH $PATH:$GRADLE_HOME/bin

RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  && unzip -d /usr/share/gradle /tmp/gradle.zip \
  && rm -f /tmp/gradle.zip \
  && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/lib/gradle

VOLUME $GRADLE_USER_HOME

RUN gradle -version
