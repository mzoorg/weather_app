#!/bin/bash
export FLASK_APP=weather_app/__init__.py
flask db migrate
flask db upgrade