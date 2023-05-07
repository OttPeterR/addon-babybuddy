server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    location / {
        allow   172.30.32.2;
        deny    all;

        proxy_pass http://backend;

        absolute_redirect off;
        proxy_redirect '/' $http_x_ingress_path/;
        sub_filter 'href="/' 'href="$http_x_ingress_path/';
        sub_filter 'href=/>' 'href="$http_x_ingress_path/">'; # Top left home icon
        sub_filter 'action="/' 'action="$http_x_ingress_path/';
        sub_filter '<script src="/' '<script src="$http_x_ingress_path/';
        sub_filter '<img src="/' '<img src="$http_x_ingress_path/';
        sub_filter "top.location.href='" "top.location.href='$http_x_ingress_path";

        sub_filter_once off;
    {{ if .remoteuser }}
        proxy_set_header X-Remote-User '{{ .remoteuser }}';
    {{- end }}
        proxy_hide_header x-frame-options; # X-Frame denied by default
    }
}