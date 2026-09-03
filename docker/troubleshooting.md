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

This lab provides hands-on experience with common Docker troubleshooting scenarios and techniques for diagnosing and resolving container issues.