FROM alekzonder/puppeteer:1

# @see http://label-schema.org/rc1/
LABEL maintainer="Phase2 <outrigger@phase2technology.com>" \
  org.label-schema.vendor="Phase2 <outrigger@phase2technology.com>" \
  org.label-schema.name="Outrigger pa11y" \
  org.label-schema.description="Docker image for pa11y, the CLI-based accessibility testing tool." \
  org.label-schema.vcs-url="https://github.com/phase2/docker-pa11y" \
  org.label-schema.docker.cmd="docker run -it --rm --cap-add=SYS_ADMIN outrigger/pa11y http://example.com" \
  org.label-schema.docker.cmd.help="docker run --rm outrigger/pa11y" \
  org.label-schema.docker.debug="docker exec -it $CONTAINER bash" \
  org.label-schema.schema-version="1.0"

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Let's get pa11y v5 in here.
RUN yarn global add pa11y@beta

# Add user so we don't need --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /screenshots \
    && chown -R pptruser:pptruser /usr/local/share/.config/yarn/global/node_modules

USER pptruser

ENTRYPOINT ["dumb-init", "--", "pa11y"]

CMD ["-h"]
