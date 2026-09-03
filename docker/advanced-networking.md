# Advanced Docker Networking

## Real World Analogy
Advanced Docker networking is like designing a sophisticated metropolitan transportation system with multiple layers of complexity.

Think of it like:
- **Multi-Level Transit System**: Like having subways, buses, express trains, and bike paths all coordinated
- **Dynamic Route Management**: Like traffic lights and GPS systems that adjust routes based on congestion
- **Zoning Regulations**: Like different traffic rules in commercial, residential, and industrial districts
- **Interconnection Points**: Like major hubs where different transportation modes connect
- **Real-Time Adaptation**: Like systems that respond to weather, traffic, or maintenance conditions

In urban transportation:
1. **Layered Infrastructure**: Different transportation modes working together seamlessly
2. **Smart Traffic Management**: Intelligent routing that adapts to real-time conditions  
3. **Regulatory Compliance**: Different rules for different zones and vehicle types
4. **Integration Points**: Where systems join and coordinate effectively
5. **Resilience Planning**: Backup paths when primary routes are blocked

## Technical Explanation
Advanced Docker networking provides sophisticated network management capabilities that go beyond basic container networking. This includes:
- **Overlay Networks**: Creating virtual networks that span multiple Docker hosts
- **Custom Network Drivers**: Implementing specialized network protocols 
- **Network Policies**: Enforcing security and access controls
- **Service Discovery**: Automatic name resolution and health checks
- **Load Balancing**: Distributing network traffic across multiple containers
- **Multi-host Networking**: Seamless communication between containers across different physical machines

Advanced networking solutions support:
- **Microservices architectures** with inter-container communication
- **Service mesh implementations** with built-in observability  
- **High-availability setups** with automatic failover
- **Multi-cloud deployments** with consistent networking
- **Security segmentation** through network isolation

## Lab Exercise: Advanced Network Configuration
In this lab, you'll explore advanced Docker networking features.

### Lab Steps
1. **Create custom overlay network**
   ```bash
   # For swarm mode - this creates an overlay network
   docker network create --driver overlay --subnet=10.0.1.0/24 my-overlay-net
   ```

2. **Create services on overlay network**
   ```bash
   # Create two services on the overlay network
   docker service create --name service1 --network my-overlay-net nginx
   docker service create --name service2 --network my-overlay-net redis
   ```

3. **Inspect advanced networking**
   ```bash
   docker network inspect my-overlay-net
   docker service inspect service1
   ```

4. **Test service discovery**
   ```bash
   # Run debugging container to test service connectivity
   docker run --rm --network my-overlay-net alpine nslookup service1
   ```

5. **Create user-defined bridge network**
   ```bash
   docker network create --driver bridge --subnet=172.20.0.0/16 --gateway=172.20.0.1 user-net
   ```

6. **Run container on user network**
   ```bash
   docker run -d --name user-net-container --network user-net nginx
   ```

7. **Test advanced connectivity within network**
   ```bash
   docker exec user-net-container ping -c 3 172.20.0.1
   ```

8. **Configure custom DNS**
   ```bash
   # This would typically be done in a docker-compose file or configuration
   docker network create --driver bridge --opt com.docker.network.bridge.name=br-001 custom-net
   ```

9. **Set up network aliasing**
   ```bash
   # In docker-compose or when creating services
   # You could create aliases for better service discovery
   ```

10. **Clean up test networks**
    ```bash
    # Remove services
    docker service rm service1 service2 2>/dev/null || true
    
    # Remove networks
    docker network rm my-overlay-net user-net custom-net 2>/dev/null || true
    
    # Remove containers
    docker rm -f user-net-container 2>/dev/null || true
    ```

