#Stage 1 - Flask builder
FROM python:3.9-slim-buster AS builder 

RUN pip install jinja2 mysql-connector-python

ARG MYSQL_HOST
ARG MYSQL_USER
ARG MYSQL_PASS
ARG MYSQL_DB
ENV MYSQL_HOST=$MYSQL_HOST
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_PASS=$MYSQL_PASS
ENV MYSQL_DB=$MYSQL_DB

WORKDIR /app

COPY . .

RUN python app.py

# Stage 2 - Web Server
FROM nginx

COPY --from=builder /app/index.html /usr/share/nginx/html/

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]