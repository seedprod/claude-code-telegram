# claude-code-telegram

A personal AI assistant you can message from anywhere via Telegram.

## What is this?

Claude Code runs in your terminal with full tool access -- it can read files, run commands, search the web, spawn tasks, and more. This bot lets you talk to it from your phone via Telegram instead of being tied to your computer.

**Text your bot → it runs Claude Code → sends back the response.**

Some things you can do:
- "What's on my calendar today?"
- "Search the web for the latest news on X"
- "Read my notes and summarize them"
- "Send me a daily briefing every morning at 7am"
- "Run the tests and tell me if anything broke"
- "What did I work on yesterday?" (with Continuity Bridge)

It also works the other way -- Claude can message **you** via Telegram. Notifications when tasks finish, scheduled briefings, alerts, whatever you wire up.

**The key is skills.** Out of the box Claude Code can read files and search the web. But to make it truly your assistant, create skills that give it access to your stuff:
- Google Calendar
- Gmail
- Notes (Obsidian, etc.)
- Weather for your location
- Your Continuity Bridge context

The `skills/` folder has examples to get you started.

---

## Platform Support

| Platform | Bot | Voice | Service manager |
|----------|-----|-------|----------------|
| macOS (Apple Silicon) | ✅ | ✅ mlx-whisper | launchd |
| Linux | ✅ | ✅ faster-whisper | systemd |
| macOS (Intel) | ✅ | ❌ | launchd |
| Windows | Untested | Untested | — |

---

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
5. Setting up your service manager (launchd on macOS, systemd on Linux)
6. (Optional) Setting up scheduled skills like daily briefings

---

## Manual Setup

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

**Optional: Voice transcription**

macOS (Apple Silicon):
```bash
pip install mlx-whisper
```

Linux:
```bash
pip install faster-whisper
```

### 6. Install Skill Globally

```bash
cp -r skills/telegram-sender ~/.claude/skills/
```

### 7. Run the Bot

**Manual (any platform):**
```bash
python telegram-bot.py
```

**macOS — launchd (runs continuously, starts on login):**
```bash
# Edit launchd/com.claude.telegram-bot.plist with your paths
cp launchd/com.claude.telegram-bot.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claude.telegram-bot.plist
```

**Linux — systemd (runs continuously, starts on login):**
```bash
# Edit paths in the service file
sed -i 's/YOUR_USERNAME/'"$USER"'/g' systemd/claude-telegram-bot.service

# Install and start
mkdir -p ~/.config/systemd/user
cp systemd/claude-telegram-bot.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now claude-telegram-bot.service

# Check it's running
systemctl --user status claude-telegram-bot.service
```

See `systemd/README.md` for full Linux service instructions.

---

## Bot Commands

- `/new` — Clear session, start fresh
- `/status` — Show session status and voice support

---

## Scheduling (Daily Briefings, etc.)

**macOS — launchd:**
```bash
# Edit launchd/com.claude.daily-brief.plist with your paths and schedule
cp launchd/com.claude.daily-brief.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claude.daily-brief.plist
```

**Linux — systemd timer:**
```bash
sed -i 's/YOUR_USERNAME/'"$USER"'/g' systemd/claude-daily-brief.service
cp systemd/claude-daily-brief.service ~/.config/systemd/user/
cp systemd/claude-daily-brief.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now claude-daily-brief.timer

# Verify timer is scheduled
systemctl --user list-timers
```

Edit `systemd/claude-daily-brief.timer` to change the schedule. Default is 7:00 AM daily.

---

## What's Included

| Path | Purpose |
|------|---------|
| `telegram-bot.py` | Main bot -- receives messages, runs Claude Code, sends response |
| `skills/telegram-sender/` | Lets Claude send messages TO you |
| `skills/daily-brief/` | Example scheduled skill using telegram-sender |
| `launchd/` | macOS service templates |
| `systemd/` | Linux service templates |

---

## Security

### ALLOWED_USERS is critical

**Always set `ALLOWED_USERS` in your `.env` file.** If left empty, anyone who discovers your bot's username can send it messages and run Claude Code with full tool access on your machine.

```bash
# .env — always set this
ALLOWED_USERS=123456789
```

Get your user ID from [@userinfobot](https://t.me/userinfobot).

### Understand the tool access

The bot runs Claude with these tools enabled:
- `Read` / `Write` / `Edit` — filesystem access
- `Bash` — shell command execution
- `Glob` / `Grep` — file search
- `WebFetch` / `WebSearch` — internet access
- `Task` / `Skill` — agent spawning and skill execution

This is powerful and intentional for a personal assistant. Messages you send can trigger real actions on your system.

### Protect your tokens

- Never commit `.env` (already in `.gitignore`)
- Your bot token lets anyone impersonate your bot
- Your chat ID lets anyone send you messages via the bot

### Session file

Sessions stored in `~/.telegram-claude-sessions.json`. On shared systems:

```bash
chmod 600 ~/.telegram-claude-sessions.json
```

---

## Viewing Logs

**macOS:**
```bash
tail -f /tmp/telegram-bot.log
```

**Linux (systemd):**
```bash
journalctl --user -u claude-telegram-bot.service -f
```

---

## License

MIT
