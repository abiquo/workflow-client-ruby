FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev libqt4-webkit libqt4-dev xvfb nodejs

RUN mkdir /workflow-client-ruby
WORKDIR /workflow-client-ruby

ADD Gemfile* /workflow-client-ruby/
RUN bundle install

ADD . /workflow-client-ruby

RUN bundle exec rake db:migrate

EXPOSE 3000
CMD bundle exec foreman start
