ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim

# Dependências do sistema
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

# Instala gems primeiro (cache de layer)
COPY Gemfile Gemfile.lock* ./
RUN gem install bundler && bundle install

# Copia o restante do projeto
COPY . .

# Garante que scripts de bin/ são executáveis
RUN chmod +x bin/* 2>/dev/null || true

# Compila o CSS do Tailwind (fase de build, não em runtime)
RUN RAILS_ENV=production bundle exec rails tailwindcss:build

# Porta exposta pela aplicação Rails
EXPOSE 3000

# Script de entrada garante que o servidor sobe mesmo depois de crash anterior
COPY bin/docker-entrypoint /usr/bin/docker-entrypoint
RUN chmod +x /usr/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
