# Acuvia — AI Medical Triage (clean)

Lightweight monorepo with a FastAPI backend and a Flutter frontend.

Core directories
- `backend/` — FastAPI server, ML pipeline (Medgemma), DB migrations
- `frontend/acuvia_app/` — Flutter mobile app
- `infra/` — infra configs (NGINX, etc.)

Prerequisites
- Docker & Docker Compose (recommended)
- Flutter SDK (for frontend local dev)
- Python 3.11+ and Poetry (for backend local dev)

Quick start (Docker)

From repo root:

```bash
docker compose up --build
```

This starts the backend (port 8000) and Postgres (5432). Use `docker compose down` to stop.

Frontend — local dev (terminal)

Open a new terminal and run:

```bash
cd frontend/acuvia_app
flutter pub get
flutter run
```

Backend — local dev (optional)

If you prefer running the backend locally without Docker:

```powershell
cd backend
pipx install poetry
poetry install
poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

AI (Medgemma) — train, Colab & ngrok

- Model name: **Medgemma** (Random-Forest-based pipeline). Artifacts live in `backend/app/ai/artifacts/` (e.g. `vectorizer.joblib`, `rf_model.joblib`).
- To build artifacts locally:

```powershell
poetry run python -c "import nltk; nltk.download('wordnet'); nltk.download('omw-1.4'); nltk.download('stopwords')"
poetry run python -m app.ai.train
```

- Google Colab: you can run the training notebook in Colab (mount the repo or copy the relevant cells). After training, download the resulting `joblib` artifacts and place them in `backend/app/ai/artifacts/` or store them in cloud storage.
- ngrok: for quick external testing of a local/Colab server, start an ngrok tunnel to your backend's port (example):

```bash
ngrok http 8000
```

Notes
- Use `POSTGRES_HOST=db` in `backend/.env` when running with Docker Compose.
- Keep `backend/.env` and any secret files out of git; add them to `.gitignore`.

Want changes?
- I can commit this file and push to `main`, or create a Colab notebook scaffold for Medgemma training. Tell me which you'd like.

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

##  Frontend Setup (Flutter)

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

##  Docker Setup

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

##  Android Emulator Setup

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

##  Run Locally

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

##  Troubleshooting & Notes

* If the Flutter build fails, run `flutter clean` inside `frontend/acuvia_app` then `flutter pub get` again.
* If the backend cannot connect to PostgreSQL, verify `backend/.env` values and whether Docker Compose is running.
* If model assets are missing, rerun `poetry run python -m app.ai.train`.
* For Windows path issues, use PowerShell or Windows Terminal and wrap paths with quotes when necessary.

---

##  Best Practices & Maintenance Checklist

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

