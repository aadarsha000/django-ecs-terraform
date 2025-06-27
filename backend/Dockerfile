# ---------- Builder Stage ----------
    FROM python:3.12-slim-bullseye AS builder

# Environment variables for builder
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VERSION=1.8.4 \
    POETRY_HOME="/opt/poetry" \
    PATH="$POETRY_HOME/bin:$PATH" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    curl \
    bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.8.4

# Set working directory
WORKDIR /app

# Copy dependency declarations
COPY pyproject.toml poetry.lock ./

# Export to requirements.txt
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

# ---------- Final Stage ----------
FROM python:3.12-slim-bullseye AS final

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install runtime dependencies and Bash
RUN apt-get update && apt-get install -y \
    libffi-dev \
    openssl \
    cron \
    bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy dependencies and install
COPY --from=builder /app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Ensure all startup scripts use UNIX line endings and are executable
RUN sed -i 's/\r$//' entrypoint.sh django_start.sh \
    && chmod +x entrypoint.sh django_start.sh

# Entrypoint
ENTRYPOINT ["./entrypoint.sh"]
