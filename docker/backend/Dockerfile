FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

# Packages
RUN apt-get update
RUN apt-get install -y git curl build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libreadline-dev

ENTRYPOINT ["tail", "-f", "/dev/null"]

