from weather_app import app, config
import sys

if __name__ == '__main__':
    app.run(debug=True)

if len(sys.argv) > 1:
    config.MYSQL_HOST = sys.argv[4]
    config.MYSQL_DB = sys.argv[3]
    config.MYSQL_USER = sys.argv[2]
    config.MYSQL_PASSWORD = sys.argv[1]
