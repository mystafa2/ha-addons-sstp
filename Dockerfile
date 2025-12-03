FROM alpine:3.19

RUN apk add --no-cache sstp-client jq ca-certificates bash

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
