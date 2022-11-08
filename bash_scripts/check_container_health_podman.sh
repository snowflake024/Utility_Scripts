#!/bin/bash

CONTAINER=$1

if [ "x${CONTAINER}" == "x" ]; then
  echo "UNKNOWN - Container ID or Friendly Name Required"
  exit 3
fi

if [ "x$(which podman)" == "x" ]; then
  echo "UNKNOWN - Missing podman binary"
  exit 3
fi

podman info > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "UNKNOWN - Unable to talk to the podman daemon"
  exit 3
fi

RUNNING=$(podman inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

if [ $? -eq 1 ]; then
  echo "UNKNOWN - $CONTAINER does not exist."
  exit 3
fi

if [ "$RUNNING" == "false" ]; then
  echo "CRITICAL - $CONTAINER is not running."
  exit 2
fi

RESTARTING=$(podman inspect --format="{{.State.Restarting}}" $CONTAINER)

if [ "$RESTARTING" == "true" ]; then
  echo "WARNING - $CONTAINER state is restarting."
  exit 1
fi

STARTED=$(podman inspect --format="{{.State.StartedAt}}" $CONTAINER)
NETWORK=$(podman inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $CONTAINER)

echo "OK - $CONTAINER is running. IP: $NETWORK, StartedAt: $STARTED"
