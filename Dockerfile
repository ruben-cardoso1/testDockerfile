FROM nginx:latest

# Supprime les fichiers nginx par défaut
RUN rm -rf /usr/share/nginx/html/*

# Copie ton site
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
