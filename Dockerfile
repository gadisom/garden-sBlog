# Build stage
FROM hugomods/hugo:exts as builder

WORKDIR /src

# Copy the entire site
COPY . .

# Build the Hugo site
RUN hugo --minify

# Production stage
FROM nginx:alpine

# Copy the built site to nginx
COPY --from=builder /src/public /usr/share/nginx/html

# Copy custom nginx config if needed
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 8080;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
EOF

EXPOSE 8080
