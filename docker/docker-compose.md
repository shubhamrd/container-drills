# Docker Compose

## Real World Analogy
Docker Compose is like having a detailed construction blueprint that specifies how to build an entire building with many interconnected systems all at once.

Think of it like:
- **House Blueprint**: Like having detailed plans showing where every room, electrical outlet, and pipe should go
- **Assembly Instructions**: Like step-by-step directions for putting together a complex piece of furniture
- **Integrated System Design**: Like planning how all mechanical, electrical, and plumbing systems work together
- **Single Point of Control**: Like having one master plan you consult to understand how everything fits
- **Scalable Construction**: Like being able to reproduce the same complex building in multiple locations

In construction:
1. **Coordination Plan**: Ensures all systems work together rather than separately  
2. **Standardized Process**: Everyone follows the same blueprint and specifications
3. **Modular Approach**: Complex building broken down into manageable sections
4. **Quality Control**: Each component is built to precise specifications from one document
5. **Efficient Build Process**: No rework from missing or conflicting instructions

## Technical Explanation
Docker Compose provides a way to define and run multi-container Docker applications using a YAML file called `docker-compose.yml`. It allows you to:
- Define services that make up your application
- Configure networks between services
- Define volume mounts for data persistence
- Set environment variables and configuration
- Specify service dependencies and startup order
- Manage entire applications with a single command

Compose solves complex multi-container problems by:
- Managing interdependent containers as one application
- Handling network configuration automatically
- Preserving data through volumes
- Providing consistent deployment environments
- Supporting multi-environment configurations

## Lab Exercise: Docker Compose Implementation
In this lab, you'll set up and manage a multi-container application using Docker Compose.

### Lab Steps
1. **Create a sample application directory**
   ```bash
   mkdir docker-compose-lab
   cd docker-compose-lab
   ```

2. **Create a docker-compose.yml file for a simple web application**
   ```yaml
   version: '3.8'
   services:
     web:
       image: nginx:latest
       ports:
         - "8080:80"
       volumes:
         - ./html:/usr/share/nginx/html
       depends_on:
         - app
         
     app:
       image: node:16-alpine
       working_dir: /app
       volumes:
         - ./app:/app
       command: sh -c "npm install && npm start"
       ports:
         - "3000:3000"
   ```

3. **Create supporting directories and files**
   ```bash
   # Create HTML directory and index file
   mkdir -p html app
   
   # Create simple HTML page
   cat > html/index.html << 'EOF'
   <!DOCTYPE html>
   <html>
   <head>
       <title>Docker Compose Demo</title>
   </head>
   <body>
       <h1>Hello from Docker Compose!</h1>
       <p>This site is running in containers managed by Docker Compose.</p>
   </body>
   </html>
   EOF
   
   # Create Node.js application file
   cat > app/server.js << 'EOF'
   const express = require('express');
   const app = express();
   const port = 3000;
   
   app.get('/', (req, res) => {
     res.send('Hello from Node.js app!');
   });
   
   app.listen(port, () => {
     console.log(`Node.js app listening at http://localhost:${port}`);
   });
   EOF
   
   # Create package.json
   cat > app/package.json << 'EOF'
   {
     "name": "docker-compose-demo",
     "version": "1.0.0",
     "main": "server.js",
     "dependencies": {
       "express": "^4.18.0"
     }
   }
   EOF
   ```

4. **Start the application**
   ```bash
   docker-compose up -d
   ```

5. **View the running services**
   ```bash
   docker-compose ps
   ```

6. **Check service logs**
   ```bash
   docker-compose logs web
   docker-compose logs app
   ```

7. **Access the application**
   ```bash
   # Test web interface
   curl http://localhost:8080
   
   # Test API endpoint
   curl http://localhost:3000
   ```

8. **Scale services**
   ```bash
   docker-compose up -d --scale web=3
   ```

9. **View updated service status**
   ```bash
   docker-compose ps
   ```

10. **Stop and clean up**
    ```bash
    docker-compose down
    ```

11. **Clean up local files (optional)**
    ```bash
    cd ..
    rm -rf docker-compose-lab
    ```

### Production-Grade Docker Compose - docker-compose.yml
```yaml
version: '3.8'

