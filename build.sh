#!/bin/sh
# Vercel build: generate config.js from environment variables
# Falls back to known public values if env vars are not set (e.g. preview deployments)
cat > config.js << EOF
window.SUPABASE_URL='${SUPABASE_URL:-https://okvpjjnowtusjnnlnfgq.supabase.co}';
window.SUPABASE_ANON_KEY='${SUPABASE_ANON_KEY:-sb_publishable_vYzxNIVStG6MeGfToNeRJQ_6Ufbrr51}';
window.SUPABASE_SERVICE_KEY='${SUPABASE_SERVICE_KEY:-}';
window.CLOUDINARY_CLOUD_NAME='${CLOUDINARY_CLOUD_NAME:-}';
window.CLOUDINARY_UPLOAD_PRESET='${CLOUDINARY_UPLOAD_PRESET:-}';
EOF
