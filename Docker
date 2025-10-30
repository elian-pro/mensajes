FROM php:8.2-apache

# Copiar archivos al directorio web
COPY index.html /var/www/html/
COPY login.html /var/www/html/
COPY auth.php /var/www/html/
COPY users.json /var/www/html/
COPY Logo_Zebra_Blanco.png /var/www/html/

# Permisos para que PHP pueda leer users.json
RUN chmod 644 /var/www/html/users.json

# Exponer puerto 80
EXPOSE 80

# Comando por defecto
CMD ["apache2-foreground"]
