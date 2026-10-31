# syntax=docker/dockerfile:1

# Stage 1: Build Angular frontend
FROM node:24.22.1-slim AS frontend-builder
WORKDIR /app/frontend
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
COPY frontend/package.json frontend/package-lock.json frontend/.npmrc ./
RUN npm ci
COPY frontend/patches/ ./patches/
RUN npx patch-package
COPY frontend/ ./
COPY modules/ ../modules/
COPY app/ ../app/
COPY lib/ ../lib/
RUN cp src/app/features/plugins/linked-plugins.styles.sass.example src/app/features/plugins/linked-plugins.styles.sass && \
    cp src/app/features/plugins/linked-plugins.module.ts.example src/app/features/plugins/linked-plugins.module.ts
RUN npm run build

# Stage 2: Install gems + precompile Rails assets
FROM ruby:4.0.9 AS app-builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    libffi-dev \
    libsqlite3-dev \
    git \
    postgresql \
    && rm -rf /var/lib/apt/lists/*

COPY .ruby-version Gemfile Gemfile.lock Gemfile.modules ./
COPY modules/ ./modules/
RUN bundle config set --local path /usr/local/bundle && \
    bundle install --jobs 4

COPY . .
COPY --from=frontend-builder /app/public/assets/frontend ./public/assets/frontend
RUN cat > config/database.yml << 'DBEOF'
default: &default
  url: "<%= ENV['DATABASE_URL'] %>"

production:
  <<: *default
DBEOF

ENV RAILS_ENV=production
RUN service postgresql start && \
    su postgres -c "psql -c \"CREATE USER appuser WITH SUPERUSER PASSWORD 'pass'\"" && \
    su postgres -c "psql -c \"CREATE DATABASE dummy OWNER appuser\"" && \
    SECRET_KEY_BASE=dummy RAILS_SERVE_STATIC_FILES=true RECOMPILE_RAILS_ASSETS=true \
    DATABASE_URL=postgresql://appuser:pass@localhost:5432/dummy \
    bundle exec rails assets:precompile && \
    SECRET_KEY_BASE=dummy RAILS_SERVE_STATIC_FILES=true \
    DATABASE_URL=postgresql://appuser:pass@localhost:5432/dummy \
    bundle exec rails assets:rebuild_manifest && \
    service postgresql stop

# Stage 3: Runtime
FROM ruby:4.0.9-slim AS runtime
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libxml2 \
    libxslt1.1 \
    libyaml-0-2 \
    libffi8 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r appuser && useradd -r -g appuser appuser

ENV BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=1 \
    HOST=0.0.0.0 \
    PORT=3000

COPY --from=app-builder /usr/local/bundle /usr/local/bundle
COPY --from=app-builder /app .

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server"]
