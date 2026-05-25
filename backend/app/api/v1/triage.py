from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.ai.model import run_triage_remote
from app.schemas.triage import TriageRequest, TriageResponse
from app.api.deps import get_db, get_current_user
from app.db import models

router = APIRouter()

@router.post("/triage", response_model=TriageResponse)
async def triage(
    req: TriageRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    try:
        result = await run_triage_remote(
            symptoms   = req.symptoms,
            free_text  = req.free_text or "",
            age        = req.age,
            sex        = req.sex,
            conditions = req.conditions or [],
        )
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"MedGemma error: {e}")

    # Save to DB
    assessment = models.Assessment(
        user_id    = current_user.id,
        symptoms   = req.symptoms,
        free_text  = req.free_text,
        age        = req.age,
        sex        = req.sex,
        conditions = req.conditions,
        priority   = result["priority"],
        tagline    = result.get("tagline"),
        reason     = result.get("reason"),
        next_steps = result.get("next_steps", []),
    )
    db.add(assessment)
    db.commit()
    db.refresh(assessment)

    return TriageResponse(
        priority      = result["priority"],
        tagline       = result.get("tagline"),
        reason        = result.get("reason"),
        next_steps    = result.get("next_steps", []),
        assessment_id = assessment.id,
    )