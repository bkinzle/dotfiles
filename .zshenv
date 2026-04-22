# things in this file will run for every zsh invocation. Login, non-login, interactive, non-interactive, scripts, all of them
# keep this file fast and minimal -- just env vars

# this will affect all tools that follow the XDG spec, some tools that would default to `~/Library/Application Support/...` will now use `~/.config/...` instead
export XDG_CONFIG_HOME="$HOME/.config"
