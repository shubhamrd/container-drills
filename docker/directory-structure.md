# Understand Directory Structure

## Non-Technical Example
Understanding Docker directory structure is like learning how to read a map of a well-organized library.

Think of it like:
- **Library Cataloging**: Like how books are organized by subject, author, and shelf location
- **Shelf Labeling**: Like having clear labels on storage areas so you know exactly where things belong
- **Access Control**: Like having restricted areas for special collections versus public sections
- **Inventory System**: Like maintaining a catalog of what books are available and where they are
- **Maintenance Areas**: Like having designated spaces for cleaning, restocking, and organization

In library management:
1. **Section Locations**: Understanding where different categories of books are stored
2. **Catalog Records**: Knowing exactly what's available and accessible
3. **Organizational Flow**: Following logical pathways from general to specific areas
4. **Storage Capacity**: Recognizing how much space is available for different materials
5. **Maintenance Protocols**: Knowing which areas require special care or regular attention

## Technical Description
The directory structure in Docker relates to how containerized applications manage file systems and data. Understanding Docker's filesystem structure helps with:
- Volume management and data persistence
- File permissions and access control
- Application deployment and configuration
- Troubleshooting container issues
- Secure containerization practices

**Key Docker Directory Components:**
- **Root Filesystem**: The base filesystem for containers (root directory /)
- **Layered Filesystem**: How Docker combines base images with additional layers
- **Overlay Filesystem**: Mounting strategies for union file systems
- **Volume Mounts**: External storage access points
- **Bind Mounts**: Direct access bindings from host to container
- **Tmpfs Mounts**: Memory-based temporary storage

**Common Container Directory Paths:**
- **/etc/**: Configuration files and system settings
- **/var/**: Variable data like logs and runtime data
- **/opt/**: Optional application packages
- **/tmp/**: Temporary files (often not persistent)
- **/usr/**: User utilities and applications
- **/home/**: User home directories

## Hands-On Lab: Explore Docker Filesystem Structure
In this lab, you'll examine the directory structure of Docker containers.

### Lab Steps
1. **Create a container with directory exploration**
   ```bash
   docker run -it ubuntu:latest bash
   ```
   This starts an interactive Ubuntu container.

2. **Examine root filesystem**
   ```bash
   # Inside the container:
   ls /
   # You'll see standard Unix directories like bin, etc, home, lib, proc, sys, tmp, usr, var
   ```

3. **Check specific directories**
   ```bash
   # Show directory contents
   ls -la /etc/
   ls -la /var/
   ls -la /tmp/
   ```

4. **Understand mounting points**
   ```bash
   # Check mounted filesystems 
   mount | grep -E "(tmpfs|/dev)"
   ```

5. **Create and explore custom directories**
   ```bash
   mkdir /app
   mkdir /app/data
   touch /app/data/test.txt
   echo "test data" > /app/data/test.txt
   ```

6. **Verify file structure**
   ```bash
   ls -la /app/
   cat /app/data/test.txt
   ```

7. **Check Docker's layered structure**
   ```bash
   # From host, check image layers
   docker inspect ubuntu:latest | grep -A 10 -B 5 "RootFS"
   ```

8. **Examine volume behavior**
   ```bash
   # Create a container with a volume
   docker run -d --name vol-test -v /data ubuntu:latest sleep 3600
   
   # Check volume location  
   docker inspect vol-test | grep -A 10 -B 5 "Mounts"
   ```

9. **Explore different filesystem paths**
   ```bash
   # Inside container:
   df -h  # Show disk space
   pwd      # Current directory
   whoami   # Current user
   ```

10. **Exit container**
    ```bash
    exit
    ```

11. **Clean up test container**
    ```bash
    docker rm -f vol-test
    ```

This lab helps understand how Docker containers organize their filesystem, which is crucial for proper volume management and application deployment.