# Dockerfile para despliegue multiplataforma (Hugging Face Spaces / Render / Cloud Run)
FROM python:3.11-slim

# Evitar prompts y configurar buffers
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=7860

WORKDIR /app

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiar el código del proyecto
COPY . .

# Crear carpetas requeridas si no existen
RUN mkdir -p data/uploads documents

# Exponer puerto (7860 para Hugging Face Spaces, configurable en Render mediante $PORT)
EXPOSE 7860

# Comando de inicio dinámico
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-7860}"]
