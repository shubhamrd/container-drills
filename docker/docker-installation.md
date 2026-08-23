# Docker Installation

## Non-Technical Example
Installing Docker is like setting up a new kitchen appliance - it's similar to installing any complex software, but it's quite straightforward once you follow the proper steps.

Think of Docker as a sophisticated appliance that cooks your applications in special containers. Just like you need to:

1. Check that your kitchen (computer) is suitable for the new appliance
2. Prepare the installation (turn off power, check connections)
3. Follow step-by-step instructions (install, configure, test)
4. Test that it works correctly (run a simple recipe)

Similarly, installing Docker involves:
1. Making sure your Linux system is compatible
2. Installing necessary packages and dependencies
3. Setting up Docker repository 
4. Installing the Docker engine
5. Starting and enabling the service for automatic startup
6. Testing that everything works correctly

## Technical Description
Docker Installation follows a standardized process that varies slightly depending on your Linux distribution. The general process involves:

1. **Prerequisites**: Your system should have a supported kernel version (Linux kernel 3.10 or higher)
2. **Repository Setup**: Adding the official Docker repository to get the latest updates 
3. **Package Installation**: Installing the Docker Engine, CLI, containerd, and Docker Compose plugin
4. **Service Management**: Enabling and starting the Docker daemon for automatic startup
5. **Post-installation**: Adding your user to the docker group to run commands without sudo

Docker installation requires proper system requirements and careful dependency management. It's important to use official repositories and follow the documented installation procedure to avoid conflicts.

## Hands-On Lab: Complete Docker Installation Process
In this comprehensive lab, you'll install Docker from scratch following industry-standard procedures.

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

7. **Test Installation with Hello World**
   ```bash
   docker run hello-world
   ```
   Run a simple container to ensure the installation works as expected. You should see a message confirming Docker is working correctly.

8. **Add user to docker group (optional but recommended)**
   ```bash
   sudo usermod -aG docker $USER
   ```
   This allows you to run Docker commands without `sudo` (requires logout/login to take effect).

9. **Restart your session (if you added to group)**
   - Logout and login, or
   - Run: `newgrp docker`

10. **Verify that you can run Docker without sudo**
   ```bash
   docker run hello-world
   ```
   If you don't get a permission error, you've successfully added yourself to the docker group.

This comprehensive lab covers all aspects of Docker installation, from preparation through verification, ensuring you have a working Docker environment for your training exercises.