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
    docker run -d --name minitwit karlkfi/minitwit
    ```

1. Find the docker container's IP

    ```
    MINITWIT_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' minitwit)
    ```

1. Open MiniTwit in your browser

    ```
    http://${MINITWIT_IP}:${SERVER_PORT}/
    ```

1. Sign up as a new user

    If your e-mail address has an associated Gravatar image, this will be used as your profile image.

1. Log in

    Use the credentials created in the previous step to log in.

1. Post a message

1. See your message added to the timeline

## Configuration

There are several ways to configure MiniTwit using Spring's ServerProperties, but only a few of them are being mapped to SparkJava.

The following environment variables can be passed to MiniTwit through Docker using environment variables:

| Name | Type | Default | Description |
|------|------|---------|-------------|
| SERVER_PORT | Integer | 80 | Port on which the server will listen |
| SPRING_DATASOURCE_URL | String | jdbc:hsqldb:<db-info> | JDBC path to the database |
| SPRING_DATASOURCE_USERNAME | String | jdbc:hsqldb:<db-info> | Database username |
| SPRING_DATASOURCE_PASSWORD | String | &lt;null&gt;| Database password |
| SPRING_DATASOURCE_DRIVER-CLASS-NAME | String | &lt;auto-detect&gt; | JDBC Driver class |
| SPRING_DATASOURCE_PLATFORM | String | hsqldb | Name of the platform-specific schema to use (hsqldb or mysql) |

## Databases

By default, MiniTwit uses HyperSQL as an in-memory database.

For persistent storage, use MySQL.

### Example MySQL Docker Deployment

```
# create mysql environment file
cat > mysql.env << EOF
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=minitwit
MYSQL_USER=minitwit
MYSQL_PASSWORD=minitwit
EOF

# start mysql server
docker run -d --name=mysql --env-file=mysql.env mysql:5.7.15

# find mysql IP
MYSQL_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' mysql)

# create minitwit environment file
cat > minitwit.env << EOF
SPRING_DATASOURCE_URL=jdbc:mysql://${MYSQL_IP}:3306/minitwit?autoReconnect=true&useSSL=false
SPRING_DATASOURCE_USERNAME=minitwit
SPRING_DATASOURCE_PASSWORD=minitwit
SPRING_DATASOURCE_DRIVER-CLASS-NAME=com.mysql.cj.jdbc.Driver
SPRING_DATASOURCE_PLATFORM=mysql
EOF

# start minitwit server
docker run -d --name minitwit --env-file=minitwit.env karlkfi/minitwit
```

##License
MIT License

See LICENSE for details.

- [Docker Springboot MiniTwit](https://github.com/karlkfi/minitwit) (c) 2016 Karl Isenberg
- [Java MiniTwit](https://github.com/eh3rrera/minitwit) (c) 2015 Esteban Herrera
- [Flask MiniTwit Example](https://github.com/pallets/flask/tree/master/examples/minitwit) (c) 2015 Armin Ronacher
