FROM ruby:2.5.3-alpine3.9

RUN apk update && apk add build-base tzdata nodejs xvfb sqlite-dev

RUN mkdir -p /app
# Set working directory
WORKDIR /app

# Adding gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test

# Setting env up
ENV RAILS_ENV production
ENV RAKE_ENV production

# Adding project files
COPY . .

#RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
