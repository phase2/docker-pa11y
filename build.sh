#!/bin/sh

docker build -t outrigger/pa11y ./pa11y
docker build -t outrigger/pa11y:ci ./pa11y-ci
