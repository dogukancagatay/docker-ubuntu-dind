# Ubuntu Docker-in-Docker Image

Docker-in-Docker is a docker solution mostly used on CI/CD pipelines. This dind image is based on Ubuntu and features the s6-overlay for running the dockerd service. s6-overlay can come in handy when creating multi service agents for CI/CD pipelines. For example, Azure Devops Pipelines agent.

## Tags

- `20.04`, `latest`
- `18.04`

## Usage

### As Base Image

If you want to use the image as base image, You can use it with the conventions of [s6-overlay](https://github.com/just-containers/s6-overlay) as well as adding your own `CMD`. Note that, s6-overlay uses `ENTRYPOINT`, so when consider calling it when overriding.

### Running the Image

```
docker run -it --privileged dcagatay/ubuntu-dind:20.04 /bin/bash
```

You probably won't but you can run the image with the above command.

### Environment Variables

- `DOCKER_EXTRA_OPTS`: Used to give arguments to `dockerd` command. Details can be found on its [reference](https://docs.docker.com/engine/reference/commandline/dockerd/). Default: `--log-level=error --experimental`

## Build

You can build your own images specifying following build arguments.

- `DOCKER_VERSION`: Docker version to be installed. Default: `20.10.7`
- `DOCKER_CHANNEL`: Docker release channel. Can be one of _stable_, _test_, _nightly_. Default: `stable`
- `DIND_COMMIT`: Moby project dind hack script commit hash. Default: `42b1175eda071c0e9121e1d64345928384a93df1`
- `DOCKER_COMPOSE_VERSION`: Version of the _docker-compose_. Default: `1.29.1`

## Credits

I was inspired by (cruizba/ubuntu-dind)[https://github.com/cruizba/ubuntu-dind.git]. It uses a supervisord to run the dockerd as a service whereas this image uses the s6-overlay.

## WARNING

The `--privileged` argument has security implications.
