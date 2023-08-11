FROM shiwarai/robotics-openproject-builds:latest

# configuring bash console
SHELL ["bash", "-c"]
WORKDIR /robotics-openproject

COPY --chmod=777 openproject_build.sh /home/openproject_build.sh
COPY --chmod=777 openproject_migrate.sh /home/openproject_migrate.sh
COPY --chmod=777 openproject_compile.sh /home/openproject_compile.sh
COPY --chmod=777 openproject_sources_pull.sh /home/openproject_sources_pull.sh

RUN /home/openproject_sources_pull.sh
COPY configuration.yml /robotics-openproject/config/configuration.yml

RUN /home/openproject_build.sh
RUN rm -rf /robotics-openproject/tmp/cache /robotics-openproject/tmp/pids

ENTRYPOINT /home/openproject_migrate.sh && /home/openproject_compile.sh
