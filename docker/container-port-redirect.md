# Container Port Redirect

## Non-Technical Example
Container port redirection is like having a hotel switchboard operator. 

In a hotel:
- The guests (your applications) live in specific rooms (containers)
- Each room has a unique room number (container port)
- But guests can only reach the hotel from the lobby (host machine)
- The switchboard operator (Docker) routes calls from the lobby to the correct room
- If someone wants to visit a guest in room 101, they don't knock on room 101 directly
- Instead, they go to the hotel lobby and give the switchboard operator their room number
- The operator then connects them to room 101

This is exactly how container port redirection works - Docker acts as the hotel switchboard operator, routing requests from your host machine to the specific ports inside containers.

## Technical Description
Container port redirection (also called port mapping) allows you to expose ports from containers to the host machine. By default, containers run in isolation and their internal ports are not accessible from the host environment.

The mapping process uses the syntax: `-p [host_port]:[container_port]` where:
- **Host Port**: The port on your host machine that will receive incoming connections
- **Container Port**: The port inside the container that the application is actually listening on

Container ports can be:
- Exposed with `EXPOSE` instruction in Dockerfile (documentation only, not actual mapping)
- Mapped with `-p` flag at runtime (practical port binding)
- Published automatically with `--publish-all` flag (random host ports)
- Forwarded to specific host IPs (`-p [host_ip]:[host_port]:[container_port]`)

Port redirection is essential for:
- Web applications accessible via browser
- Database connections from host applications
- API services exposed to external consumers

## Hands-On Lab: Expose and Redirect Container Ports
In this lab, you'll set up port redirection to access container applications from your host machine.

### Lab Steps
1. **Run a web server container with port mapping**
   ```bash
   docker run -d --name web-server -p 8080:80 nginx
   ```
   This maps your host machine port 8080 to the container's port 80.

2. **Verify the port mapping**
   ```bash
   docker port web-server
   ```
   You should see the port mapping displayed.

3. **Check if container is running**
   ```bash
   docker ps
   ```
   The container should be listed as running.

4. **Access the web server from host**
   - Open web browser and visit: http://localhost:8080
   - You should see the default nginx welcome page

5. **Run container with multiple port mappings**
   ```bash
   docker run -d --name multi-port-app -p 8081:80 -p 8443:443 nginx
   ```
   This maps two different host ports to two different container ports.

6. **Check all port mappings**
   ```bash
   docker port multi-port-app
   ```

7. **Run container with random port assignment**
   ```bash
   docker run -d --name random-port-app -p 80 nginx
   ```
   Docker automatically assigns a random host port for container port 80.

8. **Find the randomly assigned port**
   ```bash
   docker port random-port-app
   ```
   You'll see output like: 80/tcp -> 0.0.0.0:32770

9. **Test the random port**
   - If it shows port 32770, visit: http://localhost:32770
   - You should see the nginx page

10. **Run container with specific host IP binding**
    ```bash
    docker run -d --name ip-bound-app -p 127.0.0.1:9090:80 nginx
    ```
    This binds only to localhost, accessible only from the same machine.

11. **Test IP-bounded container**
    - Visit: http://localhost:9090
    - This should work normally

12. **Clean up containers**
    ```bash
    docker stop web-server multi-port-app random-port-app ip-bound-app
    docker rm web-server multi-port-app random-port-app ip-bound-app
    ```

This lab demonstrates different port mapping techniques, from basic host-to-container mapping to advanced cases like specifying host IPs and random assignments.