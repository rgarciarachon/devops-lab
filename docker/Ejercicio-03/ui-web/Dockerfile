# Usa una imagen base de Node.js
FROM node:18
 
# Crea los directorios necesario    
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
 
# Establece el directorio de trabajo dentro del contenedor
WORKDIR /home/node/app
 
# Copia los archivos del proyecto
COPY . .
 
# Instala las dependencias
RUN yarn install
 
# Expone el puerto en el que corre el frontend
EXPOSE 5173
 
# Comando para ejecutar el frontend
CMD ["yarn", "dev", "--host"]