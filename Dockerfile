FROM ruby:3.1.0

COPY . .
RUN gem install bundler
RUN bundle install