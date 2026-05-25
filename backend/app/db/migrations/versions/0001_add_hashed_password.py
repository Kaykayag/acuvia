"""add hashed_password column to users

Revision ID: 0001_add_hashed_password
Revises: 
Create Date: 2026-05-25 00:00:00.000000
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "0001_add_hashed_password"
down_revision = "25da6f713756"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add the hashed_password column if it does not already exist.
    op.execute(
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS hashed_password VARCHAR(255);"
    )


def downgrade() -> None:
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS hashed_password;")
