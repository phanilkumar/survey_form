# 🐳 Docker Guide for Survey Form Rails Application

This guide will help you run the Rails Survey Form application using Docker and Docker Compose.

## 📋 Prerequisites

1. **Install Docker Desktop**
   - Download from: https://www.docker.com/products/docker-desktop
   - Or use Homebrew: `brew install --cask docker`

2. **Verify Installation**
   ```bash
   docker --version
   docker-compose --version
   ```

## 🚀 Quick Start

### **Option 1: Using Docker Compose (Recommended)**

1. **Navigate to the project directory:**
   ```bash
   cd survey_form
   ```

2. **Build and start all services:**
   ```bash
   docker-compose up --build
   ```

3. **Access the application:**
   - Open your browser and go to: http://localhost:3000
   - API endpoints: http://localhost:3000/api/surveys

4. **Stop the services:**
   ```bash
   docker-compose down
   ```

### **Option 2: Using Docker Commands**

1. **Build the Docker image:**
   ```bash
   docker build -t survey-form-rails .
   ```

2. **Run the container:**
   ```bash
   docker run -p 3000:3000 -v $(pwd):/app survey-form-rails
   ```

3. **Access the application:**
   - Open your browser and go to: http://localhost:3000

## 🛠️ Development with Docker

### **Interactive Development**

1. **Start the services in detached mode:**
   ```bash
   docker-compose up -d
   ```

2. **View logs:**
   ```bash
   docker-compose logs -f web
   ```

3. **Run Rails commands:**
   ```bash
   # Create a new migration
   docker-compose exec web rails generate migration AddNewField

   # Run migrations
   docker-compose exec web rails db:migrate

   # Open Rails console
   docker-compose exec web rails console

   # Run tests
   docker-compose exec web rails test
   ```

### **Database Operations**

```bash
# Reset database
docker-compose exec web rails db:reset

# Seed the database
docker-compose exec web rails db:seed

# View database
docker-compose exec web rails dbconsole
```

## 🧪 Testing with Docker

### **Run All Tests**
```bash
docker-compose exec web rails test
```

### **Run Specific Tests**
```bash
# Run model tests
docker-compose exec web rails test test/models/

# Run controller tests
docker-compose exec web rails test test/controllers/
```

## 📊 Monitoring and Debugging

### **View Container Status**
```bash
docker-compose ps
```

### **View Resource Usage**
```bash
docker stats
```

### **Access Container Shell**
```bash
docker-compose exec web sh
```

### **View Application Logs**
```bash
docker-compose logs web
```

## 🔧 Configuration

### **Environment Variables**

You can customize the application by setting environment variables in `docker-compose.yml`:

```yaml
environment:
  - RAILS_ENV=development
  - DATABASE_URL=sqlite3:/app/db/development.sqlite3
  - RAILS_SERVE_STATIC_FILES=true
```

### **Port Configuration**

To change the port, modify the `ports` section in `docker-compose.yml`:

```yaml
ports:
  - "8080:3000"  # Maps host port 8080 to container port 3000
```

## 🗄️ Database

### **SQLite (Default)**
- Database file: `/app/db/development.sqlite3`
- Persisted in Docker volume: `sqlite_data`

### **PostgreSQL (Optional)**
To use PostgreSQL instead of SQLite:

1. **Update docker-compose.yml:**
   ```yaml
   services:
     db:
       image: postgres:13
       environment:
         POSTGRES_DB: survey_form_development
         POSTGRES_USER: postgres
         POSTGRES_PASSWORD: password
       volumes:
         - postgres_data:/var/lib/postgresql/data
   ```

2. **Update database.yml:**
   ```yaml
   development:
     adapter: postgresql
     database: survey_form_development
     username: postgres
     password: password
     host: db
     port: 5432
   ```

## 🧹 Cleanup

### **Remove Containers and Volumes**
```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: This will delete all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

### **Clean Docker System**
```bash
# Remove unused containers, networks, and images
docker system prune

# Remove everything (WARNING: This will delete all Docker data)
docker system prune -a
```

## 🚨 Troubleshooting

### **Common Issues**

1. **Port Already in Use**
   ```bash
   # Check what's using port 3000
   lsof -i :3000
   
   # Kill the process or change the port in docker-compose.yml
   ```

2. **Permission Issues**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   ```

3. **Database Connection Issues**
   ```bash
   # Recreate the database
   docker-compose exec web rails db:drop db:create db:migrate db:seed
   ```

4. **Bundle Install Issues**
   ```bash
   # Clear bundle cache
   docker-compose exec web bundle clean --force
   docker-compose exec web bundle install
   ```

### **Debug Mode**

To run in debug mode with more verbose output:

```bash
docker-compose up --build --verbose
```

## 📚 Learning Resources

### **Docker Basics**
- [Docker Official Tutorial](https://docs.docker.com/get-started/)
- [Docker Playground](https://labs.play-with-docker.com/)
- [Docker Cheat Sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

### **Docker with Rails**
- [Rails Docker Guide](https://guides.rubyonrails.org/getting_started_with_devcontainer.html)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### **Interactive Learning**
```bash
# Try these commands to learn Docker
docker run hello-world
docker run -it ubuntu bash
docker run -p 8080:80 nginx
docker ps
docker images
```

## 🎯 Next Steps

1. **Learn Docker Compose**: Understand multi-service applications
2. **Explore Docker Networks**: Learn about container communication
3. **Study Docker Volumes**: Understand data persistence
4. **Practice with Different Databases**: Try PostgreSQL, MySQL
5. **Learn Docker Swarm**: For production orchestration
6. **Explore Kubernetes**: For advanced container orchestration

Happy Dockerizing! 🐳✨ 