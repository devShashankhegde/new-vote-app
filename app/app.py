from flask import Flask, render_template, request, redirect, url_for
import os
import redis
import socket
import prometheus_client
from prometheus_client import Counter, Histogram
import time

app = Flask(__name__)

# Connect to Redis
redis_host = os.environ.get('REDIS_HOST', 'localhost')
redis_port = int(os.environ.get('REDIS_PORT', 6379))
redis_client = redis.Redis(host=redis_host, port=redis_port, decode_responses=True)

# Prometheus metrics
REQUEST_COUNT = Counter('app_request_count', 'Total app http request count')
REQUEST_LATENCY = Histogram('app_request_latency_seconds', 'Request latency')

# Initialize voting options if not exists
def initialize_votes():
    languages = ["Python", "JavaScript", "Java", "Go", "Ruby"]
    for lang in languages:
        if not redis_client.exists(f"vote:{lang}"):
            redis_client.set(f"vote:{lang}", 0)

@app.route('/')
def index():
    REQUEST_COUNT.inc()
    start_time = time.time()
    
    initialize_votes()
    hostname = socket.gethostname()
    
    response = render_template('index.html', hostname=hostname)
    REQUEST_LATENCY.observe(time.time() - start_time)
    return response

@app.route('/vote', methods=['POST'])
def vote():
    REQUEST_COUNT.inc()
    start_time = time.time()
    
    language = request.form.get('language')
    if language:
        redis_client.incr(f"vote:{language}")
    
    REQUEST_LATENCY.observe(time.time() - start_time)
    return redirect(url_for('results'))

@app.route('/results')
def results():
    REQUEST_COUNT.inc()
    start_time = time.time()
    
    initialize_votes()
    languages = ["Python", "JavaScript", "Java", "Go", "Ruby"]
    results = {}
    
    for lang in languages:
        count = redis_client.get(f"vote:{lang}")
        results[lang] = int(count) if count else 0
    
    hostname = socket.gethostname()
    
    response = render_template('results.html', results=results, hostname=hostname)
    REQUEST_LATENCY.observe(time.time() - start_time)
    return response

@app.route('/health')
def health():
    return {"status": "healthy"}

@app.route('/metrics')
def metrics():
    return prometheus_client.generate_latest()

if __name__ == '__main__':
    # Start the prometheus HTTP server
    prometheus_client.start_http_server(8000)
    # Start the Flask application
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))