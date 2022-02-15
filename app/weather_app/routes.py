import requests, json, statistics
from flask import render_template, redirect, flash
from flask.helpers import url_for
from weather_app import app, db, config
from weather_app.models import Weather

DEBUG = 0

@app.route('/', methods=['GET'])
def index():
    observations = Weather.query.order_by(Weather.id.desc())
# Debugging
    if DEBUG:
        for i in observations: print(i['id'], i['station'], i['temperature'])
    return render_template('mypage.html', observations=observations, source=config.SOURCES['name'])

@app.route('/request_data', methods=['GET'])
def request_data():
    parameters = {
        'sources': config.SOURCES['id'], #add choosing drobmenu for source, displayed sources must show names
        'elements': 'air_temperature, relative_humidity',
        'referencetime': config.REFERENCE_TIME,
        'levels': 2,
        'timeoffsets': 'PT0H',
        'timeresolutions': 'PT1H',
        'fields':'referenceTime, elementId, value'
    }
    r = requests.get(config.ENDPOINT, params=parameters, auth=(config.CLIENT_ID,''))
    json_data = json.loads(r.content)
    if r.status_code == 200:
        put_db_data(json_data=json_data)
# Debugging
        if DEBUG: print(json_data)
    else:
        print('Error!')
        flash(f"Error! Returned status code {r.status_code}")
        flash(f"Message: {json_data['error']['message']}")
        flash(f"Reason: {json_data['error']['reason']}")
    return redirect(url_for('index'))

@app.route('/getreport', methods=['GET']) #add method for report and display it
def get_report():
    record = Weather.query.order_by(Weather.id.desc()).first()
    return render_template('report.html', lastrecord=record, source=config.SOURCES['name'])

@app.route('/record/<int:record_id>')
def get_record(record_id):
    record = Weather.query.get_or_404(record_id)
    return render_template('record.html', record=record)

@app.route("/record/<int:record_id>/delete")
def delete_record(record_id):
    record = Weather.query.get_or_404(record_id)
    db.session.delete(record)
    db.session.commit()
    flash('Your record has been deleted!', 'success')
    return redirect(url_for('index'))

@app.route('/about', methods=['GET'])
def about():
    return render_template('about.html') 

def calculate_avg(json_data, element_name):
    temp_list = []
    for referencetime in json_data['data']:
        for element in referencetime['observations']:
            if element_name in element['elementId']:
                temp_list.append(element['value'])
    return round(statistics.mean(temp_list), 2)

def put_db_data(json_data):
    filter_data = dict()
    filter_data['station'] = config.SOURCES['name']
    filter_data['observ_date'] = config.REFERENCE_TIME
    filter_data['temperature'] = calculate_avg(json_data, 'air_temperature')
    filter_data['humidity'] = calculate_avg(json_data, 'relative_humidity')
    cur_weather = Weather(station = filter_data['station'], observ_date = filter_data['observ_date'],
            temperature = filter_data['temperature'], humidity = filter_data['humidity'])
    db.session.add(cur_weather)
    db.session.commit()