FROM ruby:2.1.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /elovation
WORKDIR /elovation
ADD Gemfile /elovation/Gemfile
ADD Gemfile.lock /elovation/Gemfile.lock
RUN bundle install
ADD . /elovation
