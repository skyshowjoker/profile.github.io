FROM nginx:alpine

# Copy static site files
COPY index.html /usr/share/nginx/html/
COPY __ai_app.html /usr/share/nginx/html/
COPY colorbox-ai_v2.1.6.js /usr/share/nginx/html/
COPY nba-data.js /usr/share/nginx/html/
COPY name_map.json /usr/share/nginx/html/
COPY pos_map.json /usr/share/nginx/html/
COPY resume/ /usr/share/nginx/html/resume/
COPY static/ /usr/share/nginx/html/static/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove default nginx config
RUN rm -f /etc/nginx/conf.d/default.conf.bak

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
