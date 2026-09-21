#!/bin/sh
# Generate config.js from environment variables, then start nginx
cat > /usr/share/nginx/html/config.js << EOF
window.SUPABASE_URL='$SUPABASE_URL';
window.SUPABASE_ANON_KEY='$SUPABASE_ANON_KEY';
window.SUPABASE_SERVICE_KEY='$SUPABASE_SERVICE_KEY';
EOF
exec nginx -g 'daemon off;'
