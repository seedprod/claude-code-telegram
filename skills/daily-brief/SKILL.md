---
name: daily-brief
description: Send a morning briefing via Telegram with weather, news, and a motivational quote. Designed to run via launchd for automated daily delivery.
---

# Daily Briefing

Send yourself a personalized morning briefing via Telegram.

## Workflow

1. **Confirm today's date** - Run `date` to get current day/date for the briefing header and quote rotation

2. **Gather content**:
   - Weather via wttr.in (no API key needed)
   - News headlines via WebSearch
   - Quote based on day of week via WebSearch

3. **Format the message** using Telegram HTML

4. **Send via telegram-sender skill**

## Content Sources

### Today's Date
```bash
date "+%A, %B %d, %Y"
# Output: Sunday, February 02, 2025
```

For day-of-week number (for quote rotation):
```bash
date "+%u"
# Output: 1-7 (Monday=1, Sunday=7)
```

### Weather (wttr.in - no API key)
```bash
curl -s "wttr.in/YOUR_ZIP?format=%l:+%c+%t+(%h+humidity,+%w+wind)"
# Output: Mount Pleasant: ⛅️ +55°F (71% humidity, ↙5mph wind)
```

For more detail:
```bash
curl -s "wttr.in/YOUR_ZIP?format=%c+%t+High:%h+Low:%l"
```

Full forecast:
```bash
curl -s "wttr.in/YOUR_ZIP?1&T"  # Today only, no color codes
```

### News Headlines
```
WebSearch: "top news headlines today"
```
Extract 3-5 current headlines.

### Quote (Rotate by Day of Week)
| Day | Theme | Search Query |
|-----|-------|--------------|
| 1 (Mon) | Motivation | "motivational quote monday" |
| 2 (Tue) | Growth | "personal growth quote" |
| 3 (Wed) | Gratitude | "gratitude quote" |
| 4 (Thu) | Productivity | "productivity quote" |
| 5 (Fri) | Wisdom | "wisdom quote friday" |
| 6 (Sat) | Rest | "rest and relaxation quote" |
| 7 (Sun) | Reflection | "reflection quote sunday" |

## Message Template

```
☀️ <b>Daily Briefing</b> - {Day}, {Month} {Date}

🌤️ {weather_output}

📰 Headlines:
• {headline_1}
• {headline_2}
• {headline_3}

✨ "{quote}"
— {attribution}

Have a great day! 🚀
```

## Sending

Use the telegram-sender skill:

```bash
~/.claude/skills/telegram-sender/scripts/send.sh "$MESSAGE"
```

Where `$MESSAGE` is the formatted template with actual values.

## Customization Ideas

- Add calendar events for the day
- Include todo items from a notes app
- Add fitness goals or health reminders
- Include stock prices or crypto updates
- Add birthdays from contacts
- Different templates for weekdays vs weekends

## Scheduling with launchd

See `launchd/com.claude.daily-brief.plist` for running this automatically every morning.

To install:
```bash
# Edit plist with your paths and zip code
cp launchd/com.claude.daily-brief.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claude.daily-brief.plist
```

The skill will run at 7:00 AM daily (adjust time in plist).
