# Configuring compose

## Real World Analogy
Configuring Docker Compose is like setting up and personalizing a smart home system for maximum comfort and efficiency.

Think of it like:
- **Home Automation Setup**: Like programming your smart home to automatically adjust lighting and temperature based on your daily schedule
- **System Parameter Tuning**: Like adjusting the sensitivity of motion sensors for your home security system
- **Preferences Configuration**: Like setting up your music system with favorite stations and speaker positions
- **Integration Planning**: Like coordinating different devices (lights, temperature, security) to work seamlessly together
- **Customization Optimization**: Like personalizing your home's appearance and control settings to suit your lifestyle

In smart home management:
1. **Custom System Behavior**: Programming each device to behave according to your preferences
2. **Interconnected Operation**: Ensuring devices work together instead of separately
3. **Optimization Settings**: Fine-tuning to get the best performance from each component  
4. **Personalized Experience**: Making sure everything reflects your personal style and habits
5. **Remote Management**: Being able to adjust settings from anywhere in the house

## Technical Explanation
Configuring Docker Compose involves fine-tuning the `docker-compose.yml` file to optimize multi-container applications. This includes:
- **Network Configuration**: Defining custom networks and network aliases
- **Volume Management**: Setting up data persistence with named volumes and bind mounts  
- **Environment Variables**: Managing configuration parameters that change between environments
- **Service Dependencies**: Specifying startup order and health checks
- **Resource Constraints**: Limiting CPU, memory, and other resources for containers
- **Scaling Options**: Defining how many instances of each service to run
- **Health Checks**: Ensuring services are operating correctly
- **Restart Policies**: Controlling container behavior on failures

Advanced configuration options let you:
- Customize container runtime behavior
- Secure container communications  
- Optimize resource usage and performance
- Implement complex application topologies in simple configuration files
- Support different deployment scenarios (development, staging, production)

## Lab Exercise: Advanced Compose Configuration
In this lab, you'll explore complex Docker Compose configuration options.

### Lab Steps
1. **Create advanced docker-compose.yml**
   ```yaml
   version: '3.8'
   services:
     # Database service with persistent volume
     database:
       image: postgres:13
       environment:
         POSTGRES_DB: myapp
         POSTGRES_USER: postgres
         POSTGRES_PASSWORD: secretpassword
       volumes:
         - postgres_data:/var/lib/postgresql/data
         - ./init-scripts:/docker-entrypoint-initdb.d
       networks:
         - app-network
       restart: unless-stopped
       healthcheck:
         test: ["CMD-SHELL", "pg_isready -U postgres"]
         interval: 30s
         timeout: 10s
         retries: 3
       deploy:
         resources:
           limits:
             memory: 512M
           reservations:
             memory: 256M
           
     # Application service
     app:
       build: .
       environment:
         DATABASE_URL: postgresql://postgres:secretpassword@database:5432/myapp
         NODE_ENV: production
       depends_on:
         database:
           condition: service_healthy
       networks:
         - app-network
         - monitoring-network
       ports:
         - "8000:8000"
       restart: always
       volumes:
         - ./logs:/app/logs
         - /app/node_modules
       ulimits:
         nproc: 65535
         nofile:
           soft: 20000
           hard: 40000
       # Read-only root filesystem with writable tmp directory  
       read_only: true
       tmpfs:
         - /tmp
       # Custom user and group IDs
       user: "1000:1000"
       
     # Reverse proxy service
     reverse-proxy:
       image: nginx:alpine
       depends_on:
         - app
       volumes:
         - ./nginx.conf:/etc/nginx/nginx.conf
         - ./ssl:/etc/nginx/ssl
       ports:
         - "80:80"
         - "443:443"
       networks:
         - app-network
       restart: on-failure
   
   # Custom networks
   networks:
     app-network:
       driver: bridge
       ipam:
         config:
           - subnet: 172.20.0.0/16
     monitoring-network:
       driver: bridge
       
   # Named volumes for persistence
   volumes:
     postgres_data:
   ```

