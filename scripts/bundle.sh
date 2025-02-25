#!/bin/bash
pip install -r requirements.txt
pyinstaller --onefile --clean --name=app Lib/MainApplicationGui.py
pyinstaller --onefile --clean --name=app main.py
