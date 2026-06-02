#!/bin/bash
newman run collections/collection.json \
  --environment environments/environment.json \
  --reporters cli,json \
  --reporter-json-export results/report.json