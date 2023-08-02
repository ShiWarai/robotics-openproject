FROM shiwarai/robotics-openproject-builds:latest

# configuring bash console
SHELL ["bash", "-c"]
WORKDIR /robotics-openproject

RUN git clone https://github.com/ShiWarai/robotics-openproject.git --branch dev /robotics-openproject

COPY openproject_build.sh /home/openproject_build.sh
COPY openproject_migrate.sh /home/openproject_migrate.sh
COPY openproject_compile.sh /home/openproject_compile.sh
RUN /home/openproject_build.sh
RUN rm -rf /robotics-openproject/tmp/cache /robotics-openproject/tmp/pids

ENTRYPOINT /home/openproject_migrate.sh && /home/openproject_compile.sh
