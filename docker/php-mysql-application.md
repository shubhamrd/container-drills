# PHP Application with MySQL

## Real World Analogy
A PHP application with MySQL is like setting up a restaurant kitchen with both cooking equipment and food storage.

Think of it like:
- **Kitchen Infrastructure**: Like having ovens, stoves, prep areas, and serving stations
- **Storage and Inventory**: Like having refrigerators, dry storage areas, and pantry spaces
- **Workflow Coordination**: Like coordinating between chefs, prep cooks, and serving staff
- **Quality Control**: Like checking that ingredients are fresh and recipes are followed exactly
- **Maintenance Schedule**: Like regularly checking and servicing kitchen equipment

In restaurant operations:
1. **Integrated Systems**: All components work together to prepare and serve meals
2. **Data Management**: Menu items and inventory tracked in both kitchen and management systems
3. **Real-Time Coordination**: Orders flow smoothly from ordering to serving
4. **Quality Standards**: Consistent dishes prepared according to recipe standards
5. **System Reliability**: Kitchen stays functional during peak hours

## Technical Explanation
A PHP application with MySQL represents a classic web development architecture where PHP handles server-side logic and MySQL manages data storage. This combination is widely used due to:
- **PHP's Web-Friendly Nature**: Designed specifically for web applications with built-in HTTP support
- **MySQL's Reliability**: Well-tested relational database with excellent performance
- **Easy Deployment**: Simple setup and configuration for development and production
- **Scalability Options**: Can grow from simple scripts to complex enterprise applications
- **Large Ecosystem**: Extensive PHP libraries and MySQL extensions available

This architecture handles:
- **Data Processing**: PHP scripts generate dynamic web pages, process forms, and handle business logic
- **Data Storage**: MySQL databases store user information, content, transactions, and application data
- **Server Communication**: PHP communicates with MySQL to retrieve and update information
- **Web Interface**: User-facing applications through HTML forms and responsive layouts
- **Security Implementation**: User authentication, data validation, and access controls

## Lab Exercise: PHP MySQL Application Setup
In this lab, you'll create a complete PHP and MySQL web application using Docker Compose.

### Lab Steps
1. **Create lab directory**
   ```bash
   mkdir php-mysql-lab
   cd php-mysql-lab
   ```

2. **Create docker-compose.yml**
   ```yaml
   version: '3.8'
   services:
     # MySQL database
     db:
       image: mysql:8.0
       environment:
         MYSQL_ROOT_PASSWORD: rootpassword
         MYSQL_DATABASE: phpapp
         MYSQL_USER: phpuser
         MYSQL_PASSWORD: phppassword
       volumes:
         - db_data:/var/lib/mysql
         - ./sql/init.sql:/docker-entrypoint-initdb.d/init.sql
       networks:
         - app-network
         
     # PHP application with Apache
     web:
       image: php:8.1-apache
       depends_on:
         - db
       volumes:
         - ./www:/var/www/html
         - ./php.ini:/usr/local/etc/php/php.ini
       ports:
         - "8080:80"
       networks:
         - app-network
         
     # PHPMyAdmin for database management (optional)
     phpmyadmin:
       image: phpmyadmin/phpmyadmin
       depends_on:
         - db
       environment:
         PMA_HOST: db
         PMA_PORT: 3306
         PMA_USER: phpuser
         PMA_PASSWORD: phppassword
       ports:
         - "8081:80"
       networks:
         - app-network
       
   networks:
     app-network:
       driver: bridge
       
   volumes:
     db_data:
   ```

3. **Create database initialization script**
   ```bash
   mkdir -p sql
   cat > sql/init.sql << 'EOF'
   CREATE TABLE IF NOT EXISTS users (
       id INT AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       email VARCHAR(100) UNIQUE NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   
   INSERT INTO users (name, email) VALUES
   ('John Doe', 'john@example.com'),
   ('Jane Smith', 'jane@example.com'),
   ('Bob Johnson', 'bob@example.com');
   EOF
   ```

4. **Create PHP application files**
   ```bash
   mkdir -p www
   ```

5. **Create database connection file**
   ```bash
   cat > www/config.php << 'EOF'
   <?php
   $host = 'db';
   $dbname = 'phpapp';
   $username = 'phpuser';
   $password = 'phppassword';
   
   try {
       $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
       $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
   } catch(PDOException $e) {
       die("Connection failed: " . $e->getMessage());
   }
   ?>
   EOF
   ```

