import os
from datetime import date, timedelta

ENDPOINT = 'https://frost.met.no/observations/v0.jsonld'
REFERENCE_TIME = f"{date.today() - timedelta(days=1)}/{date.today()}"
SOURCES = {
    'name': 'Oslo (Blindern)',
    'id': 'SN18700'
}

CLIENT_ID = os.getenv('CLIENT_ID')
MYSQL_HOST = os.getenv('MYSQL_HOST')
MYSQL_USER = os.getenv('MYSQL_USER')
MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD')
MYSQL_DB = os.getenv('MYSQL_DB')
EXPORTER_PORT = int(os.getenv('EXPORTER_PORT'))