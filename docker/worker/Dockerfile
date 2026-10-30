FROM shiwarai/robotics_openproject_server:latest

SHELL ["/bin/bash", "-c"]
WORKDIR /robotics-openproject
COPY --chmod=777 openproject_run.sh /home/openproject_run.sh

ENTRYPOINT (socat TCP-LISTEN:3000,fork TCP:172.20.0.3:3000 &) && /home/openproject_run.sh
