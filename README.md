# Outrigger pa11y

> Docker image for pa11y, the CLI-based accessibility testing tool.

[![GitHub tag](https://img.shields.io/github/tag/phase2/docker-pa11y.svg)](https://github.com/phase2/docker-pa11y) [![Docker Stars](https://img.shields.io/docker/stars/outrigger/pa11y.svg)](https://hub.docker.com/r/outrigger/pa11y) [![Docker Pulls](https://img.shields.io/docker/pulls/outrigger/pa11y.svg)](https://hub.docker.com/r/outrigger/pa11y) [![](https://images.microbadger.com/badges/image/outrigger/pa11y:dev.svg)](https://microbadger.com/images/outrigger/pa11y:dev "Get your own image badge on microbadger.com")

This Docker image provides the use of [pa11y v5](https://github.com/pa11y/pa11y).
(Note that the v5 version of that project is currently not in the master branch.)

As of version 2, a variant (with tags suffixed `-ci`) ships with the [pa11y-ci](https://github.com/pa11y/pa11y-ci) tool.

Version 2 of outrigger/pa11y Docker image provides stable versions of pa11y v5 and pa11y-ci v2.

## Usage Examples

### Docker Run

This is a quick demonstration of how you can use pa11y to run checks against a
given URL.

```
docker run -i --rm --cap-add=SYS_ADMIN \
  --name pa11y outrigger/pa11y:2 http://outrigger.sh
```

### Docker-Compose - Simple

This is the docker-compose style to execute the same docker run command as above.

```yaml
version: '3.3'
services:
  pa11y:
    image: outrigger/pa11y:2
    command: http://outrigger.sh
    network_mode: bridge
    cap_add:
      - SYS_ADMIN
```

This configuration can be used via `docker-compose run --rm pa11y`.


### Docker-Compose - Project

This is an example service definition to run pa11y as part of your project.

Since you would not run this operationally alongside your webserver, this should
not be added to your main docker-compose.yml. Instead, it might go in a build.yml
or wherever you are defining CLI or testing tools.

```yaml
# docker-compose -f build.yml run --rm pa11y
version: '3.3'
services:
  pa11y:
    image: outrigger/pa11y:1
    container_name: projectname_${DOCKER_ENV:-local}_pa11y
    command: ["--config", "/code/pa11y/config.js"]
    network_mode: bridge
    volumes:
      # Inject your pa11y configuration. We assume you have a config.js script.
      - ./tests/pa11y/:/code/pa11y/
    cap_add:
      - SYS_ADMIN
```

### pa11y Configuration File

This is a start for your configuration file.

The default customizations to chrome ensures HTTPS errors are ignored and that Chrome has enough memory.

```js
const browser = await puppeteer.launch({
    ignoreHTTPSErrors: true,
    args: [
      '--disable-dev-shm-usage'
    ],
});

pa11y('http://outrigger.sh', {
    browser: browser
});

browser.close();
```

### pa11y-ci

This is a variant of pa11y that allows JSON or JS configuration of URLs to be
scanned. It will aggregate the results as well, allowing a CI process to process
an entire website.

#### Docker Run

You can use docker run to trigger your pa11y-ci execution in the same manner
pa11y operates. However, you will need to position a pa11y-ci configuration file
in the container.

To start, you might copy pa11yci.example.json to your local directory, and run
the command like so:

```
docker run -i --rm --cap-add=SYS_ADMIN \
  -v $PWD/pa11yci.example.json:/app/.pa11yci
  --name pa11y-ci outrigger/pa11y:2-ci "--json"
```

You may notice the use of the --json flag: this instructs pa11y-ci to output
the test results in a machine-parseable JSON format. It is not built into the
Docker image to allow the full range of pa11y-ci options to be explored.

#### Docker Compose - Simple

This is the docker-compose style to execute the same docker run command as above.

```yaml
version: '3.3'
services:
  pa11y:
    image: outrigger/pa11y:2-ci
    command: "--json"
    volumes:
      - ./pa11yci.example.json:/app/.pa11yci
    network_mode: bridge
    cap_add:
      - SYS_ADMIN
```

This configuration can be used via `docker-compose run --rm pa11y-ci`.

#### Capture the Report

To capture the pa11y-ci report (such as for further rendering into a dashboard),
you can pipe the output of your execution into a file:

```
docker-compose run --rm pa11y-ci > report.json
```

If you want the command to be "all-in-one", you can also make further changes
to build the file output into your docker-compose configuration and use bind
mounts to export the file to the host machine:

```yaml
version: '3.3'
services:
  pa11y:
    image: outrigger/pa11y:2-ci
    # Override the entrypoint so we can wrap the pa11y-ci command in a subshell.
    entrypoint: ["dumb-init", "--"]
    # Reroute the output report to a file as part of executing the command.
    command: "bash -c 'pa11y-ci --json > /app/reports/report.json'"
    volumes:
      - ./pa11yci.example.json:/app/.pa11yci
      - ./reports:/app/reports
    network_mode: bridge
    cap_add:
      - SYS_ADMIN
```

### Screenshot Example

This is an example of reaching around pa11y to the underlying screenshot tools
built into the base puppeteer image we are using, [alekzonder/puppeteer](https://hub.docker.com/r/alekzonder/puppeteer/)

```bash
docker run -it --rm \
  --shm-size 1G \
  -v $PWD:/screenshots \
  --entrypoint ""
  outrigger/pa11y:1 \
  screenshot_series 'http://outrigger.sh' 1366x768
```

## Resources

* General issues on Puppeteer should check out the [base Puppeteer image](https://hub.docker.com/r/alekzonder/puppeteer/). Note: you can follow the instructions in that README to take screenshots. Since this image is based on that, you should not need a further Docker iamge download.
* [Puppeteer Github Project](https://github.com/GoogleChrome/puppeteer)
* [Official Puppeteer Docker guidance](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker)
* [pa11y @ Github](https://github.com/pa11y/pa11y)

## Security Reports

Please email outrigger@phase2technology.com with security concerns.

## Maintainers

[![Phase2 Logo](https://s3.amazonaws.com/phase2.public/logos/phase2-logo.png)](https://www.phase2technology.com)
