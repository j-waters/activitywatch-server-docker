FROM debian:stretch

ENV VERSION=0.7.1

# Requirements
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y dumb-init curl unzip \    
    && apt-get autoremove -y \
    && apt-get clean all

WORKDIR /activitywatch
ADD aw-server.ini /activitywatch/.config/activitywatch/aw-server/aw-server.ini
# Add aw user so we aren't running as root.
RUN useradd --home-dir /activitywatch --shell /bin/bash aw

# Installation
RUN git clone --recursive https://github.com/ActivityWatch/activitywatch.git /activitywatch \
    && cd /activitywatch \
    && git submodule update --init --recursive \
    && make build

RUN chown -R aw:aw /activitywatch    
USER aw

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["aw-server"]

EXPOSE 6500
