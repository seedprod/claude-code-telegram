# launchd Setup

macOS uses launchd to run background services. These templates help you:

1. **Run the Telegram bot continuously** - starts on login, restarts if it crashes
2. **Run scheduled skills** - like a daily briefing at 7am

## Quick Setup

Ask Claude: **"Help me set up launchd for the Telegram bot"**

## Manual Setup

### 1. Edit the plist file

Replace `YOUR_USERNAME` and paths with your actual values:

```bash
# Find your username
whoami

# Find claude path
which claude

# Find python path
which python3
```

### 2. Copy to LaunchAgents

```bash
cp com.claude.telegram-bot.plist ~/Library/LaunchAgents/
```

### 3. Load the service

```bash
launchctl load ~/Library/LaunchAgents/com.claude.telegram-bot.plist
```

### 4. Verify it's running

```bash
launchctl list | grep claude
```

## Common Commands

```bash
# Start service
launchctl load ~/Library/LaunchAgents/com.claude.telegram-bot.plist

# Stop service
launchctl unload ~/Library/LaunchAgents/com.claude.telegram-bot.plist

# Check status
launchctl list | grep claude

# View logs
tail -f /tmp/telegram-bot.log
tail -f /tmp/telegram-bot.error.log

# Restart (unload + load)
launchctl unload ~/Library/LaunchAgents/com.claude.telegram-bot.plist
launchctl load ~/Library/LaunchAgents/com.claude.telegram-bot.plist
```

## Schedule Options

The `StartCalendarInterval` key controls when scheduled skills run:

```xml
<!-- Every day at 7:00 AM -->
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>7</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>

<!-- Weekdays only at 7:00 AM -->
<key>StartCalendarInterval</key>
<array>
    <dict>
        <key>Weekday</key><integer>1</integer>
        <key>Hour</key><integer>7</integer>
        <key>Minute</key><integer>0</integer>
    </dict>
    <dict>
        <key>Weekday</key><integer>2</integer>
        <key>Hour</key><integer>7</integer>
        <key>Minute</key><integer>0</integer>
    </dict>
    <!-- ... repeat for days 3-5 -->
</array>

<!-- Every hour -->
<key>StartCalendarInterval</key>
<dict>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

Weekday values: 0=Sunday, 1=Monday, ..., 6=Saturday

## Troubleshooting

**Service won't start:**
```bash
# Check for syntax errors
plutil -lint ~/Library/LaunchAgents/com.claude.telegram-bot.plist

# Check logs
cat /tmp/telegram-bot.error.log
```

**Permission issues:**
```bash
# Make sure scripts are executable
chmod +x /path/to/telegram-bot.py
```

**Path issues:**
- Use absolute paths in the plist
- Include `/opt/homebrew/bin` in PATH for Apple Silicon Macs
