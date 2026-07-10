FROM alpine:3.18

ARG TARGETPLATFORM

ENV APP_STARTUP_CMD="tail -f /dev/null"
ENV APP_HOSTNAME=app.local
ENV APP_ROOT=/app
ENV APP_LOG_DIR=$APP_ROOT/log
ENV COLUMNS=160
ENV DEPLOY_ENV=prod
ENV RSYNC_FLAGS="--quiet"
ENV RSYNC_COPY="rsync -a --inplace --no-compress $RSYNC_FLAGS"
ENV RSYNC_MOVE="$RSYNC_COPY --remove-source-files"
ENV TERM=dumb

COPY build/scripts /scripts

RUN apk --no-cache add \
    curl \
    git \
    patch \
    rsync \
    sudo \
    unzip \
    util-linux && \
  mkdir -p "$APP_LOG_DIR" && \
  chmod -R 755 /scripts

WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]

LABEL ca.unb.lib.generator="none" \
  org.opencontainers.image.authors="libsystems@unb.ca" \
  org.opencontainers.image.created="$BUILD_DATE" \
  org.opencontainers.image.description="docker-base is the base docker image at UNB Libraries." \
  org.opencontainers.image.revision="2.x" \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-base" \
  org.opencontainers.image.title="none" \
  org.opencontainers.image.url="https://github.com/unb-libraries/docker-base" \
  org.opencontainers.image.vendor="University of New Brunswick Libraries" \
  org.opencontainers.image.version="$VERSION"
