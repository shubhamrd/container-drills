# Introduction to Docker

## Real World Analogy
Think of Docker like a shipping container. Just as a shipping container allows you to pack all your belongings (clothes, electronics, books) into a single, standardized unit that can be easily transported from one place to another without worrying about the contents getting damaged or mixed up, Docker packages up your application and all its dependencies (libraries, configuration files, etc.) into a single, standardized unit called a "container."

When you ship a container, you can move it from your warehouse to a ship, then to a train, and finally to the destination port - all without having to unpack and repack everything. Similarly, Docker containers can be moved between different machines and environments while keeping everything exactly the same, ensuring your application runs identically regardless of where it's deployed.

## Technical Explanation
Docker is an open-source platform that enables developers to automate the deployment, scaling, and management of applications using containerization technology. Docker containers are lightweight, portable, and consistent environments that encapsulate an application and its dependencies, ensuring that the software runs reliably when moved from one computing environment to another.

A Docker container is created from a Docker image, which is a read-only template with instructions for creating a container. Containers are isolated from each other and from the host system, providing security and consistency. Containers share the host OS kernel but run in their own user space, making them more efficient than traditional virtual machines.

Docker's core components include:
- **Docker Engine**: The runtime that builds, runs, and manages containers
- **Docker Images**: Read-only templates used to create containers
- **Docker Containers**: Runnable instances of Docker images
- **Docker Registry**: A storage and distribution system for Docker images (like Docker Hub)

## Lab Exercise: Docker Installation
In this lab, you'll install Docker on your system and verify the installation was successful.

### Prerequisites
- A Linux-based system (Ubuntu/CentOS recommended)

### Lab Steps
1. **Update System**
   ```bash
   sudo yum -y remove docker*
   ```
   This command updates the system to ensure you have the latest packages and dependencies.

2. **Install Required Dependencies**
   ```bash
   sudo yum install -y yum-utils
   ```
   Install necessary packages for Docker.

3. **Add Docker Repository**
   ```bash
   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   ```
   This adds the Docker repository to your system.

4. **Install Docker Engine**
   ```bash
   sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```
   Install Docker Engine using the added repository.

5. **Start and Enable Docker**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo systemctl status docker
   ```
   Start and enable Docker to ensure it runs on system boot.

6. **Verify Docker Installation**
   ```bash
   docker --version
   ```
   Check the installed Docker version to confirm a successful installation.

7. **Test Docker Installation with Hello World Container**
   ```bash
   docker run hello-world
   ```
   This command downloads a test image and runs it in a container. If successful, you'll see a message confirming that Docker is working correctly.

After completing this lab, you should have a working Docker installation and be able to run your first container.