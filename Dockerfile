FROM alpine:3.17
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV APP_STARTUP_CMD tail -f /dev/null
ENV APP_HOSTNAME app.local
ENV APP_ROOT /app
ENV APP_LOG_DIR $APP_ROOT/log
ENV COLUMNS 160
ENV DEPLOY_ENV prod
ENV RSYNC_FLAGS --quiet
ENV RSYNC_COPY "rsync -a --inplace --no-compress $RSYNC_FLAGS"
ENV RSYNC_MOVE "$RSYNC_COPY --remove-source-files"
ENV TERM dumb

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
  com.microscaling.docker.dockerfile="/Dockerfile" \
  com.microscaling.license="MIT" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.description="docker-base is the base docker image at UNB Libraries." \
  org.label-schema.name="none" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.url="https://github.com/unb-libraries/docker-base" \
  org.label-schema.vcs-ref="2.x" \
  org.label-schema.vcs-url="https://github.com/unb-libraries/docker-base" \
  org.label-schema.vendor="University of New Brunswick Libraries" \
  org.label-schema.version=$VERSION \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-base"
