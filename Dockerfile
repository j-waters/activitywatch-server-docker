FROM ubuntu:bionic

ENV UID=8426
ENV GID=8426
ENV VERSION=0.7.1

# Requirements
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y dumb-init curl unzip \
    && groupadd -g ${GID} aw \
    && useradd -g aw -u ${UID} -d /activitywatch -m aw \
    && apt-get autoremove -y \
    && apt-get clean all

USER aw:aw
WORKDIR /activitywatch

# Installation
RUN curl -L -o /tmp/activitywatch.zip https://github.com/ActivityWatch/activitywatch/releases/download/v${VERSION}/activitywatch-v${VERSION}-linux-$(uname -m).zip \
    && unzip /tmp/activitywatch.zip -d / \
    && chmod -x /activitywatch/*.so* \
    && rm /tmp/activitywatch.zip

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["/activitywatch/aw-server"]

EXPOSE 80
