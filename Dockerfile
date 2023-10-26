# Use an official Node runtime as a base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

RUN npm install express

# Install nodemon
RUN npm install -g nodemon

# Expose a port (if your Node.js app needs it)
EXPOSE 3000

# Start the application
CMD ["nodemon", "./app/index.js"]
