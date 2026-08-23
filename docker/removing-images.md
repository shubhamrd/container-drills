# Removing Images

## Non-Technical Example
Removing Docker images is like decluttering your closet by getting rid of clothes you no longer wear.

Think of it like:
- **Closet Organization**: Like sorting through your wardrobe and deciding what to keep and what to donate
- **Space Management**: Like freeing up shelf space by removing old, unused clothing
- **Inventory Control**: Like keeping track of your fashion choices and eliminating duplicates
- **Seasonal Clearing**: Like switching from winter coats to summer shirts when the weather changes
- **Financial Management**: Like selling old clothes to make room for new purchases

In wardrobe management:
1. **Assessment**: Look at your clothes and determine what's still useful
2. **Removal Process**: Carefully take out items you don't need
3. **Space Utilization**: Use the freed space for new additions
4. **Maintenance**: Regularly review inventory to keep things organized
5. **Sustainability**: Being mindful about what you keep and dispose of properly

## Technical Description
Docker image removal is a crucial part of container management that helps maintain system cleanliness and optimize storage space. Docker images can take up considerable disk space, especially in development environments with frequent builds and updates.

Key aspects of removing images:
- **Image Identification**: Using `docker images` to list and identify images to remove
- **Dependency Management**: Ensuring no containers are using the image before deletion
- **Force Removal**: Using flags like `-f` to force removal
- **Tagged vs Untagged**: Removal of images with or without specific tags
- **Layer Management**: Docker's image layering system prevents redundant storage

Docker images consist of layers and can be referenced by:
- **Image ID** (long 64-character hexadecimal)
- **Repository:Tag** (like nginx:latest)
- **Digest** (used for content-addressable identification)

## Hands-On Lab: Cleaning Up Docker Images
In this lab, you'll practice different approaches to remove Docker images safely.

### Lab Steps
1. **List current images**
   ```bash
   docker images
   ```
   This shows all locally stored images with their repository, tag, image ID, and size.

2. **Identify images to remove**
   ```bash
   # Look for:
   # - Images with "<none>" as repository (dangling images)
   # - Unused development images
   # - Older version tags (like v1.0, v2.0)
   ```

3. **Remove a specific image**
   ```bash
   docker rmi nginx:latest
   ```
   This removes the nginx image with the latest tag.

4. **Force remove an image (even if used)**
   ```bash
   docker rmi -f nginx:latest
   ```
   The `-f` flag forces removal even if it's being used by running containers.

5. **Remove dangling images (images with <none> as repository)**
   ```bash
   docker image prune
   ```
   This removes all dangling images.

6. **Remove all unused images**
   ```bash
   docker image prune -a
   ```
   This removes all images not used by any container.

7. **Remove images by filter**
   ```bash
   docker images -f "dangling=true" -q
   ```
   This gives IDs of all dangling images for targeted removal.

8. **Remove specific images using ID**
   ```bash
   docker rmi <image-id>
   ```
   Replace `<image-id>` with the actual ID from docker images command.

9. **Clean up containers before image removal**
   ```bash
   docker container prune
   ```
   This removes all stopped containers, making it easier to remove images.

10. **View disk usage**
    ```bash
    docker system df
    ```
    This shows disk usage statistics including images, containers, and volumes.

11. **Clean everything (images, containers, volumes)**
    ```bash
    docker system prune -a
    ```
    **Warning**: This removes everything not in use and should be used cautiously.

This lab teaches safe practices for managing Docker images and reclaiming disk space, essential for maintaining an efficient development environment.