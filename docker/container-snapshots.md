# Container Snapshots

## Real World Analogy
Taking container snapshots is like taking a photo of your room at a specific moment in time.

Imagine you:
1. Start with a clean room (base container)
2. Add furniture, decorations, and personal items (modify the container)
3. When you're happy with the arrangement, you take a photo (snapshot)
4. Later, you can:
   - Show your friend the exact arrangement (share the snapshot)
   - Return to that exact moment if something gets messy (rollback)
   - Create a new version with slight changes (save a new photo)
   - Use that snapshot to recreate the perfect room anywhere (recreate container)

In Docker, a container snapshot is more accurately called a "commit" - it captures the current state of a running container and creates a new image from it. 

Unlike a simple photo, this "snapshot" becomes an immutable template that represents your exact container configuration.

## Technical Explanation
Container snapshots in Docker are created using the `docker commit` command, which takes an existing running container and converts it into a new Docker image. This creates a new image with all the modifications from the container's filesystem at the time of the commit.

Key aspects of container snapshots:
- **Immutable Images**: Unlike container filesystems which are temporary, committed images become persistent Docker images
- **Filesystem State Capture**: The entire filesystem state of the container is preserved
- **Layer Addition**: The committed state becomes a new top layer on the image
- **Repository Storage**: Images committed this way can be pushed to registries
- **Use Cases**: Quick prototyping, bug fixes, temporary changes requiring permanence

Snapshotting is sometimes confused with container checkpoints or Docker's built-in image rebuilding, but it's specifically about capturing a running container's state as a new image. The typical use case is when you made manual changes to a container that you want to preserve as a reusable image.

## Lab Exercise: Create Container Snapshots (Commits)
In this lab, you'll explore how to create and use container snapshots.

### Lab Steps
1. **Run a base container**
   ```bash
   docker run -d --name snapshot-test ubuntu:latest sleep 3600
   ```
   This starts an Ubuntu container that sleeps indefinitely.

2. **Get into the running container**
   ```bash
   docker exec -it snapshot-test bash
   ```

3. **Make some changes in the container**
   ```bash
   # Create a test file
   echo "This is a snapshot test file" > /test-file.txt
   # Update package list
   apt-get update
   # Install a utility (this is just for demonstration)
   apt-get install -y vim
   ```

4. **Exit the container**
   ```bash
   exit
   ```

5. **Take a snapshot (commit) of the container**
   ```bash
   docker commit snapshot-test my-custom-snapshot:latest
   ```
   This creates a new image "my-custom-snapshot:latest" based on the container's current state.

6. **Verify the new image was created**
   ```bash
   docker images | grep my-custom-snapshot
   ```

7. **Run a new container from your snapshot**
   ```bash
   docker run -it my-custom-snapshot:latest bash
   ```

8. **Verify your changes exist in the new container**
   ```bash
   ls /test-file.txt
   cat /test-file.txt
   which vim
   ```

9. **Exit the new container**
   ```bash
   exit
   ```

10. **Tag the snapshot with a more specific name**
    ```bash
    docker tag my-custom-snapshot:latest my-custom-snapshot:v1.0
    ```

11. **Create another snapshot with different modifications**
    ```bash
    docker start snapshot-test
    docker exec -it snapshot-test bash
    
    # Make some additional changes
    echo "Another modification" >> /test-file.txt
    apt-get install -y curl
    
    exit
    ```

12. **Create a second snapshot**
    ```bash
    docker commit snapshot-test my-custom-snapshot:v1.1
    ```

13. **Compare the image tags**
    ```bash
    docker images | grep my-custom-snapshot
    ```

14. **Clean up**
    ```bash
    docker stop snapshot-test
    docker rm snapshot-test
    docker rmi my-custom-snapshot:latest my-custom-snapshot:v1.0 my-custom-snapshot:v1.1
    ```

This lab demonstrates the fundamental concept of container snapshots using `docker commit`, showing how to capture container states and reuse them as new base images.