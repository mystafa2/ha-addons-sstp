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

# Копіюємо run.sh з цієї ж папки аддона
COPY run.sh /run.sh

# Робимо його виконуваним
RUN chmod +x /run.sh

# Команда за замовчуванням
CMD ["/run.sh"]
