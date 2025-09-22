FROM debian:bookworm-slim
LABEL Maintainer="Yavuzlar Web Security Team <cyberyavuzlar@gmail.com>"
LABEL Description="Web Vulnerability Lab by Yavuzlar." \
    License="Mozilla Public License Version 2.0" \
    Usage="docker run -d -p 1337:80 yavuzlar/vulnlab" \
    Version="1.0"


ENV TZ=UTC \
    LOG_STDOUT=**Boolean** \
    LOG_STDERR=**Boolean** \
    LOG_LEVEL=warn \
    ALLOW_OVERRIDE=All \
    DATE_TIMEZONE=UTC \
    TERM=dumb


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata \
    zip \
    unzip \
    apache2 \
    libapache2-mod-php \
    php \
    php-cgi \
    php-cli \
    php-common \
    php-gd \
    php-curl \
    php-dev \
    php-json \
    php-mbstring \
    php-mysql \
    php-odbc \
    php-phpdbg \
    php-sqlite3 \
    mariadb-server \
    mariadb-client \
    dos2unix \
    netcat-traditional \
    iputils-ping \
    wget \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Timezone ayarını RUN komutu içinde yapın.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN rm -f /var/www/html/index.html

COPY ./app/ /var/www/html

COPY run.sh /usr/sbin/

RUN a2enmod rewrite && \
    dos2unix /usr/sbin/run.sh && \
    chmod +x /usr/sbin/run.sh && \
    chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["/usr/sbin/run.sh"]
