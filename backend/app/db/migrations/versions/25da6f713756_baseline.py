"""baseline revision for existing database state

Revision ID: 25da6f713756
Revises: 
Create Date: 2026-05-25 00:00:00.000000
"""
from alembic import op

# revision identifiers, used by Alembic.
revision = "25da6f713756"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # This revision is a no-op baseline representing the current DB state.
    pass


def downgrade() -> None:
    pass
