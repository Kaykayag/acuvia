from pydantic import BaseModel
from typing import Optional, List

class TriageRequest(BaseModel):
    symptoms:   List[str]
    free_text:  Optional[str] = ""
    age:        int
    sex:        str
    conditions: Optional[List[str]] = []

class TriageResponse(BaseModel):
    priority:   str
    tagline:    Optional[str] = None
    reason:     Optional[str] = None
    next_steps: Optional[List[str]] = []
    assessment_id: int                   # returned after saving to DB