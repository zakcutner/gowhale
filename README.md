### :whale: gowhale

**A simple Dockerfile for compiling and running a generic Go project. It uses the [Alpine-flavoured Golang image](https://hub.docker.com/_/golang) to compile the project into a binary, and a minimal [scratch image](https://hub.docker.com/_/scratch) to run the program without root privileges and overhead.**

#### :electric_plug: Usage

Once the Dockerfile has been built, you are left with a scratch image that will run your binary, called `app`, with the `app` user. Certificates from Alpine Linux are also copied into the scratch image for use with TLS.

By default, `app` will simply be run with no arguments, you can [override `CMD`](https://docs.docker.com/engine/reference/run/#cmd-default-command-or-options) using Docker's run command. There is also similar functionality for users of Docker Compose.

```bash
$ docker run gopher:latest foo bar baz
```

> Note that by default, you cannot bind any ports below 1024 because the binary is run without root privileges. If you wish to change this behaviour, you can use the `sysctl` flag to allow any port to be used. Again, there is a similar configuration option to achieve this in Docker Compose.
>
> ```bash
> $ docker run --sysctl net.ipv4.ip_unprivileged_port_start=0 gopher:latest
> ```

##### Docker CLI

Docker's build command provides a [`-f` flag](https://docs.docker.com/engine/reference/commandline/build/#specify-a-dockerfile--f) which allows you to specify a Dockerfile in another location. You can use this flag to reference the Dockerfile in this repository (the command uses `.` to build the current directory).

```bash
$ curl https://raw.githubusercontent.com/zakcutner/gowhale/master/Dockerfile | docker build -f - .
```

##### Docker Compose

Docker Compose unfortunately does not allow you to use external Dockerfiles. However, you can easily clone this repository as a [Git sub-module](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to access the Dockerfile.

```bash
$ git submodule add https://github.com/zakcutner/gowhale.git
```

Once you've completed this you can point to the Dockerfile from the clone within your `docker-compose.yml` configuration (again, building the current directory).

```yaml
services:
  gopher:
    build:
      context: .
      dockerfile: gowhale/Dockerfile
```

Alternatively, simply clone this repository anywhere in your filesystem and refer to the Dockerfile in your configuration. This can be useful where many projects being built on the same machine all use this same Dockerfile.

#### :raised_hands: Attributions

Inspiration has been taken from the [official Docker image for the Caddy web server](https://github.com/caddyserver/caddy-docker). Thanks also to [this Moby issue](https://github.com/moby/moby/issues/8460) for providing the solution to binding low port numbers without root access.

#### :muscle: Contributions

If you have any suggestions for how this project could be improved, please [create an issue](https://github.com/zakcutner/gowhale/issues) or even [submit a pull request](https://github.com/zakcutner/gowhale/pulls). I am open to new ideas and I will try to respond quickly to contributions!
