# 🚀 Deploying Django to AWS ECS with Terraform

This project is a Django application containerized with Docker and ready for deployment to AWS ECS using Terraform.

---

## 🧪 Build & Run the Project Locally

Follow these steps to set up and run the project on your local machine.

---

### 1️⃣ Clone the Repository

```bash
git clone git@github.com:aadarsha000/django-ecs-terraform.git
cd django-ecs-terraform/backend
```

---

### 2️⃣ Create `.env` File

Create a `.env` file in the `backend` directory based on the provided example:

```bash
cp .env.example .env
```

Edit `.env` and set your environment variables as needed.

---

### 3️⃣ Build Docker Containers

```bash
docker-compose build
```

---

### 4️⃣ Run the Containers

```bash
docker-compose up
```

---

### ✅ Access the App

Open your browser and visit:

[http://localhost:8000](http://localhost:8000)

---

## 📦 Deployment to AWS ECS

> **Note:** This project is set up for infrastructure provisioning and deployment via Terraform.

Refer to the `terraform/` directory for configuration files and instructions on deploying to AWS ECS.

---

## 📄 License

This project is licensed under the MIT License.
