FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh \ 
    && sh /tmp/netdata-kickstart.sh --non-interactive --dont-start-it \
    && rm /tmp/netdata-kickstart.sh

EXPOSE 19999

CMD ["/usr/sbin/netdata", "-D"]
