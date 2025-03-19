server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    location /media {
        root /app/babybuddy;
    }

    location /static {
        root /app/babybuddy;
    }

    location / {
        allow   172.30.32.0/23;
        deny    all;

        proxy_pass http://backend;

        absolute_redirect off;
    {{ if .remoteuser }}
        proxy_set_header X-Remote-User '{{ .remoteuser }}';
    {{- end }}
        proxy_hide_header x-frame-options; # X-Frame denied by default
    }
}