#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Install dependencies if needed
if [ ! -f /app/.bundle/installed ]; then
  echo "Installing dependencies..."
  bundle install
  mkdir -p /app/.bundle
  touch /app/.bundle/installed
fi

# Setup database
echo "Setting up database..."
bundle exec rails db:create db:migrate db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@" 