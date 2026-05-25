# backend/app/services/chatbot.py
import httpx
from app.core.config import settings

SYSTEM_PROMPT = """You are Acuvia Assistant, a medical triage chatbot in a mobile health app.
Your role is to:
- Ask about the patient's symptoms in a clear, empathetic way
- Help them understand the urgency of their condition
- Guide them on next steps (home care, clinic visit, or emergency)

Rules:
- Never diagnose. Always remind the user you are not a doctor.
- If symptoms sound life-threatening (chest pain + sweating, stroke signs, severe breathing), 
  immediately tell them to call emergency services.
- Keep replies concise — 2 to 4 sentences max.
- Always respond in the same language the patient used.
- End with a follow-up question to gather more detail when needed."""


async def get_medgemma_reply(conversation: list[dict]) -> str:
    """
    Sends the full conversation history to MedGemma via ngrok tunnel.
    `conversation` is a list of {"role": "user"/"assistant", "content": "..."} dicts.
    """
    # Build the prompt: system prompt prepended to the first user message
    messages = []
    for i, msg in enumerate(conversation):
        if i == 0 and msg["role"] == "user":
            messages.append({
                "role": "user",
                "content": SYSTEM_PROMPT + "\n\n" + msg["content"],
            })
        else:
            messages.append(msg)

    payload = {"messages": messages}

    async with httpx.AsyncClient(timeout=60.0) as client:
        resp = await client.post(
            f"{settings.MEDGEMMA_URL}/chat",
            json=payload,
        )
        resp.raise_for_status()
        data = resp.json()
        return data.get("reply", "Sorry, I could not generate a response.")