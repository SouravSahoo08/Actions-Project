from node:lts-alpine3.23

workdir /app

copy package*.json .

run npm ci && npm cache clean --force

copy . .

cmd ["npm", "run", "dev"]