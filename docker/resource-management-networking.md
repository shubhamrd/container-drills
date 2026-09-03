# Docker Resource Management and Networking

## Real World Analogy
Docker resource management and networking are like managing a comprehensive university campus with multiple departments, each needing different resources and connections.

Think of it like:
- **Campus Planning**: Like designing a university with appropriate facilities for different departments
- **Resource Allocation**: Like assigning classrooms, laboratories, and equipment to different academic departments
- **Network Infrastructure**: Like the campus network connecting all buildings with reliable pathways
- **Traffic Management**: Like managing student flow between different campus facilities
- **Capacity Planning**: Like ensuring the campus has enough space and resources for growing enrollment

In university operations:
1. **Department Needs**: Different academic departments need vastly different resources  
2. **Infrastructure Sharing**: Libraries, dining halls, and facilities shared by all departments
3. **Resource Balancing**: Ensuring departments don't compete for the same limited resources
4. **Connection Efficiency**: Fast, reliable links between different campus locations
5. **Scalability Planning**: Preparing for expansions and evolving needs

## Technical Explanation
Docker resource management and networking involve setting up and configuring containerized applications to efficiently use system resources while ensuring proper network connectivity. This includes:
- **Resource Constraints**: Limiting CPU, memory, and disk usage for better system stability
- **Network Configuration**: Setting up container networks that are isolated yet communicable as needed
- **Performance Tuning**: Optimizing resource allocation for containers to run efficiently
- **Security Controls**: Implementing network policies that isolate containers and protect against unauthorized access
- **Monitoring**: Tracking resource usage to identify bottlenecks and optimize performance

Resource management includes CPU shares, memory limits, disk quotas, and network throttling. Networking handles container-to-container communication, external access, DNS resolution, and traffic routing.

## Lab Exercise: Resource Management and Network Configuration
In this lab, you'll explore Docker's resource management and networking capabilities.

### Lab Steps
1. **Run container with resource limits**
   ```bash
   docker run -d --name resource-limited \
     --memory="512m" \
     --cpus="0.5" \
     --name limited-container \
     nginx
   ```

2. **Check container resource usage**
   ```bash
   docker stats limited-container
   ```

3. **Create custom network**
   ```bash
   docker network create --driver bridge my-custom-network
   ```

4. **Run container on custom network**
   ```bash
   docker run -d --name network-test \
     --network my-custom-network \
     nginx
   ```

5. **Inspect network configuration**
   ```bash
   docker network inspect my-custom-network
   ```

6. **Connect container to multiple networks**
   ```bash
   docker run -d --name dual-net \
     --network my-custom-network \
     --network bridge \
     nginx
   ```

7. **Test network connectivity within container**
   ```bash
   docker exec network-test ping -c 3 google.com
   ```

8. **View container resource limits**
   ```bash
   docker inspect limited-container | grep -A 10 -B 5 "Memory\|Cpu"
   ```

9. **Monitor system resources**
   ```bash
   # Check overall system resource usage
   docker system df
   ```

10. **Clean up**
    ```bash
    docker stop limited-container network-test dual-net
    docker rm limited-container network-test dual-net
    docker network rm my-custom-network
    ```

### Production Resource Management - docker-compose.yml
```yaml
version: '3.8'

services:
  web-app:
    image: nginx:alpine
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    ports:
      - "8080:80"
    networks:
      - frontend
      - backend
    environment:
      - ENV=production
    restart: unless-stopped

  api-app:
    image: node:alpine
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
    ports:
      - "3000:3000"
    networks:
      - backend
    environment:
      - NODE_ENV=production
      - DB_HOST=database
    restart: unless-stopped

  database:
    image: postgres:13-alpine
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: mysecretpassword
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - backend
    restart: unless-stopped

networks:
  frontend:
    driver: overlay
  backend:
    driver: overlay

volumes:
  postgres-data:
```

### Network Configuration Best Practices - network-setup.sh
```bash
#!/bin/bash
# Production network configuration script

# Create production networks with proper security
echo "Creating production networks..."

# Frontend network (public access)
docker network create \
  --driver overlay \
  --opt encrypted=true \
  --opt com.docker.network.bridge.enable_ip_masquerade=true \
  --opt com.docker.network.bridge.enable_icc=true \
  frontend-network

# Backend network (internal services only)  
docker network create \
  --driver overlay \
  --opt encrypted=true \
  --opt com.docker.network.bridge.enable_ip_masquerade=true \
  --opt com.docker.network.bridge.enable_icc=true \
  backend-network

# Database network (most restrictive)
docker network create \
  --driver overlay \
  --opt encrypted=true \
  --opt com.docker.network.bridge.enable_ip_masquerade=true \
  database-network

echo "Networks created successfully!"

# Validate network configurations
docker network ls
```

### Resource Monitoring Dashboard - resource-monitor.py
```python
#!/usr/bin/env python3
"""
Production resource monitoring for Docker containers
"""
import docker
import json
import time
from datetime import datetime

def monitor_resources():
    client = docker.from_env()
    
    print("Docker Resource Monitoring")
    print("=" * 50)
    
    # Get all running containers
    containers = client.containers.list()
    
    for container in containers:
        try:
            # Get container stats
            stats = container.stats(stream=False)
            
            print(f"\nContainer: {container.name}")
            print(f"Status: {container.status}")
            
            # Extract resource usage
            if 'cpu_stats' in stats and 'precpu_stats' in stats:
                cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - stats['precpu_stats']['cpu_usage']['total_usage']
                system_delta = stats['cpu_stats']['system_cpu_usage'] - stats['precpu_stats']['system_cpu_usage']
                
                if system_delta > 0:
                    cpu_percent = (cpu_delta / system_delta) * 100
                    print(f"CPU Usage: {cpu_percent:.2f}%")
            
            if 'memory_stats' in stats:
                mem_usage = stats['memory_stats']['usage']
                mem_limit = stats['memory_stats']['limit']
                mem_percent = (mem_usage / mem_limit) * 100 if mem_limit > 0 else 0
                print(f"Memory Usage: {mem_usage/(1024*1024):.2f}MB / {mem_limit/(1024*1024):.2f}MB ({mem_percent:.2f}%)")
                
        except Exception as e:\n            print(f"Error monitoring {container.name}: {e}")

if __name__ == "__main__":
    # Run monitoring continuously
    while True:
        monitor_resources()
        time.sleep(10)
```

This lab helps understand how Docker handles container resource allocation and network configuration for optimal application performance and security. The enhanced version includes production-ready configurations, monitoring scripts, and real-world examples of best practices.