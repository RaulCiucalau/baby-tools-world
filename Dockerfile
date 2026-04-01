FROM python:3.12-slim AS backend

# Destination to copy all assets to during the build process.
ARG _WORKDIR=/app
# Set working directory to WORKDIR Argument
WORKDIR ${_WORKDIR}

# Default port for the app to start with
ENV APP_PORT=8000

# Copy all non-ignored files to image
COPY . ${_WORKDIR}

# Install package dependencies for app
RUN pip install -r requirements.txt

# Switch WORKDIR to src/ in order to execute entrypoint commands from there
WORKDIR /app/src

# Run migrations and collect static files
RUN python manage.py collectstatic --noinput && \
    python manage.py makemigrations && \
    python manage.py migrate

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
