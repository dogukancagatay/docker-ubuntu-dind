variable "IMAGE_NAME" {
    default = "dcagatay/ubuntu-dind"
}

variable "DOCKER_VERSION" {
    default = "20.10.7"
}

variable "DOCKER_COMPOSE_VERSION" {
    default = "1.29.2"
}

group "default" {
    targets = [ "latest", "20_04", "18_04" ]
}

target "latest" {
    context = "."
    platforms = [ "linux/amd64" ]
//     platforms = [ "linux/amd64", "linux/arm/v7", "linux/arm64/v8" ]
    dockerfile = "Dockerfile"
    args = {
        UBUNTU_TAG = "latest"
	DOCKER_VERSION = "${DOCKER_VERSION}"
	DOCKER_COMPOSE_VERSION = "${DOCKER_COMPOSE_VERSION}"
    }
    tags = [
        "docker.io/${IMAGE_NAME}:latest"
    ]
}

target "20_04" {
    inherits = ["latest"]
    args = {
        UBUNTU_TAG = "20.04"
	DOCKER_VERSION = "${DOCKER_VERSION}"
	DOCKER_COMPOSE_VERSION = "${DOCKER_COMPOSE_VERSION}"
    }
    tags = [
        "docker.io/${IMAGE_NAME}:20.04"
    ]
}

target "18_04" {
    inherits = ["latest"]
    args = {
        UBUNTU_TAG = "18.04"
	DOCKER_VERSION = "${DOCKER_VERSION}"
	DOCKER_COMPOSE_VERSION = "${DOCKER_COMPOSE_VERSION}"
    }
    tags = [
        "docker.io/${IMAGE_NAME}:18.04"
    ]
}
