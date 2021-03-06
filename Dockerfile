FROM docker:20.10.5
#FROM alpine:3.13.2
RUN apk update
RUN apk add --no-cache \
        python3==3.8.8-r0 \
        py3-pip==20.3.4-r0 \
    && pip3 install --upgrade pip==21.0.1 \
    && pip3 install \
        awscli==1.18.25 \
    && pip3 install \
        boto3==1.12.25 \
    && rm -rf /var/cache/apk/*

#Install additional packages
RUN apk add bash==5.1.0-r0 git==2.30.2-r0 grep==3.6-r0 zip==3.0-r9 curl==7.74.0-r1  jq=1.6-r1 bc==1.07.1-r1 ncurses==6.2_p20210109-r0


RUN aws --version
#Symbolic link forpython
RUN ln -s /usr/bin/python3 /usr/bin/python

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
                echo '#!/bin/sh'; \
                echo 'set -e'; \
                echo; \
                echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
        } > /usr/local/bin/docker-java-home \
        && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u131
ENV JAVA_ALPINE_VERSION 8.275.01-r0

RUN set -x \
        && apk add --no-cache \
                openjdk8="$JAVA_ALPINE_VERSION" \
        && [ "$JAVA_HOME" = "$(docker-java-home)" ]

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

#Install Node and npm
ENV NODE_VERSION=v14.15.0
ENV CHECKSUM="452b407a2d85b2eeaa58a5b99fb864cb9f9d3f3602f1610b7ea4c7e9007e2ce3"

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++

RUN curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz"; \
    echo "$CHECKSUM  node-$NODE_VERSION-linux-x64-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-$NODE_VERSION-linux-x64-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs;

# Install terraform
ENV TERRAFORM_VERSION 0.12.23

RUN apk --update --no-cache add libc6-compat openssh-client

RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
