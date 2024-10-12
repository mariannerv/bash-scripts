FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    lsb-release \
    zip \
    cron \
    postgresql-client-13  # Adjust the PostgreSQL client version if needed

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && apt-get install -y postgresql-client

COPY script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

ENV DB_HOST=""
ENV DB_PORT="5432"
ENV DB_USER=""
ENV DB_PASSWORD=""
ENV DB_NAME=""
ENV RETENTION_DAYS="7"

RUN (crontab -l ; echo "0 3 * * * /usr/local/bin/script.sh $DB_HOST $DB_PORT $DB_USER $DB_PASSWORD $DB_NAME $RETENTION_DAYS") | crontab - && \
    (crontab -l ; echo "0 14 * * * /usr/local/bin/script.sh $DB_HOST $DB_PORT $DB_USER $DB_PASSWORD $DB_NAME $RETENTION_DAYS") | crontab -


CMD ["cron", "-f"]
