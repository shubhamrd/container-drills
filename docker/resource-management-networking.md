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

This lab helps understand how Docker handles container resource allocation and network configuration for optimal application performance and security.