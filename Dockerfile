FROM python:3.10

RUN apt update && apt install -y --no-install-recommends npm
RUN npm install -g yarn
RUN yarn global add ganache-cli@6.12.1

RUN pip3 install eth-brownie
COPY neon-brownie.patch /tmp/
COPY neon-brownie2.patch /tmp/
RUN cd /usr/local/lib/python3.10/site-packages && patch -p0 < /tmp/neon-brownie.patch && patch -p0 < /tmp/neon-brownie2.patch

WORKDIR /app
COPY . .
RUN yarn install
RUN brownie compile
ARG PROXY_URL
RUN brownie networks add live neon host="$PROXY_URL" chainid=111 timeout=60
