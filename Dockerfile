FROM ubuntu

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    apt-get update && \
    apt-get install -y cron python3-pip jq && \
    pip3 install awscli && \
    rm -rf /var/lib/apt/lists/*

COPY crontab /etc/cron.d/pg_restore
COPY run.sh /run.sh
RUN chmod 0644 /etc/cron.d/pg_restore && touch /var/log/cron.log && chmod +x /run.sh

USER root:root
CMD env > /.env && cron && tail -f /var/log/cron.log