2. **Create supporting files**
   ```bash
   # Create init-scripts directory
   mkdir -p init-scripts
   
   # Create database initialization script
   cat > init-scripts/init.sql << 'EOF'
   CREATE TABLE IF NOT EXISTS users (
       id SERIAL PRIMARY KEY,
       name VARCHAR(100),
       email VARCHAR(100)
   );
   INSERT INTO users (name, email) VALUES ('Test User', 'test@example.com');
   EOF
   
   # Create nginx config
   mkdir -p ssl
   cat > nginx.conf << 'EOF'
   events {
       worker_connections 1024;
   }
   
   http {
       upstream app_server {
           server app:8000;
       }
   
       server {
           listen 80;
           location / {
               proxy_pass http://app_server;
               proxy_set_header Host $host;
               proxy_set_header X-Real-IP $remote_addr;
           }
       }
   }
   EOF
   ```

3. **Build and start services**
   ```bash
   docker-compose up -d
   ```

4. **Monitor services health**
   ```bash
   docker-compose ps
   docker-compose logs app
   ```

5. **Check configuration validation**
   ```bash
   # Validate the compose file
   docker-compose config
   ```

6. **Test the application**
   ```bash
   curl http://localhost:8000
   ```

7. **Scale services for load testing**
   ```bash
   docker-compose up -d --scale app=3
   ```

8. **Monitor resource usage**
   ```bash
   docker stats
   ```

9. **Update configuration**
   ```bash
   # Scale back down
   docker-compose up -d --scale app=1
   
   # Perform configuration change
   docker-compose up -d --force-recreate
   ```

10. **Clean up**
    ```bash
    docker-compose down -v
    # -v flag removes named volumes
    ```

### Production Pipeline Infrastructure - docker-compose.prod.yml
```yaml
version: '3.8'

services:
  # Production Web Application 
  web:
    image: mycompany/web-app:${VERSION:-latest}
    container_name: web-${ENVIRONMENT}
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
      - REDIS_URL=redis://redis-cache:6379
      - API_GATEWAY=http://api-gateway:8080
    deploy:
      replicas: 3
    networks:
      - frontend
      - backend
    ports:
      - "80:80"
      - "443:443"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "50m"
        max-file: "5"
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
    volumes:
      - ./logs/web:/var/log/nginx
      - /var/cache/nginx

  # Application API Service
  api:
    image: mycompany/api-service:${VERSION:-latest}
    container_name: api-${ENVIRONMENT}
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
      - REDIS_URL=redis://redis-cache:6379
      - LOG_LEVEL=info
    deploy:
      replicas: 4
    networks:
      - backend
    expose:
      - "3000"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "50m"
        max-file: "5"
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    sysctls:
      - net.core.somaxconn=1024
      - net.ipv4.ip_local_port_range=1024 65535

  # Database Service
  db:
    image: postgres:13-alpine
    container_name: db-${ENVIRONMENT}
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./sql/init.sql:/docker-entrypoint-initdb.d/init.sql
      - ./logs/postgresql:/var/log/postgresql
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
        max-size: "50m"
        max-file: "5"
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
    cap_drop:
      - ALL
    read_only: true
    tmpfs:
      - /tmp

  # Redis Cache
  redis-cache:
    image: redis:alpine
    container_name: redis-${ENVIRONMENT}
    command: redis-server --requirepass password --appendonly yes
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
        max-size: "50m"
        max-file: "5"
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M

  # Load Balancer (Nginx)
  load-balancer:
    image: nginx:alpine
    container_name: lb-${ENVIRONMENT}
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
      - ./logs/nginx:/var/log/nginx
    networks:
      - frontend
      - backend
    restart: unless-stopped
    depends_on:
      - web
      - api

# Network definitions
networks:
  frontend:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.30.0.0/16
          gateway: 172.30.0.1
  backend:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.31.0.0/16
          gateway: 172.31.0.1

# Volumes for data persistence
volumes:
  postgres_data:
  redis_data:

# Override file for different environments
```

