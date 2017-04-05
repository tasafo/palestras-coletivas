#!/bin/bash

echo "Starting mongodb server..."
sudo service mongodb start

echo "Starting redis server..."
sudo service redis-server start

echo "Starting rails server..."
rails server