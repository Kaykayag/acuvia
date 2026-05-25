# backend/app/db/models.py
from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey, JSON, Enum, Index
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.session import Base
import enum

# ── Enums ─────────────────────────────────────────────────────────────────────
class Urgency(str, enum.Enum):
    emergency = "Emergency"
    urgent    = "Urgent"
    non_urgent = "Non-Urgent"

# ── User ──────────────────────────────────────────────────────────────────────
class User(Base):
    __tablename__ = "users"
    id              = Column(Integer, primary_key=True, index=True)
    email           = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    full_name       = Column(String(255), nullable=True)
    created_at      = Column(DateTime(timezone=True), server_default=func.now())

    assessments = relationship("Assessment", back_populates="user")
    chats       = relationship("Chat", back_populates="user")

# ── Assessment ────────────────────────────────────────────────────────────────
class Assessment(Base):
    __tablename__ = "assessments"
    id         = Column(Integer, primary_key=True, index=True)
    user_id    = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    # input
    symptoms   = Column(JSON, nullable=False)
    free_text  = Column(Text, nullable=True)
    age        = Column(Integer, nullable=True)
    sex        = Column(String(16), nullable=True)
    conditions = Column(JSON, nullable=True)

    # output
    priority   = Column(String(32), nullable=False)
    tagline    = Column(String(128), nullable=True)
    reason     = Column(Text, nullable=True)
    next_steps = Column(JSON, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    user       = relationship("User", back_populates="assessments")

# ── Chat ──────────────────────────────────────────────────────────────────────
class Chat(Base):
    __tablename__ = "chats"
    id         = Column(Integer, primary_key=True, index=True)
    user_id    = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    role       = Column(String(16), nullable=False)   # 'user' | 'assistant'
    content    = Column(Text, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    user = relationship("User", back_populates="chats")

# ── Hospital ──────────────────────────────────────────────────────────────────
class Hospital(Base):
    __tablename__ = "hospitals"
    id      = Column(Integer, primary_key=True, index=True)
    name    = Column(String(255), nullable=False)
    address = Column(String(512), nullable=True)
    lat     = Column(String(64), nullable=True)
    lon     = Column(String(64), nullable=True)
    phone   = Column(String(64), nullable=True)

# ── Indexes ───────────────────────────────────────────────────────────────────
Index("ix_assessments_user_id_created_at", Assessment.user_id, Assessment.created_at.desc())
Index("ix_chats_user_id_created_at", Chat.user_id, Chat.created_at.desc())