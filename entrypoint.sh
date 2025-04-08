echo "Strona index.html..."
node /app/info.js generate > /usr/share/nginx/html/index.html

echo "Serwer Nginx..."
exec nginx -g "daemon off;"
