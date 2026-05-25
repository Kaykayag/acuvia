import httpx
from app.core.config import settings

async def run_triage_remote(
    symptoms: list,
    free_text: str,
    age: int,
    sex: str,
    conditions: list,
) -> dict:
    payload = {
        "symptoms"  : symptoms,
        "free_text" : free_text,
        "age"       : age,
        "sex"       : sex,
        "conditions": conditions,
    }
    async with httpx.AsyncClient(timeout=60.0) as client:
        resp = await client.post(
            f"{settings.MEDGEMMA_URL}/triage",
            json=payload,
        )
        resp.raise_for_status()
        return resp.json()