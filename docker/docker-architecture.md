# Docker Architecture

## Non-Technical Example
Think of Docker like a restaurant kitchen:

- The **Docker Engine** is like the main kitchen where everything happens. It's the heart of the operation.
- The **Docker Daemon** is like the kitchen manager who coordinates all the activities in the kitchen and keeps track of what's happening, where ingredients are stored, and how orders are processed.
- The **Docker Client** is like your waiter who takes the order and communicates with the kitchen manager.
- The **Docker Images** are like recipe cards. They describe how to prepare food (an application) and list what ingredients (dependencies) are needed.
- The **Docker Containers** are like the prepared food served to customers. They are instances of images that are currently running.
- The **Registry** is like a cookbook library where restaurants can browse and borrow recipes (images) from other establishments or add their own new recipe cards.

When you want to order dinner, your waiter (client) tells the kitchen manager (daemon) about what you want. The kitchen manager finds the recipe card (image) in the library, prepares the meal following the recipe (creates the container with runtime parameters), and serves it to you.

## Technical Description
Docker architecture consists of several interrelated components that work together to enable containerization:

**Docker Engine:**
The core component of Docker that manages containers, images, networks, and volumes. It's composed of:
- Docker Daemon (dockerd): A server that manages Docker objects (images, containers, networks, volumes)
- Docker Client (docker): CLI tool that communicates with the daemon to manage Docker resources
- REST API: Interface that exposes Docker functionality to clients

**Docker Images:**
Read-only templates that contain instructions for creating containers. Images are built from a series of layers, with each layer representing an instruction of the Dockerfile. Layers are cached for efficiency and reduce storage overhead.

**Docker Containers:**
Runnable instances of Docker images. A container is a lightweight, standalone, and executable package that includes everything needed to run an application, including code, runtime, system tools, libraries, and settings.

**Docker Registry:**
Storage and distribution system for Docker images. The most popular public registry is Docker Hub, but organizations can set up private registries. Registries store and manage tagged images.

**Networks and Volumes:**
Docker provides built-in networking capabilities for containers to communicate and storage mechanisms for persistent data.

## Hands-On Lab: Understanding Docker Architecture Components
In this exercise, you'll examine the architecture by inspecting Docker components.

### Lab Steps
1. **Check Docker version and info**
   ```bash
   docker version
   docker info
   ```
   These commands provide information about both the client and server components.

2. **View Docker daemon logs** (may require elevated privileges)
   ```bash
   journalctl -u docker.service
   ```
   This command displays system logs related to Docker daemon execution.

3. **Explore the Docker image structure**
   First, pull an image:
   ```bash
   docker pull nginx
   ```
   
   Then inspect the image layers:
   ```bash
   docker inspect nginx
   ```
   Look for the "RootFS" section to see the layered structure of the image.

4. **Create a simple container and inspect its structure**
   ```bash
   docker run -d --name test-nginx nginx
   docker inspect test-nginx
   ```
   This will show detailed information about your running container, including its network configuration, mounts, and process details.

5. **Cleanup**
   ```bash
   docker rm -f test-nginx
   ```

6. **List Docker images**
   ```bash
   docker images
   ```
   This lists all images available locally, showing their repository, tag, image ID, and size.

7. **Verify Docker is running properly**
   ```bash
   docker run hello-world
   ```
   This runs a simple test container that confirms the Docker installation is functioning correctly.

This lab gives you a practical understanding of how Docker's components interact in a real environment.