#!/bin/bash
# Send a Telegram message
# Usage: send.sh "Your message here"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../../../.env"

# Load env vars
if [ -f "$ENV_FILE" ]; then
    TELEGRAM_BOT_TOKEN=$(grep "^TELEGRAM_BOT_TOKEN=" "$ENV_FILE" | cut -d'=' -f2)
    TELEGRAM_CHAT_ID=$(grep "^TELEGRAM_CHAT_ID=" "$ENV_FILE" | cut -d'=' -f2)
fi

# Fall back to environment variables
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-$TELEGRAM_BOT_TOKEN}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-$TELEGRAM_CHAT_ID}"

if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    echo "Error: TELEGRAM_BOT_TOKEN not set in .env or environment"
    exit 1
fi

if [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Error: TELEGRAM_CHAT_ID not set in .env or environment"
    echo "Get your chat ID from @userinfobot on Telegram"
    exit 1
fi

MESSAGE="$1"

if [ -z "$MESSAGE" ]; then
    echo "Usage: send.sh \"message\""
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" \
    -d text="$MESSAGE" \
    -d parse_mode="HTML" > /dev/null

echo "Sent: $MESSAGE"
