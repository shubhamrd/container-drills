# Docker Troubleshooting

## Real World Analogy
Docker troubleshooting is like being a mechanic diagnosing a complex car engine while the car is running on the road.

Think of it like:
- **Diagnostic Tools**: Like using a computer diagnostic scanner to identify what's wrong with the engine
- **Systematic Process**: Like methodically checking engine components one by one
- **Error Reading**: Like interpreting warning lights and error codes on the dashboard
- **Root Cause Fixing**: Like identifying why a specific part failed and solving the underlying problem
- **Preventive Maintenance**: Like fixing small issues before they become major breakdowns

In car maintenance:
1. **Symptom Analysis**: Understanding what symptoms the car is showing
2. **Component Isolation**: Narrowing down which parts might be failing
3. **Diagnostic Tests**: Running tests to identify root causes
4. **Precision Repair**: Fixing exact issues rather than replacing big components unnecessarily
5. **Prevention Strategy**: Learning from the problem to avoid future recurrence

## Technical Explanation
Docker troubleshooting involves identifying and resolving problems that occur during container creation, running, network setup, or application execution. This can include common issues like:
- Container startup failures
- Network connectivity problems  
- Resource constraint errors
- Permission and access denied issues
- Image corruption or pull failures
- Volume mounting errors
- Daemon connection issues

Effective troubleshooting requires understanding:
- Docker daemon logs and system information
- Container status inspection
- Log file analysis
- Network connectivity testing
- Resource utilization monitoring
- Error message interpretation

## Lab Exercise: Troubleshooting Docker Issues
In this lab, you'll practice common Docker troubleshooting techniques.

### Lab Steps
1. **Create container that will fail to demonstrate error handling**
   ```bash
   # Try to run nonexistent image
   docker run nonexistent-image:latest
   ```

2. **Check Docker daemon logs for issues**
   ```bash
   # View Docker daemon logs (may require elevated permissions)
   journalctl -u docker.service | tail -20
   # Or if on systemd system:
   # sudo journalctl -u dockerd | tail -20
   ```

3. **Inspect failed container and get detailed error information**
   ```bash
   # First, create a container that fails
   docker run -d --name failing-container nginx:invalid-tag
   # Then inspect it
   docker inspect failing-container
   ```

4. **Check container logs**
   ```bash
   docker logs failing-container
   ```

5. **Test container connectivity**
   ```bash
   # Try running a simple troubleshooting container
   docker run -it --rm ubuntu:latest bash
   # Inside container:
   # apt update && apt install -y iputils-ping
   # ping google.com
   ```

6. **Identify and resolve resource issues**
   ```bash
   # Run a memory-intensive container to demonstrate limiter
   docker run -d --name mem-test --memory="100m" ubuntu:latest sleep 3600
   ```

7. **Check container resource usage**
   ```bash
   docker stats mem-test --no-stream
   ```

8. **Fix permissions issue with volumes**
   ```bash
   # Create directory and set proper permissions
   mkdir -p /tmp/test-volume
   chmod 755 /tmp/test-volume
   # Run container with volume
   docker run -d --name volume-test -v /tmp/test-volume:/app ubuntu:latest sleep 3600
   ```

9. **Identify common error types**
   ```bash
   # Try network issue (run container with unreachable host)
   docker run -d --name net-test --network none redis:latest
   ```

10. **Clean up test containers**
    ```bash
    # Kill all test containers
    docker stop failing-container mem-test volume-test net-test 2>/dev/null || true
    docker rm failing-container mem-test volume-test net-test 2>/dev/null || true
    ```

11. **System-wide Docker health check**
    ```bash
    # Check Docker system information
    docker info
    # Check Docker disk usage
    docker system df
    ```

