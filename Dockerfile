FROM --platform=linux/amd64 ruby:2.5.9-alpine AS builder
RUN apk add \
  build-base \
  postgresql-dev
COPY Gemfile* .
RUN bundle install
FROM --platform=linux/amd64 ruby:2.5.9-alpine AS runner
RUN apk add \
    tzdata \
    nodejs \
    postgresql-dev
WORKDIR /app
# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .
EXPOSE 3000
ENTRYPOINT ["rails"]
CMD ["server", "-b", "0.0.0.0"]
