# 🩺 Acuvia — AI-Driven Medical Triage Platform

<p align="center">
  <img src="https://storage.googleapis.com/cms-storage-bucket/0428ef40da22b6045167.png" alt="Flutter Logo" width="140" style="margin: 10px;"/>
  <img src="https://icon.icepanel.io/Technology/svg/FastAPI.svg" alt="FastAPI Logo" width="100" style="margin: 10px;"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Badge"/>
  <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white" alt="FastAPI Badge"/>
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL Badge"/>
  <img src="https://img.shields.io/badge/scikit_learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white" alt="Scikit-Learn Badge"/>
</p>

Acuvia is a production-ready, clinical triage ecosystem built inside a monorepo workspace. It seamlessly pairs a high-performance cross-platform Flutter mobile client with an asynchronous FastAPI backend service, driven by a hybrid rule-based and machine learning diagnostic routing core.

---

## 📌 Table of Contents
1. [Tech Stack Matrix](#-tech-stack-matrix)
2. [High-Level Architecture](#-high-level-architecture)
3. [Repository Directory Structure](#-repository-directory-structure)
4. [Project Initialization & Prerequisites](#-project-initialization--prerequisites)
5. [Backend Setup (FastAPI)](#-backend-setup-fastapi)
6. [Frontend Setup (Flutter)](#-frontend-setup-flutter)
7. [Docker Setup](#-docker-setup)
8. [Android Emulator Setup](#-android-emulator-setup)
9. [Run Locally](#-run-locally)
10. [Troubleshooting & Notes](#-troubleshooting--notes)
11. [Best Practices & Maintenance Checklist](#-best-practices--maintenance-checklist)

---

## 🛠️ Tech Stack Matrix

| Layer | Technology Component | Primary Libraries / Packages |
| :--- | :--- | :--- |
| **Frontend Mobile Client** | Flutter / Dart | Riverpod, GoRouter, Dio, Freezed, FlutterDotenv, Geolocator |
| **Backend Core Engine** | Python / FastAPI | Gunicorn, Uvicorn, Pydantic, SQLAlchemy, Slowapi, Loguru |
| **Artificial Intelligence** | Hybrid NLP & ML | Scikit-Learn (Random Forest), XGBoost, NLTK, Joblib |
| **Database & Migration** | Relational Ledger | PostgreSQL (`psycopg2-binary`), Alembic |
| **Infrastructure Proxy** | Containers & Networking | Nginx, Docker, Docker Compose |

---

## 📐 High-Level Architecture

*   **12-Factor App Principles:** System environment-driven variables cleanly decouple sensitive access keys and database credentials from logical deployment instances (`.env`).
*   **Dual-Layer Safety Triage Engine:** Implements a strict, deterministic keyword safety pattern for immediate life-threatening emergency symptoms, coupled with a probabilistic Random Forest NLP classifier fallback for standard evaluations.
*   **Explainable Artificial Intelligence (XAI):** Urgency evaluations are made transparent client-side by tracking exact clinical rule executions alongside structural mathematical feature signals extracted from the ML model pipeline.

---

## 📁 Repository Directory Structure

```text
acuvia/                             # Accurate repository structure scanned from workspace
├── .git/                           # Git metadata (not expanded)
├── .gitignore                      # Global file exclusion configurations
├── README.md                       # Central documentation matrix
├── docker-compose.yml              # Docker Compose service definitions
├── hs_err_pid13264.log             # JVM crash log
├── replay_pid13264.log             # Replay log file
├── backend/                        # Python FastAPI backend
│   ├── .env                        # Backend environment variables
│   ├── .venv/                      # Local Python virtual environment
│   ├── alembic.ini                 # Alembic migration config
│   ├── Dockerfile                  # Backend Docker image definition
│   ├── poetry.lock                 # Poetry lockfile
│   ├── pyproject.toml              # Poetry project metadata
│   └── app/
│       ├── __init__.py
│       ├── main.py
│       ├── ai/
│       │   ├── __init__.py
│       │   ├── model.py
│       │   ├── preprocessing.py
│       │   ├── rules.py
│       │   ├── train.py
│       │   └── artifacts/
│       │       ├── rf_model.joblib
│       │       └── vectorizer.joblib
│       ├── api/
│       │   ├── __init__.py
│       │   ├── deps.py
│       │   └── v1/
│       │       ├── __init__.py
│       │       ├── auth.py
│       │       ├── chat.py
│       │       ├── history.py
│       │       └── triage.py
│       ├── core/
│       │   ├── __init__.py
│       │   ├── config.py
│       │   └── security.py
│       ├── db/
│       │   ├── __init__.py
│       │   ├── models.py
│       │   ├── session.py
│       │   └── migrations/
│       │       ├── README
│       │       ├── env.py
│       │       ├── script.py.mako
│       │       └── versions/      # Empty migrations version folder
│       ├── schemas/
│       │   ├── __init__.py
│       │   ├── auth.py
│       │   ├── chat.py
│       │   └── triage.py
│       └── services/
│           ├── __init__.py
│           ├── chatbot.py
│           └── hospitals.py
├── frontend/                       # Flutter app monorepo root
│   └── acuvia_app/
│       ├── .env
│       ├── .gitignore
│       ├── .metadata
│       ├── README.md
│       ├── analysis_options.yaml
│       ├── pubspec.lock
│       ├── pubspec.yaml
│       ├── .flutter-plugins-dependencies
│       ├── android/
│       │   ├── .gitignore
│       │   ├── acuvia_app_android.iml
│       │   ├── build.gradle.kts
│       │   ├── gradle.properties
│       │   ├── gradlew
│       │   ├── gradlew.bat
│       │   ├── local.properties
│       │   ├── settings.gradle.kts
│       │   ├── app/
│       │   │   ├── build.gradle.kts
│       │   │   └── src/
│       │   │       ├── debug/AndroidManifest.xml
│       │   │       ├── main/
│       │   │       │   ├── AndroidManifest.xml
│       │   │       │   ├── java/io/flutter/plugins/GeneratedPluginRegistrant.java
│       │   │       │   └── res/
│       │   │       └── profile/AndroidManifest.xml
│       │   └── gradle/
│       │       └── wrapper/gradle-wrapper.properties
│       ├── assets/
│       ├── build/                    # Generated Flutter artifacts
│       ├── ios/
│       │   ├── .gitignore
│       │   ├── Flutter/
│       │   ├── Runner/
│       │   ├── Runner.xcodeproj/
│       │   ├── Runner.xcworkspace/
│       │   └── RunnerTests/
│       ├── lib/
│       │   ├── app.dart
│       │   ├── main.dart
│       │   ├── auth/
│       │   │   ├── forgot_password_screen.dart
│       │   │   ├── login_screen.dart
│       │   │   └── register_screen.dart
│       │   ├── core/
│       │   │   ├── constants.dart
│       │   │   ├── error_mapper.dart
│       │   │   ├── http_client.dart
│       │   │   ├── router.dart
│       │   │   └── theme.dart
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── chat.dart
│       │   │   │   ├── chat.freezed.dart
│       │   │   │   ├── chat.g.dart
│       │   │   │   ├── hospital.dart
│       │   │   │   ├── hospital.freezed.dart
│       │   │   │   ├── hospital.g.dart
│       │   │   │   ├── triage.dart
│       │   │   │   ├── triage.freezed.dart
│       │   │   │   ├── triage.g.dart
│       │   │   │   ├── user.dart
│       │   │   │   ├── user.freezed.dart
│       │   │   │   └── user.g.dart
│       │   │   └── repositories/
│       │   │       ├── auth_repository.dart
│       │   │       ├── chat_repository.dart
│       │   │       ├── history_repository.dart
│       │   │       ├── locator_repository.dart
│       │   │       └── triage_repository.dart
│       │   ├── features/
│       │   │   ├── assessment/
│       │   │   │   ├── ai_analysis_screen.dart
│       │   │   │   ├── result_screen.dart
│       │   │   │   ├── start_assessment_screen.dart
│       │   │   │   └── symptom_input_screen.dart
│       │   │   ├── chatbot/chatbot_screen.dart
│       │   │   ├── history/history_screen.dart
│       │   │   ├── home/home_screen.dart
│       │   │   ├── learn/
│       │   │   │   ├── learn_data.dart
│       │   │   │   ├── learn_detail_screen.dart
│       │   │   │   └── learn_screen.dart
│       │   │   ├── locator/hospital_locator_screen.dart
│       │   │   ├── profile/profile_screen.dart
│       │   │   └── splash/splash_screen.dart
│       │   └── shared/
│       │       ├── providers/
│       │       │   ├── auth_provider.dart
│       │       │   ├── chat_provider.dart
│       │       │   ├── history_provider.dart
│       │       │   ├── locator_provider.dart
│       │       │   └── triage_provider.dart
│       │       └── widgets/
│       │           ├── acv_button.dart
│       │           ├── acv_card.dart
│       │           ├── acv_error_view.dart
│       │           ├── acv_input.dart
│       │           └── urgency_badge.dart
│       ├── linux/
│       │   └── runner/
│       │       ├── CMakeLists.txt
│       │       ├── my_application.cc
│       │       └── my_application.h
│       ├── macos/
│       │   ├── .gitignore
│       │   ├── Flutter/
│       │   ├── Runner/
│       │   │   ├── AppDelegate.swift
│       │   │   ├── Assets.xcassets/
│       │   │   │   └── AppIcon.appiconset/
│       │   │   │       ├── Contents.json
│       │   │   │       ├── app_icon_16.png
│       │   │   │       ├── app_icon_32.png
│       │   │   │       ├── app_icon_64.png
│       │   │   │       ├── app_icon_128.png
│       │   │   │       ├── app_icon_256.png
│       │   │   │       ├── app_icon_512.png
│       │   │   │       └── app_icon_1024.png
│       │   │   ├── Base.lproj/
│       │   │   ├── Configs/
│       │   │   │   ├── AppInfo.xcconfig
│       │   │   │   ├── Debug.xcconfig
│       │   │   │   ├── Release.xcconfig
│       │   │   │   └── Warnings.xcconfig
│       │   │   ├── DebugProfile.entitlements
│       │   │   ├── Info.plist
│       │   │   ├── MainFlutterWindow.swift
│       │   │   └── Release.entitlements
│       │   ├── Runner.xcodeproj/
│       │   │   ├── project.pbxproj
│       │   │   └── xcshareddata/xcschemes/Runner.xcscheme
│       │   └── Runner.xcworkspace/
│       ├── test/
│       │   └── widget_test.dart
│       ├── web/
│       │   ├── favicon.png
│       │   ├── icons/
│       │   │   ├── Icon-192.png
│       │   │   ├── Icon-512.png
│       │   │   ├── Icon-maskable-192.png
│       │   │   └── Icon-maskable-512.png
│       │   ├── index.html
│       │   └── manifest.json
│       └── windows/
│           ├── .gitignore
│           ├── CMakeLists.txt
│           ├── flutter/
│           └── runner/
│               ├── CMakeLists.txt
│               ├── Runner.rc
│               ├── runner.exe.manifest
│               ├── flutter_window.cpp
│               ├── flutter_window.h
│               ├── main.cpp
│               ├── resource.h
│               ├── utils.cpp
│               ├── utils.h
│               ├── win32_window.cpp
│               └── win32_window.h
└── infra/
    └── nginx/                      # Infrastructure configuration directory
```

---

## 📦 Project Initialization & Prerequisites
Before attempting local builds, verify you have configured your environment matching the foundational tooling below:

**Flutter SDK**: Stable Channel version installed globally.

**Python**: Runtime environment 3.11 or higher.

**Poetry**: Global Python package initialization manager interface.

**PostgreSQL Instance**: Active running container or a native target engine instance.

⚠️ Repository Integrity: Ensure a `.gitignore` file exists at the root folder specifying `__pycache__/` and `*.joblib` to prevent compiled cache and machine-learning model binaries from accidentally polluting your git stream history.

---

## 🐍 Backend Setup (FastAPI)

### 1. Install backend dependencies

```powershell
cd d:\vscode\acuvia\backend
pipx install poetry # alternative: pip install poetry
poetry install
```

### 2. Create or verify backend `.env`

The backend loads settings from `backend/.env`.

Example values already included in this repository:

```env
SECRET_KEY=development-secret-key
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=acuvia
POSTGRES_USER=acuvia
POSTGRES_PASSWORD=acuvia
```

If you use Docker Compose, keep `POSTGRES_HOST=db` in `docker-compose.yml` and let Compose route the backend to the database service.

### 3. Prepare AI system assets

Download NLTK resources and build the ML artifacts used by the triage engine:

```powershell
poetry run python -c "import nltk; nltk.download('wordnet'); nltk.download('omw-1.4'); nltk.download('stopwords')"
poetry run python -m app.ai.train
```

> Make sure `backend/app/ai/artifacts/vectorizer.joblib` and `backend/app/ai/artifacts/rf_model.joblib` are generated successfully.

### 4. Apply database migrations

```powershell
poetry run alembic upgrade head
```

### 5. Run the backend locally

```powershell
poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Local Swagger UI: http://localhost:8000/docs

---

## 📱 Frontend Setup (Flutter)

### 1. Install Flutter packages

```powershell
cd d:\vscode\acuvia\frontend\acuvia_app
flutter pub get
```

### 2. Generate codegen files

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Verify connected devices

```powershell
flutter devices
```

### 4. Run the Flutter app

```powershell
flutter run
```

If you have multiple devices attached, select the target device or pass `-d <device_id>`.

---

## 🐳 Docker Setup

Acuvia includes a `docker-compose.yml` manifest that starts the backend and PostgreSQL database together.

### 1. Build and start Docker services

```powershell
cd d:\vscode\acuvia
docker compose up --build
```

This launches:

- `backend`: FastAPI server on port `8000`
- `db`: PostgreSQL database on port `5432`

### 2. Stop Docker services

```powershell
docker compose down
```

### 3. Running database migrations inside Docker

```powershell
docker compose exec backend poetry run alembic upgrade head
```

### 4. Notes for Docker users

- The backend container reads environment variables from `backend/.env`.
- `POSTGRES_HOST=db` is required inside Docker Compose because the service name is `db`.
- If your local `5432` is already in use, change the mapping in `docker-compose.yml`.

---

## 📱 Android Emulator Setup

For Windows development, the most common target is an Android emulator.

### 1. Verify Flutter environment

```powershell
flutter doctor
```

Install missing Android SDK components and accept licenses if required.

### 2. Accept Android licenses

```powershell
flutter doctor --android-licenses
```

### 3. List available emulators

```powershell
flutter emulators
```

### 4. Launch an emulator

```powershell
flutter emulators --launch <emulator_id>
```

### 5. Run the app on the emulator

```powershell
cd d:\vscode\acuvia\frontend\acuvia_app
flutter run -d emulator-5554
```

If you prefer a physical device, connect it and verify it appears in `flutter devices`.

---

## ▶️ Run Locally

### Backend only

```powershell
cd d:\vscode\acuvia\backend
poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend only

```powershell
cd d:\vscode\acuvia\frontend\acuvia_app
flutter run
```

### Full local dev flow

1. Start PostgreSQL and backend with Docker Compose:
   ```powershell
   cd d:\vscode\acuvia
   docker compose up --build
   ```
2. Start the Flutter app in a separate terminal.
3. Open the backend API docs at http://localhost:8000/docs.

---

## ⚠️ Troubleshooting & Notes

* If the Flutter build fails, run `flutter clean` inside `frontend/acuvia_app` then `flutter pub get` again.
* If the backend cannot connect to PostgreSQL, verify `backend/.env` values and whether Docker Compose is running.
* If model assets are missing, rerun `poetry run python -m app.ai.train`.
* For Windows path issues, use PowerShell or Windows Terminal and wrap paths with quotes when necessary.

---

## 📋 Best Practices & Maintenance Checklist

* Database Schema Evolution: Whenever modifications occur inside backend models (`backend/app/db/models.py`), immediately generate your blueprint change definitions via:

```powershell
cd d:\vscode\acuvia\backend
poetry run alembic revision --autogenerate -m "Your description here"
poetry run alembic upgrade head
```

* Secret Protection: Under no circumstances should raw secure authentication endpoints, JWT signing keys, or database access paths be written plainly into your codebase files. Maintain structural assets dynamically through context environment variables (`backend/.env`).

* Clean Architecture Strictness: Features should remain entirely self-contained. Do not cross-import view states between separate modules directly; proxy cross-boundary interactions cleanly through globally mapped Riverpod data providers.

* Docker Discipline: Keep data under `db_data` volume and never commit generated bins from `backend/app/ai/artifacts`.

* Git hygiene: Add `backend/.env` and `frontend/.env` (if used) to `.gitignore` and avoid committing secrets.
