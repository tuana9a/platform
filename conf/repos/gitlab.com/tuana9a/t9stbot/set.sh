#!/bin/bash

source ./glab-secret.env

glab variable --repo tuana9a/t9stbot set DOCKER_HUB_USERNAME $DOCKER_HUB_USERNAME
glab variable --repo tuana9a/t9stbot set --protected --masked DOCKER_HUB_PASSWORD $DOCKER_HUB_PASSWORD
glab variable --repo tuana9a/t9stbot set --protected --masked TELEGRAM_BOT_TOKEN --value "$TELEGRAM_BOT_TOKEN"
glab variable --repo tuana9a/t9stbot set --protected --masked TELEGRAM_CHAT_ID --value "$TELEGRAM_CHAT_ID"