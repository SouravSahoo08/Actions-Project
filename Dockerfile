from node:lts-alpine3.23

workdir /app

copy package*.json .

run npm install && npm cache clean --force

copy . .

env PORT=3030

expose $PORT

cmd ["npm", "start"]