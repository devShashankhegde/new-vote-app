FROM python:3.9-slim

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000 8000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]