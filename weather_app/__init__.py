from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from weather_app import config

app = Flask(__name__)
app.config['SECRET_KEY'] = 'asd90787d8fg7d7fg6789yghuih5ghjgfjdsf'
app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+mysqlconnector://{config.MYSQL_USER}:{config.MYSQL_PASSWORD}@{config.MYSQL_HOST}/{config.MYSQL_DB}'
db = SQLAlchemy(app)
db.create_all()

from weather_app import routes