### Production Advanced Networking - docker-compose.yml
```yaml
version: '3.8'

services:
  # Web application with custom network configuration
  web-app:
    image: nginx:alpine
    networks:
      frontend:
        aliases:
          - web.frontend.internal
          - nginx.web.internal
      backend:
        aliases:
          - app.backend.internal
    ports:
      - "80:80"
      - "443:443"
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
    environment:
      - NGINX_HOST=webapp.example.com
      - ENV=production
      
  # Application API with restricted network access
  api-app:
    image: node:alpine
    networks:
      backend:
        aliases:
          - api.backend.internal
          - app.api.internal
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DB_HOST=database
      - REDIS_HOST=cache
    deploy:
      replicas: 2
    depends_on:
      - database
      - cache
    restart: unless-stopped

  # Database with restricted access
  database:
    image: postgres:13-alpine
    networks:
      backend:
        aliases:
          - db.backend.internal
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: mysecretpassword
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    deploy:
      replicas: 1
    restart: unless-stopped

  # Cache service
  cache:
    image: redis:alpine
    networks:
      backend:
        aliases:
          - cache.backend.internal
    deploy:
      replicas: 1
    restart: unless-stopped

networks:
  # Frontend network - public access
  frontend:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.22.0.0/16
          gateway: 172.22.0.1
    options:
      com.docker.network.bridge.enable_ip_masquerade: "true"
      com.docker.network.bridge.enable_icc: "true"
      
  # Backend network - private access only
  backend:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.23.0.0/16
          gateway: 172.23.0.1
    options:
      com.docker.network.bridge.enable_ip_masquerade: "true"
      com.docker.network.bridge.enable_icc: "false"
      
  # Management network - admin access
  management:
    driver: overlay
    ipam:
      driver: default
      config:
        - subnet: 172.24.0.0/16
          gateway: 172.24.0.1
    internal: true  # Fully isolated network
      
volumes:
  postgres-data:
```

### Network Security and Monitoring - network-security.sh
```bash
#!/bin/bash
# Network security and monitoring for Docker containers

echo "=== Docker Network Security Audit ==="

# 1. Check for exposed ports
echo "1. Exposed Ports Analysis"
echo "========================"
docker ps --format "table {{.Names}}\t{{.Ports}}" | tail -n +2 | while read name ports; do
    if [[ "$ports" =~ [0-9]+:[0-9]+ ]]; then
        echo "- $name: $ports"
    fi
done

echo ""
# 2. Network Isolation Check
echo "2. Network Isolation Report"
echo "==========================="
for network in $(docker network ls --format "{{.Name}}"); do
    echo "- Network: $network"
    docker network inspect "$network" | grep -E "(Type|Containers)" | head -5
done

echo ""
# 3. Port Firewall Rules (for production systems)
echo "3. Docker Port Security Recommendations"
echo "======================================"
# In production, you'd typically also configure iptables rules
echo "Recommended: Implement external firewall rules for exposed ports"
echo "Recommended: Use network policies for additional isolation"
echo "Recommended: Disable host networking for production containers"
```

### Network Troubleshooting Script - network-troubleshoot.sh
```bash
#!/bin/bash
# Comprehensive network troubleshooting script

set -e

echo "Docker Network Troubleshooting Suite"
echo "==================================="

# Check Docker daemon status
echo "1. Docker Daemon Status"
echo "======================"
systemctl status docker >/dev/null 2>&1 && echo "✓ Docker daemon running" || echo "✗ Docker daemon not running"

# Check Docker networks
echo ""
echo "2. Network Summary"
echo "================="
docker network ls

# Check network connectivity between containers
echo ""
echo "3. Network Connectivity Tests"
echo "============================"

# List running containers
containers=$(docker ps --format "{{.Names}}" | head -n 5)  # Limit to first 5

for container in $containers; do
    if [ ! -z "$container" ]; then
        echo "Testing connectivity for $container..."
        # Basic ping test (if available in container)
        docker exec "$container" timeout 5 ping -c 1 8.8.8.8 2>/dev/null && echo "✓ Internet connectivity OK" || echo "✗ No internet connectivity"
    fi
done

# Check network configuration details
echo ""
echo "4. Network Configuration Details"
echo "=============================="
for network in $(docker network ls --format "{{.Name}}"); do
    echo "Network: $network"
    docker network inspect "$network" | jq -r ".[].IPAM.Config[] | \"  Subnet: \(.Subnet) Gateway: \(.Gateway)\"" 2>/dev/null || echo "  (Could not parse configuration)"
done

echo ""
echo "Troubleshooting Complete"
```

This lab explores sophisticated Docker network configurations that support complex application architectures and enterprise deployment scenarios. The enhanced version includes production-grade configurations with network policies, security considerations, and troubleshooting scripts.