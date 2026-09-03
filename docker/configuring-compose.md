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

This lab demonstrates advanced Docker Compose configuration techniques for building production-ready, robust multi-container applications.