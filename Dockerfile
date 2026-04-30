FROM ruby:3.3-slim

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    default-mysql-client \
    git \
    curl \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]
