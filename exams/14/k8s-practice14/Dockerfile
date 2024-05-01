FROM public.ecr.aws/docker/library/node:20-slim

WORKDIR /app
COPY index.js index.js
COPY package-lock.json package-lock.json
COPY package.json package.json

RUN npm install

CMD ["node", "index.js"]

EXPOSE 80