# MiniTwit

Dockerized, SpringBoot conversion of [MiniTwit](https://github.com/eh3rrera/minitwit), a Twitter clone using Spark (Java), Spring, Freemarker, and HSQLDB.

New features in karlkfi/minitwit:
- Spring Boot
  - Enhanced ServerProperties config (env var, yaml, etc)
  - Executable jar
  - Logback logging, instead of slf4j-simple
- Docker container image

## Prerequisites

- Docker (container image includes all application dependencies)

## Build

1. Clone the repository and go to the root directory.

    ```
    git clone git@github.com:karlkfi/minitwit.git
    cd minitwit
    ```

1. Build the docker image

    ```
    docker build -t karlkfi/minitwit .
    ```

## Usage

1. Run the docker image in the background

    ```
    docker run -d --name minitwit -e "SERVER_PORT=80" karlkfi/minitwit
    ```

1. Find the docker container's IP

    ```
    MINITWIT_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' minitwit)
    ```

1. Open MiniTwit in your browser

    ```
    http://${MINITWIT_IP}:${SERVER_PORT}/
    ```

1. (Optional) Sign up as a new user

    If your e-mail address has an associated Gravatar image, this will be used as your profile image.

1. Log in

    Use the credentials created in the previous step or those of one of the following existing users:

    | Username | Password |
    |----------|----------|
    | user001 | user001 |
    | user002 | user002 |
    | ... | ... |
    | user010 | user010 |

##License
MIT License

See LICENSE for details.

- [Docker Springboot MiniTwit](https://github.com/karlkfi/minitwit) (c) 2016 Karl Isenberg
- [Java MiniTwit](https://github.com/eh3rrera/minitwit) (c) 2015 Esteban Herrera
- [Flask MiniTwit Example](https://github.com/pallets/flask/tree/master/examples/minitwit) (c) 2015 Armin Ronacher
