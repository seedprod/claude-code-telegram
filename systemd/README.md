# systemd Service Files (Linux)

Linux equivalent of the `launchd/` macOS service files.

## Files

| File | Purpose |
|------|---------|
| `claude-telegram-bot.service` | Runs the bot continuously, restarts on failure |
| `claude-daily-brief.service` | One-shot service that runs the daily briefing |
| `claude-daily-brief.timer` | Schedules `claude-daily-brief.service` daily at 7 AM |

---

## Setup

### 1. Edit paths in service files

Open each `.service` file and replace `YOUR_USERNAME` with your actual username,
and update paths to match your installation.

```bash
# Quick find/replace
sed -i 's/YOUR_USERNAME/'"$USER"'/g' *.service *.timer
```

Verify the paths look correct before proceeding.

### 2. Install service files

```bash
# Create systemd user directory if it doesn't exist
mkdir -p ~/.config/systemd/user

# Copy service files
cp claude-telegram-bot.service ~/.config/systemd/user/
cp claude-daily-brief.service ~/.config/systemd/user/
cp claude-daily-brief.timer ~/.config/systemd/user/

# Reload systemd
systemctl --user daemon-reload
```

### 3. Start and enable the bot

```bash
# Start now and enable on login
systemctl --user enable --now claude-telegram-bot.service

# Check it's running
systemctl --user status claude-telegram-bot.service
```

### 4. Set up daily briefing (optional)

```bash
# Enable the timer (not the service directly)
systemctl --user enable --now claude-daily-brief.timer

# Check timer status
systemctl --user list-timers
```

---

## Managing the bot

```bash
# View logs (live)
journalctl --user -u claude-telegram-bot.service -f

# Stop
systemctl --user stop claude-telegram-bot.service

# Restart
systemctl --user restart claude-telegram-bot.service

# Disable autostart
systemctl --user disable claude-telegram-bot.service
```

## Autostart on boot (without login)

By default, systemd user services only run when you're logged in.
To run the bot even when you're not logged in:

```bash
sudo loginctl enable-linger $USER
```

This is useful on a home server or always-on machine.

---

## Troubleshooting

**Bot not finding `claude` binary:**
Add the path to your claude binary to the `Environment=PATH=` line in the service file.
Find it with: `which claude`

**EnvironmentFile not found:**
Make sure your `.env` file exists at the path specified in the service file.

**Service fails immediately:**
Check logs: `journalctl --user -u claude-telegram-bot.service -n 50`
