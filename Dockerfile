ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libvips \
      pkg-config \
      curl \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock* ./
RUN gem install bundler && bundle install

COPY . .

RUN chmod +x bin/* 2>/dev/null || true

RUN bundle exec tailwindcss \
    -i app/assets/stylesheets/application.tailwind.css \
    -o app/assets/builds/application.css \
    -c config/tailwind.config.js \
    --minify
RUN RAILS_ENV=production SECRET_KEY_BASE=build_placeholder bundle exec rails assets:precompile

EXPOSE 3000

COPY bin/docker-entrypoint /usr/bin/docker-entrypoint
RUN chmod +x /usr/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
