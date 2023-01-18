FROM python:3.10

RUN apt update && apt install -y --no-install-recommends npm
RUN npm install -g yarn
RUN yarn global add ganache-cli@6.12.1

RUN pip3 install eth-brownie
COPY neon-brownie.patch /tmp/
RUN cd /usr/local/lib/python3.10/site-packages && patch -p0 < /tmp/neon-brownie.patch

WORKDIR /app
COPY . .
RUN yarn install
RUN brownie compile
RUN brownie networks add live neon host=$PROXY_URL chainid=111
