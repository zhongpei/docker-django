#!/bin/bash
git clone https://github.com/GeeTeam/gt-python-sdk.git
cd gt-python-sdk
git checkout 3.0.1
python setup.py install
cd .. && rm -fr gt-python-sdk
