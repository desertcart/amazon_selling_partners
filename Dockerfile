FROM ruby:3.1.0

WORKDIR /workspace/amazon_selling_partners

COPY . .
RUN gem install bundler
RUN bundle install