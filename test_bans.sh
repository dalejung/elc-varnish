#!/bin/sh

docker-compose start app

docker-compose exec varnish varnishadm backend.list

# prime caches
echo -e "\nWarm Caches:\n"
docker-compose exec varnish curl http://127.0.0.1:80/dale
docker-compose exec varnish curl http://127.0.0.1:80/dale2
docker-compose exec varnish curl http://127.0.0.1:80/bob
docker-compose exec varnish curl http://127.0.0.1:80/bob2

docker-compose exec varnish varnishadm ban "req.url ~ /bob*"

docker-compose stop app
docker-compose exec varnish varnishadm backend.list

docker-compose exec varnish varnishadm ban.list

# try agian
echo -e "\nTry Again:\n"
docker-compose exec varnish curl http://127.0.0.1:80/dale
docker-compose exec varnish curl http://127.0.0.1:80/bob
