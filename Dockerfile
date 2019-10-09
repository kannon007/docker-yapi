FROM ubuntu:18.04 
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \   
    git \
    libcurl4 \
    openssl \
    apt-transport-https \
    ca-certificates \
    python \
    wget 
RUN mkdir -p  /app/mongodb/conf && \
    mkdir -p  /app/mongodb/data && \    
    mkdir -p  /app/mongodb/log/ && \
    mkdir -p  /app/node/ && \
    mkdir -p  /app/yapi/    

RUN cd /app/mongodb/ && \ 
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.5.tgz && \
    tar -zxvf mongodb-linux-*.tgz && \
    mv   mongodb-linux*/* /app/mongodb
COPY mongodb.yml /app/mongodb/conf/mongodb.yml
RUN ln -s /app/mongodb/bin/mongod /usr/local/bin/mongod

RUN cd  /app/node/ && \
    wget http://cdn.npm.taobao.org/dist/node/v8.9.0/node-v8.9.0-linux-x64.tar.gz  && \
    tar -xzvf node-v8.9.0-linux-x64.tar.gz && \
    ln -s /app/node/node-v8.9.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /app/node/node-v8.9.0-linux-x64/bin/npm /usr/local/bin/npm

    

RUN cd /app/yapi/ && \
    mkdir yapiApp && \
    wget  https://github.com/YMFE/yapi/archive/v1.8.4.tar.gz && \
    tar -zxvf *.gz  -C ./yapiApp --strip-components 1

WORKDIR /app/yapi/yapiApp
USER root
RUN npm install --unsafe-perm
EXPOSE 27017
EXPOSE 3000
COPY config.json /app/yapi/config.json
CMD mongod -f /app/mongodb/conf/mongodb.yml && [ ! -e /app/mongodb/data/yapiInit.lock ] && npm run install-server && touch /app/mongodb/data/yapiInit.lock; npm run start
      