6. **Create main application page**
   ```bash
   cat > www/index.php << 'EOF'
   <!DOCTYPE html>
   <html>
   <head>
       <title>PHP MySQL Demo</title>
       <style>
           body { font-family: Arial, sans-serif; margin: 20px; }
           table { border-collapse: collapse; width: 100%; }
           th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
           th { background-color: #f2f2f2; }
           .form-group { margin-bottom: 15px; }
           input[type=text], input[type=email] { width: 250px; padding: 5px; }
           input[type=submit] { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; }
           input[type=submit]:hover { background-color: #45a049; }
       </style>
   </head>
   <body>
       <h1>PHP MySQL Demo Application</h1>
       
       <h2>Users in Database</h2>
       <?php
       include 'config.php';
       
       try {
           $stmt = $pdo->query("SELECT * FROM users ORDER BY created_at DESC");
           $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
           
           if (count($users) > 0) {
               echo '<table>';
               echo '<tr><th>ID</th><th>Name</th><th>Email</th><th>Created At</th></tr>';
               foreach ($users as $user) {
                   echo '<tr>';
                   echo '<td>' . htmlspecialchars($user['id']) . '</td>';
                   echo '<td>' . htmlspecialchars($user['name']) . '</td>';
                   echo '<td>' . htmlspecialchars($user['email']) . '</td>';
                   echo '<td>' . htmlspecialchars($user['created_at']) . '</td>';
                   echo '</tr>';
               }
               echo '</table>';
           } else {
               echo '<p>No users found.</p>';
           }
       } catch(PDOException $e) {
           echo '<p>Error retrieving users: ' . $e->getMessage() . '</p>';
       }
       ?>
       
       <h2>Add New User</h2>
       <form method="POST" action="add_user.php">
           <div class="form-group">
               <label>Name:</label><br>
               <input type="text" name="name" required>
           </div>
           <div class="form-group">
               <label>Email:</label><br>
               <input type="email" name="email" required>
           </div>
           <input type="submit" value="Add User">
       </form>
   </body>
   </html>
   EOF
   ```

7. **Create user addition script**
   ```bash
   cat > www/add_user.php << 'EOF'
   <?php
   include 'config.php';
   
   if ($_SERVER['REQUEST_METHOD'] === 'POST') {
       $name = trim($_POST['name']);
       $email = trim($_POST['email']);
       
       try {
           $stmt = $pdo->prepare("INSERT INTO users (name, email) VALUES (?, ?)");
           $stmt->execute([$name, $email]);
           
           echo "<h2>User Added Successfully!</h2>";
           echo "<p>Name: " . htmlspecialchars($name) . "</p>";
           echo "<p>Email: " . htmlspecialchars($email) . "</p>";
           echo '<a href="index.php">Back to Users List</a>';
       } catch(PDOException $e) {
           echo "<h2>Error Adding User</h2>";
           echo "<p>Error: " . $e->getMessage() . "</p>";
           echo '<a href="index.php">Back to Users List</a>';
       }
   } else {
       header("Location: index.php");
   }
   ?>
   EOF
   ```

8. **Create PHP configuration**
   ```bash
   cat > php.ini << 'EOF'
   memory_limit = 256M
   upload_max_filesize = 64M
   post_max_size = 64M
   max_execution_time = 300
   error_log = /var/log/php_errors.log
   log_errors = On
   display_errors = Off
   EOF
   ```

9. **Start the application**
   ```bash
   docker-compose up -d
   ```

10. **Test the application**
    ```bash
    # Wait for containers to be ready
    sleep 5
    
    # Check if application is working
    curl http://localhost:8080
    ```

11. **Access the application**
    - Main application: http://localhost:8080
    - PHPMyAdmin: http://localhost:8081 (login with user: phpuser, password: phppassword)

12. **Try adding a user through the web form**
    - Navigate to http://localhost:8080
    - Fill in name and email in the form at the bottom
    - Submit to add a user to the database

13. **Verify database integration**
    ```bash
    # Connect to database and check users
    docker-compose exec db mysql -u phpuser -p phppassword -e "SELECT * FROM phpapp.users;"
    ```

14. **Clean up**
    ```bash
    docker-compose down -v
    cd ..
    rm -rf php-mysql-lab
    ```

This lab provides a comprehensive example of a complete PHP MySQL web application running in containers, demonstrating real-world integration of both technologies.