services:
  # Web Application Layer
  nginx:
    image: nginx:alpine
    container_name: web-server
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d\n      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - app
    networks:
      - frontend
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  # Application Layer
  app:
    build: .
    container_name: node-app
    environment:
      - NODE_ENV=production
      - PORT=3000
      - DB_HOST=database
      - REDIS_HOST=redis-cache
    expose:
      - "3000"
    depends_on:
      - database
      - redis-cache
    networks:
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    ulimits:
      nofile:
        soft: 65536
        hard: 65536

  # Database Service
  database:
    image: postgres:13-alpine
    container_name: postgres-db
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=your_secure_password_here
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
      - ./logs/postgres:/var/log/postgresql
    networks:
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  # Redis Cache Service
  redis-cache:
    image: redis:alpine
    container_name: redis-cache
    command: redis-server --requirepass your_redis_password
    volumes:
      - redis_data:/data
      - ./redis.conf:/usr/local/etc/redis/redis.conf
    networks:
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

# Network definitions
networks:
  frontend:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.25.0.0/16
          gateway: 172.25.0.1
  backend:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.26.0.0/16
          gateway: 172.26.0.1

# Volume definitions for persistence
volumes:
  postgres_data:
  redis_data:

# Environment-specific override files
# Use with: docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Production Build Configuration - Dockerfile
```dockerfile
# Production Dockerfile for Node.js application
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy source files
COPY . .

# Change ownership to non-root user
USER nextjs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Start the application
CMD ["node", "server.js"]
```

### Production Ready Scripts

#### deploy.sh - Production deployment script
```bash
#!/bin/bash
# Production deployment script for Docker Compose

# Configuration
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env.production"

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    export $(cat "$ENV_FILE" | xargs)
fi

echo "🚀 Starting Production Deployment"
echo "================================"

# 1. Pull latest images
echo "1. Pulling latest images..."
docker-compose pull

# 2. Build images if needed
echo "2. Building application images..."
docker-compose build

# 3. Bring up services
echo "3. Starting services..."
docker-compose up -d

# 4. Check service status
echo "4. Verifying service status..."
timeout 60 docker-compose ps

# 5. Wait for health checks
echo "5. Waiting for services to be healthy..."
sleep 10

# 6. Verify health status
echo "6. Final service status:"
docker-compose ps

# 7. Log deployment info
echo "================================"
echo "Deployment completed successfully"
echo "Services running: $(docker-compose ps --format \"{{.Names}}\" | tr '\n' ' ')"
echo "================================"

exit 0
```

#### backup.sh - Data backup script
```bash
#!/bin/bash
# Production backup script for database and persistent data

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DB_BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

echo "📦 Starting Database Backup"
echo "=========================="

# Backup PostgreSQL database
if docker compose exec database pg_dump -U postgres myapp > "$DB_BACKUP_FILE"; then
    echo "✅ Database backup created: $DB_BACKUP_FILE"
    echo "Size: $(du -h "$DB_BACKUP_FILE" | cut -f1)"
    
    # Compress backup
    gzip "$DB_BACKUP_FILE"
    echo "✅ Backup compressed"
else
    echo "❌ Database backup failed"
    exit 1
fi

# Backup Redis data
echo "📦 Backing up Redis data..."
if docker compose exec redis-cache redis-cli SAVE > /dev/null 2>&1; then
    echo "✅ Redis data backup completed"
fi

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +7 -delete
echo "🧹 Old backups cleaned up"

echo "🎉 Backup process completed successfully"
```

This lab demonstrates the core principles and practical usage of Docker Compose for managing complex multi-container applications. The enhanced version includes production-grade configurations with security, monitoring, logging, and deployment scripts.