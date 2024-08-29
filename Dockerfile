# Stage 1: Build the application
FROM node:14-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Serve the application with a minimal image
FROM node:14-alpine

# Set working directory
WORKDIR /app

# Install production dependencies only
COPY package*.json ./
RUN npm install --only=production

# Copy the built application from the previous stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json

# Set environment variables (optional)
ENV PORT=3000

# Expose the port that the app will run on
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
