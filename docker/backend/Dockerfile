FROM shiwarai/robotics_openproject_server:latest

SHELL ["/bin/bash", "-c"]
WORKDIR /robotics-openproject
COPY --chmod=777 openproject_run.sh /home/openproject_run.sh

ENTRYPOINT /home/openproject_run.sh
