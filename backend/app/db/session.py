# backend/app/db/session.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.core.config import settings

# Construct the database URL from settings so the same config is used
# both in development and inside Docker containers.
DATABASE_URL = (
	f"postgresql://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}"
	f"@{settings.POSTGRES_HOST}:{settings.POSTGRES_PORT}/{settings.POSTGRES_DB}"
)

engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
