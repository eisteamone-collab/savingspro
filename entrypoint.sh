#!/bin/sh
# Generate config.js from environment variables, then start nginx
cat > /usr/share/nginx/html/config.js << EOF
window.SUPABASE_URL='$SUPABASE_URL';
window.SUPABASE_ANON_KEY='$SUPABASE_ANON_KEY';
window.SUPABASE_SERVICE_KEY='$SUPABASE_SERVICE_KEY';
window.CLOUDINARY_CLOUD_NAME='$CLOUDINARY_CLOUD_NAME';
window.CLOUDINARY_UPLOAD_PRESET='$CLOUDINARY_UPLOAD_PRESET';
EOF
exec nginx -g 'daemon off;'
