# Use a imagem oficial do PHP com Apache e PHP 8.1
FROM php:8.1-apache

# Instale dependências necessárias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli zip

# Habilite o módulo de reescrita do Apache
RUN a2enmod rewrite

# Baixe e descompacte o WordPress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz

# Defina permissões apropriadas
RUN chown -R www-data:www-data /var/www/html

# Copie o arquivo de configuração do PHP
COPY ./php.ini /usr/local/etc/php/

# Exponha a porta 80
EXPOSE 80

# Comando para iniciar o Apache
CMD ["apache2-foreground"]
