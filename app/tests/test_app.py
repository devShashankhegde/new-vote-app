import pytest
from flask import Flask
from app import app as flask_app  # adjust import based on your structure

@pytest.fixture
def client():
    flask_app.config['TESTING'] = True
    with flask_app.test_client() as client:
        yield client

def test_homepage(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'hostname' in response.data or b'<html' in response.data

def test_vote_redirect(client):
    response = client.post('/vote', data={'language': 'Python'}, follow_redirects=True)
    assert response.status_code == 200
    assert b'Python' in response.data  # expect Python to show up in results

def test_results(client):
    response = client.get('/results')
    assert response.status_code == 200
    assert b'Python' in response.data or b'<html' in response.data

def test_health(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json == {"status": "healthy"}
