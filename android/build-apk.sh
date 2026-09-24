#!/bin/sh
# Run with the public Supabase URL and anon key in the environment. Never package the service-role key.
set -eu
cd "$(dirname "$0")"
: "${SUPABASE_URL:?Set SUPABASE_URL for the Android build}"
: "${SUPABASE_ANON_KEY:?Set SUPABASE_ANON_KEY for the Android build}"
mkdir -p app/src/main/assets ../downloads
cp ../index.html app/src/main/assets/index.html
# Supabase URL and anon key are public browser credentials, not a service-role credential.
printf "window.SUPABASE_URL='%s';\nwindow.SUPABASE_ANON_KEY='%s';\n" "$SUPABASE_URL" "$SUPABASE_ANON_KEY" > app/src/main/assets/config.js
gradle --no-daemon :app:assembleDebug
cp app/build/outputs/apk/debug/app-debug.apk ../downloads/SavingsPro.apk
printf 'Built downloads/SavingsPro.apk\n'
