# claude-code-telegram

Connect Claude Code to Telegram for a personal AI assistant you can message from anywhere.

## Quick Start

Open Claude Code and paste:

```
https://github.com/seedprod/claude-code-telegram - help me set this up
```

Claude will clone the repo and walk you through the entire setup.

Claude will walk you through:
1. Creating a Telegram bot with @BotFather
2. Getting your user ID from @userinfobot
3. Configuring the `.env` file
4. Installing the telegram-sender skill globally
5. Setting up launchd to run the bot continuously
6. (Optional) Setting up scheduled skills like daily briefings

---

## What's Included

| File | Purpose |
|------|---------|
| `telegram-bot.py` | Receives messages from Telegram → sends to Claude Code |
| `skills/telegram-sender/` | Lets Claude send messages TO you |
| `skills/daily-brief/` | Example scheduled skill using telegram-sender |
| `launchd/` | Templates for running bot + scheduled skills |

## How It Works

**Inbound (you → Claude):**
```
Telegram → telegram-bot.py → claude -p "message" → response → Telegram
```

**Outbound (Claude → you):**
```
Claude skill → telegram-sender/send.sh → Telegram API → you
```

## Manual Setup

If you prefer to set up manually instead of having Claude guide you:

### 1. Prerequisites
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- Python 3.10+

### 2. Create Telegram Bot
1. Message [@BotFather](https://t.me/botfather) on Telegram
2. Send `/newbot` and follow prompts
3. Copy the bot token

### 3. Get Your User ID
1. Message [@userinfobot](https://t.me/userinfobot) on Telegram
2. Copy your user ID

### 4. Configure
```bash
cp .env.example .env
# Edit .env with your token and user ID
```

### 5. Install Dependencies
```bash
pip install -r requirements.txt
```

### 6. Install Skill Globally
```bash
cp -r skills/telegram-sender ~/.claude/skills/
```

### 7. Run Bot (Manual)
```bash
python telegram-bot.py
```

### 8. Run Bot (launchd - Recommended)
```bash
# Edit launchd/com.claude.telegram-bot.plist with your paths
cp launchd/com.claude.telegram-bot.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claude.telegram-bot.plist
```

## Bot Commands

- `/new` - Clear session, start fresh
- `/status` - Show session status

## Voice Messages (Apple Silicon)

```bash
pip install mlx-whisper
```

Voice messages will be transcribed locally and sent to Claude.

## Example: Daily Briefing

The `skills/daily-brief/` shows how to create a scheduled skill that sends you a morning briefing via Telegram. See `skills/daily-brief/SKILL.md` for details.

To schedule it:
```bash
# Edit launchd/com.claude.daily-brief.plist with your paths
cp launchd/com.claude.daily-brief.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claude.daily-brief.plist
```

## Security

- Set `ALLOWED_USERS` to restrict who can use your bot
- The bot runs Claude with tool access - be mindful of what you allow
- Never commit your `.env` file

## License

MIT
