FROM python:3.10

RUN apt update && apt install -y --no-install-recommends npm
RUN npm install -g yarn
RUN yarn global add ganache-cli@6.12.1

RUN pip3 install eth-brownie

WORKDIR /app
COPY . .
RUN yarn install
RUN brownie compile
