#!/usr/bin/env bash

# Path to log output
LOG_FILE="$HOME/Library/Logs/mise-global-tool-upgrade-cron.log"

CRON_MARKER="# mise global tool upgrade cron"

# Cron job to run every 2 hours
CRON_JOB="0 */2 * * * /bin/zsh -c 'source ~/.zprofile && mise upgrade --yes' >> $LOG_FILE 2>&1 $CRON_MARKER || /usr/bin/osascript -e 'display notification \"mise global tool upgrade cron failed\" with title \"Cron Job Error\"'"

# Fetch current crontab
CURRENT_CRON=$(crontab -l 2>/dev/null || true)

# Check if the cron job already exists
if echo "$CURRENT_CRON" | grep -q "$CRON_MARKER"; then
  echo "    mise global tool upgrade cron job already installed. Skipping."
else
  # Append the new job and install it
  (echo "$CURRENT_CRON"; echo "$CRON_JOB") | crontab -
  echo "    mise global tool upgrade cron job added successfully."
fi
