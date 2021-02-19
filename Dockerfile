FROM alpine:3.13.2
RUN apk update
RUN apk add --no-cache \
        python3==3.8.7-r1 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli==1.18.5 \
    && rm -rf /var/cache/apk/*

RUN aws --version
RUN ln -s /usr/bin/python3 /usr/bin/python
