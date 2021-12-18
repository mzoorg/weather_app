#from os import removedirs
from weather_app import db
from datetime import date

class Weather(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date_created = db.Column(db.DateTime, nullable=False, default=date.today)
    station = db.Column(db.Text, nullable=False)
    observ_date = db.Column(db.Text, nullable=False)
    temperature = db.Column(db.Text, nullable=False)
    humidity = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return f"{self.id}, {self.date_created}, {self.station}, {self.observ_date}, {self.temperature}, {self.humidity}"



