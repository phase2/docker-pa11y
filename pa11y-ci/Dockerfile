FROM alekzonder/puppeteer:1

# @see http://label-schema.org/rc1/
LABEL maintainer="Phase2 <outrigger@phase2technology.com>" \
  org.label-schema.vendor="Phase2 <outrigger@phase2technology.com>" \
  org.label-schema.name="Outrigger pa11y" \
  org.label-schema.description="Docker image for pa11y-ci, the CLI-based accessibility testing tool." \
  org.label-schema.vcs-url="https://github.com/phase2/docker-pa11y"

USER root

# Let's get pa11y-ci v2 in here.
RUN yarn global add pa11y-ci@2 && \
    yarn cache clean && \
    chown -R pptruser:pptruser /usr/local/share/.config/yarn/global/node_modules

ENV PATH "/usr/local/share/.config/yarn/global/node_modules/.bin/:${PATH}"

USER pptruser

ENTRYPOINT ["dumb-init", "--", "pa11y-ci"]

CMD ["-h"]
