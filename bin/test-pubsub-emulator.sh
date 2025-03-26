#!/usr/bin/env bash

# After starting the emulator with `docker compose up pubsub-emulator` you can
# run this script from the host to ensure the emulator is working as expected.

PROJECT=local-project
PUBSUB_EMULATOR_HOST=0.0.0.0:8085
TOPIC=test-connectivity-$(head -c 32 /dev/urandom | base64 | tr -dc a-zA-Z0-9 | head -c 8)-topic

curl -X PUT -H "Content-Type: application/json" http://${PUBSUB_EMULATOR_HOST}/v1/projects/${PROJECT}/topics/${TOPIC}
curl -X GET -H "Content-Type: application/json" http://${PUBSUB_EMULATOR_HOST}/v1/projects/${PROJECT}/topics