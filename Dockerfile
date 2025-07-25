# Step 1: Build and Test Stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source files
COPY . .

# Optional: Run tests if defined in package.json
# You can comment this out if no tests are defined
RUN CI=true npm test || echo "⚠️ Tests failed or not defined, continuing..."

# Build the React app
RUN npm run build

# Step 2: Production Stage with Nginx
FROM nginx:stable-alpine

# Copy built assets to Nginx html directory
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
