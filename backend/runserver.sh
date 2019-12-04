#!/usr/bin/env bash

python3 /app/backend/manage.py migrate
python3 /app/backend/manage.py runserver 0.0.0.0:8000
