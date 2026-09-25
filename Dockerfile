FROM nginx:latest

RUN apt-get update -y && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/firefighter.zip \
    https://freewebsitetemplates.com/download/firefighterwebsitetemplate/

RUN mkdir -p /tmp/firefighter && \
    unzip /tmp/firefighter.zip -d /tmp/firefighter

RUN cp -rvf /tmp/firefighter/firefighterwebsitetemplate/* \
    /usr/share/nginx/html/ || \
    cp -rvf /tmp/firefighter/* /usr/share/nginx/html/

RUN rm -rf /tmp/firefighter /tmp/firefighter.zip

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
