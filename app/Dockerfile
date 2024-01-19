# Use an official Node.js runtime as a base image
FROM node:18

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the application code to the working directory
COPY index.js .

# Expose the port that the app will run on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
