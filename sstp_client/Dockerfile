FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sstp-client \
        ppp \
        iproute2 \
        iputils-ping \
        ca-certificates \
        jq \
        bash && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/bin/bash", "/run.sh"]
