# 🩺 Acuvia — AI-Driven Medical Triage Platform

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/FastAPI-Backend-green?logo=fastapi" />
  <img src="https://img.shields.io/badge/Docker-Containerized-blue?logo=docker" />
  <img src="https://img.shields.io/badge/AI-MedGemma_4B-orange" />
  <img src="https://img.shields.io/badge/Status-Production_Ready-success" />
</p>

Acuvia is a production-ready AI-assisted clinical triage ecosystem built using a modern monorepo architecture.

The platform combines a high-performance cross-platform Flutter application with an asynchronous FastAPI backend powered by MedGemma 4B hosted on Google Colab for distributed medical inference.

---

# 📌 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Repository Structure](#-repository-structure)
- [Backend Setup](#-backend-setup-fastapi)
- [Frontend Setup](#-frontend-setup-flutter)
- [Docker & Infrastructure](#-docker--infrastructure)
- [Running the Platform](#-running-the-platform)
- [Troubleshooting](#-troubleshooting--notes)
- [Contributors](#-contributors)
- [License](#-license)

---

# 🚀 Overview

Acuvia enables intelligent AI-assisted patient triage using a distributed cloud inference architecture.

The platform is optimized for:

- Mobile-first healthcare workflows
- Real-time AI diagnostic routing
- Lightweight client deployments
- Cloud-assisted inference processing
- Scalable containerized infrastructure

---

# ✨ Features

- 📱 Cross-platform Flutter mobile application
- ⚡ High-performance FastAPI backend
- 🧠 AI-assisted clinical triage using MedGemma 4B
- ☁️ Distributed inference via Google Colab
- 🐳 Dockerized development environment
- 🌐 Secure ngrok tunneling
- 📍 Geolocation-assisted patient workflows
- 🔄 Real-time backend communication
- 🧩 Modular monorepo architecture

---

# 🛠️ Tech Stack

| Layer | Technology | Libraries / Tools |
|---|---|---|
| Frontend | [Flutter](https://flutter.dev/) / [Dart](https://dart.dev/) | [Riverpod](https://riverpod.dev/), [GoRouter](https://pub.dev/packages/go_router), [Dio](https://pub.dev/packages/dio), [Freezed](https://pub.dev/packages/freezed), [Geolocator](https://pub.dev/packages/geolocator) |
| Backend | [Python](https://www.python.org/) / [FastAPI](https://fastapi.tiangolo.com/) | [Gunicorn](https://gunicorn.org/), [Uvicorn](https://www.uvicorn.org/), [SQLAlchemy](https://www.sqlalchemy.org/), [Pydantic](https://docs.pydantic.dev/), [Loguru](https://loguru.readthedocs.io/) |
| AI / ML | [MedGemma 4B](https://ai.google.dev/gemma) | [PyTorch](https://pytorch.org/), [Google Colab](https://colab.research.google.com/) |
| Infrastructure | [Docker](https://www.docker.com/), [Docker Compose](https://docs.docker.com/compose/) | [Nginx](https://nginx.org/), [ngrok](https://ngrok.com/) |
| Database | PostgreSQL | [Alembic](https://alembic.sqlalchemy.org/) |

---

# 📐 System Architecture

## Distributed AI Inference

Acuvia offloads computationally intensive clinical inference tasks to Google Colab, allowing lightweight mobile deployments while maintaining high-fidelity AI diagnostics.

## Hybrid Infrastructure

The platform operates using a hybrid local-cloud architecture:

- Local Docker containers host backend and database services
- Google Colab hosts the MedGemma 4B inference engine
- ngrok tunnels securely bridge local services to cloud AI pipelines

```text
Flutter Mobile App
        │
        ▼
FastAPI Backend (Docker)
        │
        ▼
ngrok Tunnel
        │
        ▼
Google Colab + MedGemma 4B
```

---

# 📁 Repository Structure

```plaintext
acuvia/
├── backend/                        # FastAPI backend service
│   ├── .venv/
│   ├── alembic.ini
│   ├── Dockerfile
│   ├── poetry.lock
│   ├── pyproject.toml
│   └── app/
│       ├── main.py
│       ├── api/
│       │   └── v1/
│       │       ├── chat.py
│       │       └── triage.py
│       ├── db/
│       │   ├── models.py
│       │   └── session.py
│       └── services/
│
├── frontend/
│   └── acuvia_app/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── data/
│       │   └── features/
│       │       ├── assessment/
│       │       └── locator/
│
└── infra/
    └── nginx/
```

---

# 🐍 Backend Setup (FastAPI)

## 1. Install Dependencies

```bash
cd backend

python -m pip install --upgrade pip setuptools

python -m pip install \
fastapi \
uvicorn[standard] \
sqlalchemy \
psycopg2-binary \
python-jose[cryptography] \
passlib[bcrypt] \
pydantic \
pydantic-settings \
pydantic[email] \
alembic \
email-validator \
joblib \
numpy \
nltk \
pandas \
scikit-learn \
httpx

poetry install
```

---

## 2. Apply Database Migrations

```bash
poetry run alembic upgrade head
```

---

# 📱 Frontend Setup (Flutter)

## 1. Install Packages

```bash
cd frontend/acuvia_app

flutter pub get
```

---

## 2. Generate Code Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

# 🐳 Docker & Infrastructure

Acuvia uses a hybrid infrastructure consisting of:

- Local containerized API/database services
- Remote AI inference hosted on Google Colab

---

## 1. Start Local Services

From the project root:

```bash
cd acuvia

docker compose up --build -d
```

---

## 2. Expose Backend via ngrok

```bash
ngrok http 8000
```

Copy the generated HTTPS URL:

```text
https://xxxx.ngrok-free.app
```

Configure your Google Colab notebook to use this URL as:

```python
BASE_API_URL
```

This allows Colab-hosted MedGemma inference to communicate with your local FastAPI server.

---

# ▶️ Running the Platform

## Step 1 — Launch MedGemma

Start your MedGemma 4B inference notebook in Google Colab.

---

## Step 2 — Start Docker Services

```bash
docker compose up --build -d
```

---

## Step 3 — Open ngrok Tunnel

```bash
ngrok http 8000
```

---

## Step 4 — Run Flutter Application

```bash
cd frontend/acuvia_app

flutter run
```

---

# ⚠️ Troubleshooting & Notes

## Connection Errors

If Colab cannot communicate with your backend:

- Restart ngrok
- Update the ngrok URL inside your Colab notebook
- Verify Docker containers are running

---

## Monitor Backend Logs

```bash
docker compose logs -f
```

Use this to verify incoming AI inference requests and backend processing.

---

## Dependency Synchronization

Whenever `pyproject.toml` changes:

```bash
poetry install
```

This ensures consistent environments across local development and containers.

---

# 👨‍💻 Teammate

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/yourusername">
        <img src="https://github.com/yourusername.png" width="100px;" alt=""/>
        <br />
        <sub><b>Erica Gin Echavez</b></sub>
      </a>
    </td>
  </tr>
   <td align="center">
      <a href="https://github.com/yourusername">
        <img src="https://github.com/yourusername.png" width="100px;" alt=""/>
        <br />
        <sub><b>Janelie Blanco</b></sub>
      </a>
    </td>
   <td align="center">
      <a href="https://github.com/yourusername">
        <img src="https://github.com/yourusername.png" width="100px;" alt=""/>
        <br />
        <sub><b>Francesca Audrey Alaba</b></sub>
      </a>
    </td>
   <td align="center">
      <a href="https://github.com/yourusername">
        <img src="https://github.com/yourusername.png" width="100px;" alt=""/>
        <br />
        <sub><b>Serge Keneth Lim</b></sub>
      </a>
    </td>
</table>

---

# 📄 License

This project is not licensed under the MIT License.

```text
MIT License
```

---

# ❤️ Acknowledgements

Special thanks to the open-source communities behind:

- Flutter
- FastAPI
- Docker
- PyTorch
- Riverpod
- SQLAlchemy
- Huggingface Google
---

<p align="center">
  Built with ❤️ for Software Engineering Course: intelligent healthcare systems
</p>
