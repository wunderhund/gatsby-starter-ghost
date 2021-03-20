FROM node:14
WORKDIR /app

RUN apt-get update && apt-get install -y \
  git

RUN npm install -g gatsby-cli
