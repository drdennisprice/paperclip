#!/bin/sh
# startup.sh — runs before the Paperclip server on every container boot.
#
# Codex CLI 0.117+ does NOT read OPENAI_API_KEY from the environment at
# runtime. It requires the key to be stored in ~/.codex/auth.json in the
# format written by `codex login --with-api-key`. This script performs that
# login step on every boot so the managed CODEX_HOME (which symlinks back
# to ~/.codex/auth.json) always has fresh credentials.

set -e

if [ -n "$OPENAI_API_KEY" ]; then
  echo "[startup] Configuring Codex API key auth..."
  printf '%s' "$OPENAI_API_KEY" | codex login --with-api-key
  echo "[startup] Codex auth.json written to $HOME/.codex/auth.json"
else
  echo "[startup] WARNING: OPENAI_API_KEY is not set. Codex runs will fail."
fi

exec node --import ./server/node_modules/tsx/dist/loader.mjs server/dist/index.js
