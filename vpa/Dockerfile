FROM alpine:3.14

RUN apk update \
    && apk add git \
    && apk add bash \
    && apk add openssl \
    && apk add jq \
    && apk add curl \
    && apk add wget

ARG VPA_GITHUB_LINK_BRANCH="master"

ARG VPA_GITHUB_LINK="https://github.com/kubernetes/autoscaler.git"

ENV VPA_GITHUB_LINK_BRANCH=${VPA_GITHUB_LINK_BRANCH}

RUN mkdir /opt/vpa

WORKDIR /opt/vpa

RUN git clone -b ${VPA_GITHUB_LINK_BRANCH} ${VPA_GITHUB_LINK}

RUN mkdir ~/.kube

VOLUME ~/.kube

COPY ./script.sh /opt/

ENTRYPOINT ["/bin/sh","/opt/init.sh"]