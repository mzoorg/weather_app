from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from weather_app import config
from prometheus_flask_exporter import PrometheusMetrics
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SECRET_KEY'] = 'asd90787d8fg7d7fg6789yghuih5ghjgfjdsf'
app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+mysqlconnector://{config.MYSQL_USER}:{config.MYSQL_PASSWORD}@{config.MYSQL_HOST}/{config.MYSQL_DB}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
metrics = PrometheusMetrics(app, path=None)
metrics.start_http_server(config.EXPORTER_PORT)

from weather_app import models
migrate = Migrate(app, db)

from weather_app import routes