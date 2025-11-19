FROM python:3.9

WORKDIR /app

# Install system packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (cache layer)
COPY requirements.txt .

# Install python dependencies
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install mysqlclient

# Copy full project
COPY . .

# Expose Django port
EXPOSE 8000

# Run migrations and start server
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && python manage.py runserver 0.0.0.0:8000"]

