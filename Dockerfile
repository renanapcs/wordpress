# Use a imagem oficial do PHP com Apache e PHP 8.1
FROM php:8.1-apache

# Instale dependências necessárias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    sqlite3 \
    libsqlite3-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_sqlite zip

# Habilite o módulo de reescrita do Apache
RUN a2enmod rewrite

# Baixe e descompacte o WordPress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz

# Baixe o plugin do SQLite para WordPress
RUN curl -L -o /tmp/sqlite-integration.zip https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip \
    && unzip /tmp/sqlite-integration.zip -d /tmp \
    && mv /tmp/sqlite-integration /var/www/html/wp-content/plugins/ \
    && rm /tmp/sqlite-integration.zip

# Copie o arquivo de configuração do PHP
COPY ./php.ini /usr/local/etc/php/

# Copie o arquivo db.php para a integração do SQLite
RUN cp /var/www/html/wp-content/plugins/sqlite-integration/db.php /var/www/html/wp-content/db.php

# Defina permissões apropriadas
RUN chown -R www-data:www-data /var/www/html

# Exponha a porta 80
EXPOSE 8080

# Comando para iniciar o Apache
CMD ["apache2-foreground"]

