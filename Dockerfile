FROM debian:stable-slim

LABEL maintainer="OmniDB-NG team"

SHELL ["/bin/bash", "-c"]

USER root

RUN addgroup --system omnidb && adduser --system omnidb --ingroup omnidb && apt update && apt install -y curl wget vim python3 sudo libsasl2-dev python3-dev python3-pip libldap2-dev libssl-dev 

WORKDIR /

ENV LD_LIBRARY_PATH=${ORACLE_HOME}
ENV PATH=/usr/local/bin:/home/omnidb/.local/bin:$ORACLE_HOME:$PATH

USER omnidb:omnidb
ENV HOME /home/omnidb

WORKDIR ${HOME}
COPY --chown=omnidb:omnidb . OmniDB

WORKDIR ${HOME}/OmniDB
RUN ls . && ls .. && pip3 install -r requirements.txt

WORKDIR ${HOME}/OmniDB/OmniDB
RUN sed -i "s/LISTENING_ADDRESS    = '127.0.0.1'/LISTENING_ADDRESS = '0.0.0.0'/g" config.py \
    && python3 omnidb-server.py --init 

EXPOSE 8000

CMD python3 omnidb-server.py
