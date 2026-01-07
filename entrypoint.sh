#!/bin/bash

# Run rails by default unless disabled
if [ -z "$RUN_RAILS" ]; then
	RUN_RAILS=true
fi

# ensure booleans
if [ "$RUN_RAILS" == "true" ] || [ "$RUN_RAILS" == "1" ]; then
	RUN_RAILS=true
	echo "✅ Running Rails"
else
	RUN_RAILS=false
	echo "⚠️ Not running Rails"
fi

# Run sidekiq by default unless disabled
if [ -z "$RUN_SIDEKIQ" ]; then
	RUN_SIDEKIQ=true
fi
if [ "$DISABLE_SIDEKIQ" == "true" ] || [ "$DISABLE_SIDEKIQ" == "1" ]; then
	echo "⚠️ Sidekiq is disabled because DISABLE_SIDEKIQ is set"
	RUN_SIDEKIQ=false
fi

if [ "$RUN_SIDEKIQ" == "true" ] || [ "$RUN_SIDEKIQ" == "1" ]; then
	RUN_SIDEKIQ=true
	echo "✅ Running Sidekiq"
else
	RUN_SIDEKIQ=false
	echo "⚠️ Not running Sidekiq"
fi

export RUN_RAILS
export RUN_SIDEKIQ

# Check all the gems are installed or fails.
bundle check
if [ $? -ne 0 ]; then
	echo "❌ Gems in Gemfile are not installed, aborting..."
	exit 1
else
	echo "✅ Gems in Gemfile are installed"
fi

# Check no migrations are pending migrations
if [ -z "$SKIP_MIGRATIONS" ]; then
	bundle exec rails db:migrate
	echo "✅ Migrations are all up"
else
	echo "⚠️ Skipping migrations"
fi

echo "🚀 $@"
exec "$@"