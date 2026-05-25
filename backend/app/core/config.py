from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Acuvia"
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str
    MEDGEMMA_URL: str = ""
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24
    POSTGRES_HOST: str = "localhost"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "acuvia"
    POSTGRES_USER: str = "acuvia"
    POSTGRES_PASSWORD: str = "acuvia"
    CORS_ORIGINS: list[str] = [
        "http://localhost:8000",
        "http://localhost:3000",
        "http://localhost:5173",
        "http://127.0.0.1:8000",    # iOS Simulator
        "http://10.0.2.2:8000",     # Android Emulator
    ]
    ENV: str = "dev"

    class Config:
        env_file = ".env"

settings = Settings()