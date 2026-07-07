#!/bin/bash
set -e

cd /var/www

# Ensure SQLite file exists (for /tmp or volume paths)
touch "${DB_DATABASE:-/tmp/database.sqlite}"

php artisan migrate --force

# Seed on fresh DB; ignore errors on re-deploys (unique constraints)
php artisan db:seed --force 2>/dev/null || true

php artisan config:cache
php artisan route:cache

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
