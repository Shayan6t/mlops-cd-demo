FROM python:3.12-slim

WORKDIR /app

ARG APP_VERSION=1.3.0
ARG GIT_COMMIT=local
ENV APP_VERSION=${APP_VERSION}
ENV GIT_COMMIT=${GIT_COMMIT}

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py pytest.ini VERSION ./

EXPOSE 5000

CMD ["python", "app.py"]
