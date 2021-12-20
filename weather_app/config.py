import sys
from datetime import date, timedelta

CLIENT_ID = 'fcaf5431-dd36-49e0-9259-6fa5bd697d12'
ENDPOINT = 'https://frost.met.no/observations/v0.jsonld'
REFERENCE_TIME = f"{date.today() - timedelta(days=1)}/{date.today()}"
SOURCES = {
    'name': 'Oslo (Blindern)',
    'id': 'SN18700'
}

if len(sys.argv) > 1:
    MYSQL_HOST = sys.argv[4]
    MYSQL_DB = sys.argv[3]
    MYSQL_USER = sys.argv[2]
    MYSQL_PASSWORD = sys.argv[1]
else:
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'dbuser'
    MYSQL_PASSWORD = 'userpass'
    MYSQL_DB = 'dbname'