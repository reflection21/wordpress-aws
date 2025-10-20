 docker ps
     sudo mkdir -p /usr/local/lib/docker/cli-plugins
     sudo curl -SL https://github.com/docker/compose/releases/download/v2.40.0/docker-compose-linux-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose
     sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
 docker compose version