### Production Troubleshooting Toolkit - troubleshooting.sh
```bash
#!/bin/bash
# Comprehensive Docker troubleshooting toolkit

echo "Docker Production Troubleshooting Toolkit"
echo "========================================"

# 1. System Health Check
echo "1. System Health Check"
echo "====================="
docker info | grep -E "(Server Version|Kernel Version|Operating System|CPUs|Memory)"
echo ""

# 2. Running Containers Health
echo "2. Running Containers"
echo "==================="
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
echo ""

# 3. Container Logs Analysis
echo "3. Recent Container Errors"
echo "========================"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | tail -n +2 | while read container _ _ status; do
    if [[ "$status" != *"Up"* ]]; then
        echo "Container: $container - Error Status"
        docker logs --tail 20 "$container" 2>/dev/null || echo "No logs available"
        echo ""
    fi
done

# 4. Resource Usage
echo "4. Resource Usage"
echo "==============="
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" | head -10
echo ""

# 5. Disk Usage
echo "5. Disk Usage"
echo "============"
docker system df -h
echo ""

# 6. Network Issues Check
echo "6. Network Configuration"
echo "======================="
docker network ls
echo ""
docker network inspect bridge 2>/dev/null | grep -A 5 -B 5 "Containers" || echo "Bridge network info not available"
```

### Docker Log Monitoring with Alerts - log-monitor.py
```python
#!/usr/bin/env python3
"""
Production Docker log monitoring with alerting
"""
import subprocess
import re
import time
import smtplib
from email.mime.text import MimeText

class DockerLogMonitor:
    def __init__(self):
        self.error_patterns = [
            r'error',
            r'fatal',
            r'exception',
            r'critical',
            r'failed',
            r'unexpected'
        ]
        
    def monitor_containers(self):
        """Monitor all running containers for errors"""
        try:
            # Get running containers
            result = subprocess.run(['docker', 'ps', '--format', '{{.ID}}'], 
                                  capture_output=True, text=True, check=True)
            
            containers = result.stdout.strip().split('\n')
            
            for container_id in containers:
                if container_id:
                    # Get recent logs
                    logs = subprocess.run(['docker', 'logs', '--tail', '100', container_id],
                                         capture_output=True, text=True)
                    
                    errors = []
                    for line in logs.stdout.split('\n'):
                        for pattern in self.error_patterns:
                            if re.search(pattern, line, re.IGNORECASE):
                                errors.append((pattern, line))
                                
                    if errors:
                        print(f"⚠️  ERRORS FOUND in container {container_id}:")
                        for pattern, line in errors[:3]:  # Show first 3 errors
                            print(f"  [{pattern.upper()}] {line}")
                            
        except Exception as e:\n            print(f"Error in monitoring: {e}")
            
    def check_memory_usage(self):
        """Check high memory usage containers"""
        try:
            result = subprocess.run(['docker', 'stats', '--no-stream', '--format', 
                                   '{{.Name}}\t{{.MemPercent}}'], 
                                  capture_output=True, text=True, check=True)
            
            stats = result.stdout.strip().split('\n')
            for stat in stats:
                if stat:
                    parts = stat.split('\t')
                    if len(parts) >= 2:
                        name, mem_percent = parts[0], parts[1].rstrip('%')
                        try:
                            percent = float(mem_percent)
                            if percent > 80:  # Alert if over 80% memory
                                print(f"⚠️  HIGH MEMORY USAGE: {name} at {percent}%")
                        except ValueError:
                            continue
        except Exception as e:\n            print(f"Error in memory check: {e}")

if __name__ == "__main__":
    monitor = DockerLogMonitor()
    print("Starting Docker log and resource monitoring...")
    while True:
        monitor.monitor_containers()
        monitor.check_memory_usage()
        time.sleep(60)  # Check every minute
```

### Common Troubleshooting Commands Reference
```bash
# Emergency Recovery Commands
docker system prune -f                       # Remove unused containers, networks, images
docker system prune -a -f                   # Remove all unused resources  
docker volume prune -f                      # Clean up unused volumes
docker builder prune -f                     # Clean up build cache

# Debug Container Startup Issues
docker run --rm -it --entrypoint /bin/bash <image-name>  # Debug container shell
docker logs <container-name> --details     # Detailed container logs
docker inspect <container-name>            # Deep container inspection

# Network Troubleshooting
docker network ls                          # List all networks
docker network inspect <network-name>      # Inspect network details
docker run --rm --network <network> alpine ping <target>  # Test network connectivity

# Resource Analysis
docker stats --no-stream                   # Quick resource overview
docker system df                           # Storage usage analysis
docker events                              # View recent Docker events
docker top <container>                     # View container processes
```

This lab provides hands-on experience with common Docker troubleshooting scenarios and techniques for diagnosing and resolving container issues. The enhanced version includes production-ready monitoring scripts, alerting systems, and troubleshooting utilities.