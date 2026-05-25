# backend/app/api/v1/chat.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List

from app.api.deps import get_db, get_current_user
from app.db import models
from app.services.chatbot import get_medgemma_reply

router = APIRouter()


# ── Schemas (inline — simple enough not to need a separate file) ──────────────
class MessageIn(BaseModel):
    role: str      # "user" or "assistant"
    content: str

class ChatRequest(BaseModel):
    messages: List[MessageIn]   # full conversation history from Flutter

class ChatResponse(BaseModel):
    reply: str


# ── POST /chat ────────────────────────────────────────────────────────────────
@router.post("/chat", response_model=ChatResponse)
async def chat(
    body: ChatRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    if not body.messages:
        raise HTTPException(status_code=400, detail="messages cannot be empty")

    # Convert to plain dicts for the service
    conversation = [{"role": m.role, "content": m.content}
                    for m in body.messages]

    try:
        reply = await get_medgemma_reply(conversation)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"MedGemma error: {e}")

    # Persist both the latest user message and the reply to DB
    last_user = next(
        (m for m in reversed(body.messages) if m.role == "user"), None
    )
    if last_user:
        db.add(models.Chat(
            user_id=current_user.id, role="user", content=last_user.content))
    db.add(models.Chat(
        user_id=current_user.id, role="assistant", content=reply))
    db.commit()

    return ChatResponse(reply=reply)