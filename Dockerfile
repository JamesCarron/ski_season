# Ski 2027 plan: static site, built on the box (see infra/apps/ski/compose.yml).
# Unprivileged nginx listens on 8080 and runs as non-root.
FROM nginxinc/nginx-unprivileged:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY site/ /usr/share/nginx/html/
EXPOSE 8080
