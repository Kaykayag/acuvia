from pydantic import BaseModel, EmailStr, field_validator


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class LoginInput(BaseModel):
    email: EmailStr
    password: str


class RegisterInput(BaseModel):
    email: EmailStr
    password: str
    full_name: str | None = None

    @field_validator("password")
    @classmethod
    def password_max_bytes(cls, v: str) -> str:
        # bcrypt has a 72-byte password limit; validate here to return a 400 instead of 500.
        if len(v.encode("utf-8")) > 72:
            raise ValueError("password is too long (max 72 bytes)")
        return v
