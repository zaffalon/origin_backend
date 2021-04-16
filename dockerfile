FROM ruby:2.6-alpine

RUN apk add --update --no-cache \ 
    build-base \
    mysql-dev \
    bash \
    tzdata

# Application path inside container
ENV APP_ROOT /app

# Create application folder
RUN mkdir $APP_ROOT

# Set command execution path
WORKDIR $APP_ROOT

# Copy files to application folder
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

# Install gems
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 0
RUN bundle install 

# Copy all project files to application folder inside container
COPY . $APP_ROOT

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000