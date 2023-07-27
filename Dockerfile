# Etapa de construcción (build)
FROM node:18.17.0 as build

WORKDIR /usr/src/app

# Copiar archivos del proyecto (asegúrate de tener el archivo package.json y package-lock.json)
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar todo el código fuente
COPY . .

# Compilar el proyecto (asegúrate de tener el comando de compilación adecuado)
RUN npm run build

# Etapa de producción
FROM node:18.17.0 

WORKDIR /usr/src/app

# Copiar el código compilado desde la etapa de construcción (build)
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Instalar PM2 de forma global
RUN npm install pm2 -g

# Iniciar la aplicación con PM2
CMD ["pm2-runtime", "dist/main.js"]
