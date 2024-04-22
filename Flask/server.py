from flask import Flask
import random

app = Flask(__name__)

@app.route('/')
def index():
    return 'Welcome'

@app.route('/create/')
def create():
    return 'Create'

app.run(debug=True)