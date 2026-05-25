# backend/app/api/v1/auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.db import models
from app.core.security import get_password_hash, verify_password, create_access_token
from app.schemas.auth import LoginInput, RegisterInput, Token

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=Token)
def register(payload: RegisterInput, db: Session = Depends(get_db)):
    # Check if email already exists
    existing = db.query(models.User).filter(
        models.User.email == payload.email
    ).first()
    if existing:
        raise HTTPException(
            status_code=400,
            detail="Email already registered",
        )

    # Create and save new user
    try:
        hashed = get_password_hash(payload.password)
    except ValueError as exc:
        # e.g. password too long for bcrypt (72 bytes)
        raise HTTPException(status_code=400, detail=str(exc))

    user = models.User(
        email=payload.email,
        hashed_password=hashed,
        full_name=payload.full_name,
    )
    db.add(user)
    db.commit()
    db.refresh(user)  # populate user.id after insert

    token = create_access_token(subject=user.email)
    return Token(access_token=token)


@router.post("/login", response_model=Token)
def login(payload: LoginInput, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(
        models.User.email == payload.email
    ).first()

    if not user or not verify_password(payload.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
        )

    token = create_access_token(subject=user.email)
    return Token(access_token=token)