### CI/CD Environment Setup - .github/workflows/deploy.yml
```yaml
name: Production Deployment

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Login to DockerHub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
    
    - name: Build and push
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: |
          mycompany/web-app:${{ github.sha }}
          mycompany/web-app:latest
    
    - name: Deploy to Production
      run: |
        echo "Deploying to production environment..."
        ssh ${{ secrets.SSH_USER }}@${{ secrets.PROD_SERVER }} '
          cd /opt/production-app &&
          docker-compose pull &&
          docker-compose up -d
        '
    
    - name: Validate deployment
      run: |
        echo "Validating service health..."
        sleep 30
        curl -f http://prod-server/health || exit 1
```

### Security Hardening Script - security-hardening.sh
```bash
#!/bin/bash
# Security hardening for production Docker Compose

# 1. Set proper permissions
echo "Setting file permissions..."
find . -type f -name "*.yml" -o -name "*.yaml" -o -name "Dockerfile" | xargs chmod 600
chmod 700 ./scripts/*

# 2. Validate compose file syntax
echo "Validating docker-compose configuration..."
docker-compose config

# 3. Check for dangerous configurations
echo "Checking for security issues..."
echo "Scanning for privileged containers..."
docker-compose config | grep -i privileged && echo "WARNING: Privileged containers found!"

echo "Scanning for host network usage..."
docker-compose config | grep -i "network_mode.*host" && echo "WARNING: Host network in use!"

# 4. Audit environment variables in compose file
echo "Verifying environment variable handling..."
if grep -r "environment:" docker-compose*.yml; then
    echo "Environment variables found - ensure sensitive data is externalized"
fi

# 5. Check for hardcoded passwords
echo "Searching for hardcoded credentials..."
grep -r "password:" docker-compose*.yml && echo "WARNING: Potential hardcoded passwords in compose files!"

# 6. Verify volume configurations
echo "Checking volume permissions..."
docker-compose config | grep -E "(volumes|volume)" && echo "Validating volume configurations..."

echo "Security audit complete"
```

### Production Readiness Checklist - readiness-checklist.sh
```bash
#!/bin/bash
# Production readiness checklist for Docker Compose

echo "🚀 Production Readiness Check"
echo ===============================

echo "1. Version and Deployment Configuration"
version_check=$(grep "version:" docker-compose.yml)
echo "✓ Compose version: $version_check"

echo "2. Service Count"
service_count=$(docker-compose config --dry-run 2>/dev/null | grep -c "services:") || echo "No services found"
echo "Service count: $service_count"

echo "3. Environment Variables"
if [ -f .env ]; then
    echo "✓ Environment file found"
else
    echo "⚠️  Warning: No .env file found - environment variables may be missing"
fi

echo "4. Network Security"
networks=$(docker-compose config | grep -c "networks:")
echo "Network configuration: $networks networks defined"

echo "5. Health Checks"
healthchecks=$(docker-compose config | grep -c "healthcheck")
echo "Health check configuration: $healthchecks services have health checks"

echo "6. Resource Limits"
resources=$(docker-compose config | grep -c "deploy\|memory\|cpu")
echo "Resource configuration: $resources services with resource specs"

echo "7. Logging Configuration"
logging=$(docker-compose config | grep -c "logging")
echo "Logging configuration: $logging services with logging"

echo "8. Restart Policies"
restart_policies=$(docker-compose config | grep -c "restart:")
echo "Restart policies: $restart_policies services configured"

echo ""
echo "📋 Checklist Complete - review warnings and ensure production environment is ready"
```

This lab demonstrates advanced Docker Compose configuration techniques for building production-ready, robust multi-container applications. The enhanced version includes continuous integration pipelines, security hardening, production deployment scripts, and readiness assessment tools.