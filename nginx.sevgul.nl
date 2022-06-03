
server {

        root /var/www/sevgul.nl/html;
        index index.html index.htm index.nginx-debian.html;

        server_name sevgul.nl www.sevgul.nl;

        location / {
                try_files $uri $uri/ =404;
        }


        location /etic/ {
          proxy_pass           http://localhost:2200;                 
          rewrite ^/etic(/.*)$ $1 break;

          #proxy_redirect off;     
          #proxy_redirect      http://localhost:2200 https://sevgul.nl/etic;
       }

       location /frontend/ {
          proxy_pass           http://localhost:8081;                 
          #rewrite ^/shopping(/.*)$ $1 break;
       }

       location /eboncuk/ {
          proxy_pass           http://localhost:8083;
          rewrite ^/eboncuk(/.*)$ $1 break;
       }

        
       #location /etic/ {
       #   proxy_pass           http://localhost:2200;
       #   rewrite ^/etic(.*)$ $1 break;                 
       # }
        
       # location /static/ {
       #   proxy_pass           http://localhost:2200/static/;        
       # } 
         
       
        location /jenkins/ {
          sendfile off;
          #include /etc/nginx/proxy_params;
          proxy_pass           http://localhost:7070;
          #rewrite ^/jenkins(.*)$ $1 break;
          #proxy_redirect      http://localhost:7070 https://sevgul.nl;
          proxy_redirect     default;
          proxy_http_version 1.1;

          # Required for Jenkins websocket agents
          #proxy_set_header   Connection        $connection_upgrade;
          proxy_set_header   Upgrade           $http_upgrade;

          proxy_set_header   Host              $host;
          proxy_set_header   X-Real-IP         $remote_addr;
          proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Proto $scheme;
          proxy_max_temp_file_size 0;

          #this is the maximum upload size
          client_max_body_size       10m;
          client_body_buffer_size    128k;

          proxy_connect_timeout      90;
          proxy_send_timeout         90;
          proxy_read_timeout         90;
          proxy_buffering            off;
          proxy_request_buffering    off; # Required for HTTP CLI commands
          proxy_set_header Connection ""; # Clear for keepalive        
        }

        location /portainer/ {
          proxy_pass           http://localhost:9000;
          rewrite ^/portainer(.*)$ $1 break;
        }



        #location /snl-vue/ {
           #   proxy_set_header        Host $host;
           #   proxy_set_header        X-Real-IP $remote_addr;
           #   proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
           #   proxy_set_header        X-Forwarded-Proto https;

         #     proxy_pass           http://localhost:8010/;
          #    proxy_redirect off; 
          #   proxy_read_timeout  90;

           #proxy_redirect      http://localhost:8010 https://sevgul.nl;
          
        #} 

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/sevgul.nl/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/sevgul.nl/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.sevgul.nl) {
       return 301 https://$host$request_uri;
   } # managed by Certbot


    if ($host = sevgul.nl) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80; 
    listen [::]:80;

    server_name sevgul.nl www.sevgul.nl;
    #return 301 https://$host$request_uri;
    return 404; # managed by Certbot
}
