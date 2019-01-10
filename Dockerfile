FROM node:11.6.0-alpine

#时区(timezone support)
RUN apk add tzdata --no-cache

#安装(install yapi)
RUN apk add wget git python make openssl tar gcc --no-cache &&\
    cd /opt &&\
    mkdir yapi/vendors -p  &&\
    cd yapi &&\
    wget https://github.com/YMFE/yapi/archive/1.4.3.tar.gz

RUN cd /opt/yapi &&\
    tar xvzf 1.4.3.tar.gz -C vendors --strip-components 1 &&\
    cd vendors &&\
    npm install --production --registry https://registry.npm.taobao.org

#配置(config yapi)
RUN cd /opt/yapi &&\
    mkdir cnf.d &&\
    cp vendors/config_example.json cnf.d/config.json &&\
    ln -s /opt/yapi/cnf.d/config.json config.json

#卷
VOLUME ["/opt/yapi/cnf.d","/opt/yapi/log"] 

WORKDIR /opt/yapi/vendors

EXPOSE 3000

#CMD ["sh", "-c","\"[ ! -e ../log/init.lock ] && npm run install-server && touch ../log/init.lock; npm run start\""]
