#!/bin/bash

REDIR_HEADER=$(curl -I -s http://gauth.lol | head -n1)

if [[ "${REDIR_HEADER}" != *"301"* ]]; then
  echo "Didn't get expected redirect"
  exit 1
fi

RESPONSE=$(curl -I --insecure https://gauth.lol/)

if [[ "$RESPONSE" != *"302"* ]]; then
  echo "Didn't get expected temp redirect"
  exit 1
fi

if [[ "$RESPONSE" != *"google.com"* ]]; then
  echo "Didn't get expected temp redirect to google"
  exit 1
fi