---
name: telegram-sender
description: Send Telegram messages for notifications, reminders, or alerts. Use for proactive messaging. Triggers on "send telegram", "message me", "notify me", "remind me".
---

# Telegram Sender

Send messages to yourself via Telegram. Useful for:
- Notifications when long tasks complete
- Scheduled reminders (combine with cron)
- Alerts from automated workflows

## Usage

```bash
./skills/telegram-sender/scripts/send.sh "Your message here"
```

## Examples

**Send a simple message:**
```bash
./skills/telegram-sender/scripts/send.sh "Task completed!"
```

**With HTML formatting:**
```bash
./skills/telegram-sender/scripts/send.sh "<b>Alert:</b> Build failed"
```

## For Scheduled Reminders

Combine with cron for scheduled messages:

```bash
# Remind at 7pm daily
0 19 * * * /path/to/skills/telegram-sender/scripts/send.sh "Time for evening routine"

# Remind at 3pm on weekdays
0 15 * * 1-5 /path/to/skills/telegram-sender/scripts/send.sh "Take a break"
```

## Supported Formatting

Telegram HTML tags:
- `<b>bold</b>`
- `<i>italic</i>`
- `<code>monospace</code>`
- `<pre>code block</pre>`

## Requirements

Set these in your `.env` file:
- `TELEGRAM_BOT_TOKEN` - Your bot token from @BotFather
- `TELEGRAM_CHAT_ID` - Your user ID from @userinfobot
