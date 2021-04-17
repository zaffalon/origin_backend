docker-compose build && \
docker-compose up -d && \
echo "Sleep for 15 seconds to containers finish to deploy" && \
sleep 15 && \
docker-compose run api rake db:create && \
docker-compose run api rake db:migrate && \
docker-compose run api rake db:seed && \
docker-compose run api rake db:migrate RAILS_ENV=test && \
docker-compose run -e RAILS_ENV=test api rspec && \
echo "API is running... you can use 'docker-compose stop' to stop the API"