FROM alpine:3.24

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

# Upgrade what the Alpine image ships too: a rebuild then picks up packages fixed since the
# image was published, which Alpine does not republish the image for.
RUN apk --no-cache upgrade && \
  apk --no-cache add \
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

ARG BUILD_DATE
ARG VCS_REF=3.24.x
ARG VERSION
LABEL ca.unb.lib.generator="none" \
  org.opencontainers.image.title="base" \
  org.opencontainers.image.description="docker-base is the base docker image at UNB Libraries." \
  org.opencontainers.image.vendor="University of New Brunswick Libraries" \
  org.opencontainers.image.authors="UNB Libraries <libsupport@unb.ca>" \
  org.opencontainers.image.url="https://github.com/unb-libraries/docker-base" \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-base" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$VCS_REF" \
  org.opencontainers.image.created="$BUILD_DATE" \
  org.opencontainers.image.licenses="MIT"
