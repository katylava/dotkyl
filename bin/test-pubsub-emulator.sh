#!/usr/bin/env bash

# After starting the emulator with `docker compose up pubsub-emulator` you can
# run this script from the host to ensure the emulator is working as expected.
#
# Pass any argument to just list topics and subscriptions without creating a
# new topic.

PROJECT=local-project
PUBSUB_EMULATOR_HOST=0.0.0.0:8085

if [[ -z $1 ]]; then
  TOPIC=test-connectivity-$(head -c 32 /dev/urandom | base64 | tr -dc a-zA-Z0-9 | head -c 8)-topic
  echo "Creating topic ${TOPIC}"
  curl -X PUT -H "Content-Type: application/json" http://${PUBSUB_EMULATOR_HOST}/v1/projects/${PROJECT}/topics/${TOPIC}
fi

curl -X GET -H "Content-Type: application/json" http://${PUBSUB_EMULATOR_HOST}/v1/projects/${PROJECT}/topics
curl -X GET -H "Content-Type: application/json" http://${PUBSUB_EMULATOR_HOST}/v1/projects/${PROJECT}/subscriptions
